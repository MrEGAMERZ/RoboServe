//
//  GamesView.swift
//  FoodOrdering
//
//  Created by MAIN on 12/5/25.
//

// ==========================================
// File: Views/GamesView.swift
// ==========================================

import SwiftUI
import WebKit

struct GamesView: View {
    @Binding var selectedMode: ContentView.AppMode?
    @State private var selectedGame: String? = nil
    
    let games = [
        Game(name: "Tic Tac Toe", url: "https://playtictactoe.org/", emoji: "❌"),
        Game(name: "Puzzle", url: "https://www.jigidi.com/", emoji: "🧩"),
        Game(name: "Memory Game", url: "https://www.memozor.com/", emoji: "🎴"),
        Game(name: "Drawing", url: "https://sketch.io/sketchpad/", emoji: "🎨"),
        Game(name: "Math Games", url: "https://www.coolmathgames.com/", emoji: "🔢"),
        Game(name: "Word Search", url: "https://thewordsearch.com/", emoji: "🔤")
    ]
    
    var body: some View {
        if let gameUrl = selectedGame {
            WebGameView(url: gameUrl, selectedGame: $selectedGame, selectedMode: $selectedMode)
        } else {
            GamesMenuView(games: games, selectedGame: $selectedGame, selectedMode: $selectedMode)
        }
    }
}

struct Game: Identifiable {
    let id = UUID()
    let name: String
    let url: String
    let emoji: String
}

struct GamesMenuView: View {
    let games: [Game]
    @Binding var selectedGame: String?
    @Binding var selectedMode: ContentView.AppMode?
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.purple.opacity(0.2), Color.pink.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        selectedMode = nil
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.headline)
                        .foregroundColor(.purple)
                        .padding()
                    }
                    Spacer()
                }
                
                VStack(spacing: 20) {
                    Text("🎮")
                        .font(.system(size: 80))
                    
                    Text("Fun Games")
                        .font(.system(size: 42, weight: .bold))
                    
                    Text("Choose a game to play!")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(games) { game in
                            GameCard(game: game) {
                                selectedGame = game.url
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct GameCard: View {
    let game: Game
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Text(game.emoji)
                    .font(.system(size: 60))
                
                Text(game.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 150)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
        }
    }
}

struct WebGameView: View {
    let url: String
    @Binding var selectedGame: String?
    @Binding var selectedMode: ContentView.AppMode?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    selectedGame = nil
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Games")
                    }
                    .font(.headline)
                    .foregroundColor(.purple)
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    selectedGame = nil
                    selectedMode = nil
                }) {
                    Text("Home")
                        .font(.headline)
                        .foregroundColor(.purple)
                        .padding()
                }
            }
            .background(Color(UIColor.systemBackground))
            .shadow(radius: 2)
            
            WebView(url: URL(string: url)!)
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
