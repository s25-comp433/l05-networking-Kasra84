//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI


struct Game: Codable {
    var id: Int
    var team: String
    var date: String
    var opponent: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var games: [Game] = []
    
    var body: some View {
        
        NavigationView{
            List(games, id: \.id) { game in
                VStack(alignment: .leading){
                    Text("\(game.team)'s Game")
                        .font(.headline)
                    
                    Text("Opponent: \(game.opponent)")
                    HStack{
                        Text("Score: UNC \(game.score.unc)")
                        Spacer()
                        Text("-")
                        Spacer()
                        Text(" \(game.score.opponent) \(game.opponent)")
                    }
                    
                    Text("Date: \(game.date)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Location: \(game.isHomeGame ? "Home" : "Away")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("UNC Basketball Games")
        }
            .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else{
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data){
                games = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
        
    }
}

#Preview {
    ContentView()
}
