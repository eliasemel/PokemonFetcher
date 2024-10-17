//
//  ContentView.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            do {
                let t = try await DefaultPokemonService().fetchPokemons(url: URL(string: "https://pokeapi.co/api/v2/pokemon")!)
                print("%@", t)
            } catch {
                
            }
            
        }
    }
}

#Preview {
    ContentView()
}
