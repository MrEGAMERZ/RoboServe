//
//  File.swift
//  FoodOrdering
//
//  Created by MAIN on 12/21/25.

// ==========================================
// File: Views/PaymentView.swift
// ==========================================

import SwiftUI

struct PaymentView: View {
    @ObservedObject var viewModel: OrderViewModel
    @State private var selectedMethod: PaymentMethod = .upi
    @State private var showPaymentProcess = false
    
    var body: some View {
        ZStack {
            // Solid background to block view behind
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        viewModel.showPayment = false
                        viewModel.showCart = true
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back to Cart")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                    }
                    Spacer()
                    Text("Payment")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    // Empty space for balance
                    Color.clear.frame(width: 120)
                }
                .padding(.vertical, 10)
                .background(Color.white)
                .shadow(radius: 2)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Order Summary Card
                        OrderSummaryCard(viewModel: viewModel)
                            .padding(.horizontal)
                            .padding(.top, 20)
                        
                        // Payment Methods
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Select Payment Method")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(PaymentMethod.allCases) { method in
                                PaymentMethodButton(
                                    method: method,
                                    isSelected: selectedMethod == method
                                ) {
                                    selectedMethod = method
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                        
                        // Pay Button
                        Button(action: {
                            showPaymentProcess = true
                        }) {
                            HStack {
                                Image(systemName: "lock.fill")
                                Text("Pay ₹\(Int(viewModel.totalPrice))")
                                    .fontWeight(.bold)
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
                .background(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            }
            
            // Payment Processing Overlay
            if showPaymentProcess {
                PaymentProcessView(
                    method: selectedMethod,
                    amount: viewModel.totalPrice,
                    isShowing: $showPaymentProcess,
                    onSuccess: {
                        viewModel.showPayment = false
                        viewModel.placeOrder()
                    }
                )
            }
        }
    }
}

// Order Summary Card
struct OrderSummaryCard: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Order Summary")
                    .font(.headline)
                Spacer()
                Text("Table \(viewModel.tableNumber)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            ForEach(viewModel.cart.prefix(3)) { item in
                HStack {
                    Text("\(item.quantity)x \(item.menuItem.name)")
                        .font(.subheadline)
                    Spacer()
                    Text("₹\(Int(Double(item.quantity) * item.menuItem.price))")
                        .font(.subheadline)
                }
            }
            
            if viewModel.cart.count > 3 {
                Text("+ \(viewModel.cart.count - 3) more items")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            HStack {
                Text("Total Amount")
                    .font(.headline)
                Spacer()
                Text("₹\(Int(viewModel.totalPrice))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

// Payment Method Button
struct PaymentMethodButton: View {
    let method: PaymentMethod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: method.icon)
                    .font(.title2)
                    .foregroundColor(colorForMethod)
                    .frame(width: 50)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(method.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitleForMethod)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? colorForMethod : Color.clear, lineWidth: 2)
            )
            .shadow(radius: 2)
        }
    }
    
    var colorForMethod: Color {
        switch method {
        case .upi: return .purple
        case .card: return .blue
        case .cash: return .green
        }
    }
    
    var subtitleForMethod: String {
        switch method {
        case .upi: return "PhonePe, GPay, Paytm"
        case .card: return "Credit/Debit Card"
        case .cash: return "Pay at counter"
        }
    }
}

// Payment Processing View
struct PaymentProcessView: View {
    let method: PaymentMethod
    let amount: Double
    @Binding var isShowing: Bool
    let onSuccess: () -> Void
    
    @State private var currentStep: PaymentStep = .scanning
    @State private var progress: Double = 0.0
    
    enum PaymentStep {
        case scanning, processing, success
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture { }
            
            VStack(spacing: 30) {
                if method == .upi {
                    UPIPaymentView(
                        amount: amount,
                        currentStep: $currentStep,
                        progress: $progress
                    )
                } else if method == .card {
                    CardPaymentView(
                        amount: amount,
                        currentStep: $currentStep,
                        progress: $progress
                    )
                } else {
                    CashPaymentView(
                        amount: amount,
                        currentStep: $currentStep
                    )
                }
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(25)
            .shadow(radius: 20)
            .padding(40)
        }
        .onAppear {
            startPaymentProcess()
        }
    }
    
    func startPaymentProcess() {
        // Simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                currentStep = .processing
                progress = 0.5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                currentStep = .success
                progress = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            isShowing = false
            onSuccess()
        }
    }
}

// UPI Payment View
struct UPIPaymentView: View {
    let amount: Double
    @Binding var currentStep: PaymentProcessView.PaymentStep
    @Binding var progress: Double
    
    var body: some View {
        VStack(spacing: 25) {
            if currentStep == .scanning {
                // QR Code scanning
                VStack(spacing: 15) {
                    Image(systemName: "qrcode")
                        .font(.system(size: 120))
                        .foregroundColor(.purple)
                    
                    Text("Scan QR Code")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Open any UPI app to scan")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Simulated scanning animation
                    Rectangle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(height: 3)
                        .overlay(
                            Rectangle()
                                .fill(Color.purple)
                                .frame(height: 3)
                                .offset(x: -100)
                        )
                        .frame(width: 250)
                }
            } else if currentStep == .processing {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.purple)
                    
                    Text("Processing Payment...")
                        .font(.headline)
                    
                    Text("₹\(Int(amount))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    
                    Text("Payment Successful!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("₹\(Int(amount)) paid via UPI")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// Card Payment View
struct CardPaymentView: View {
    let amount: Double
    @Binding var currentStep: PaymentProcessView.PaymentStep
    @Binding var progress: Double
    
    var body: some View {
        VStack(spacing: 25) {
            if currentStep == .scanning {
                VStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue, Color.blue.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 280, height: 180)
                            .shadow(radius: 10)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Image(systemName: "wave.3.right")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("**** **** **** ****")
                                .font(.title3)
                                .foregroundColor(.white)
                                .tracking(3)
                            
                            HStack {
                                Text("TAP TO PAY")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                            }
                        }
                        .padding(20)
                        .frame(width: 280, height: 180)
                    }
                    
                    Text("Tap your card on the device")
                        .font(.headline)
                    
                    Image(systemName: "wave.3.forward.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                        .symbolEffect(.pulse)
                }
            } else if currentStep == .processing {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.blue)
                    
                    Text("Processing Payment...")
                        .font(.headline)
                    
                    Text("₹\(Int(amount))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    
                    Text("Payment Successful!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("₹\(Int(amount)) paid via Card")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// Cash Payment View
struct CashPaymentView: View {
    let amount: Double
    @Binding var currentStep: PaymentProcessView.PaymentStep
    
    var body: some View {
        VStack(spacing: 25) {
            if currentStep == .scanning {
                VStack(spacing: 20) {
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.green)
                    
                    Text("Cash Payment")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Please pay at the counter")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("₹\(Int(amount))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.green)
                }
            } else if currentStep == .processing {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.green)
                    
                    Text("Confirming Order...")
                        .font(.headline)
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    
                    Text("Order Confirmed!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Pay ₹\(Int(amount)) at counter")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
