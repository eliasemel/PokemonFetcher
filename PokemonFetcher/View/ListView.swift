//
//  ContentView.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = ListViewModel(service: DefaultPokemonService())
    
    var body: some View {
        switch viewModel.state {
        case .loaded(let page):
            NavigationView {
                List(page.results) { pokemon in
                    HStack {
                        Text(pokemon.name)
                            .font(.headline)
                    }
                    .onAppear {
                        let lastPokeMon = page.results.last
                        if lastPokeMon == pokemon {
                            Task {
                                await viewModel.nextPage()
                            }
                        }
                    }
                }
                .navigationTitle("Pokémon List")
            }
        default:
            EmptyView()
        }
    }
}

#Preview {
    ListView()
}
