//
//  DetailView.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import SwiftUI
import UIKit
import AlamofireImage

struct DetailView: View {
    
    @StateObject var model: DetailViewModel
        
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                mainView(state: model.state)
                Spacer()
            }
            Spacer()
        }
        .background(.white)
    }
    
    @ViewBuilder
    private func mainView(state: LoadState<Pokemon>) -> some View {
        switch state {
            
        case .loaded(let pokemon):
            pokeView(pokemon: pokemon)
        case .failure:
            Text("oops something went wrong!!!")
        case .loading:
            CircularLoaderView()
        }
    }
    
    @ViewBuilder
    private func pokeView(pokemon: Pokemon) -> some View {
        HStack {
            Spacer()
            VStack {
                Text(pokemon.name).font(.title).padding()
                Text("Height  ---> \(String(pokemon.height))" ).font(.subheadline)
                Text("Weight  ---> \(String(pokemon.weight))" ).font(.subheadline)
                Spacer()
                if let imageURL = pokemon.imageURL {
                    RemoteImageView(url: imageURL)
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

#Preview {
    DetailView(model: .init(pokemon: .init(name: "dsefds", url: URL(string: "http://test.com")!), service: MockPokemonService()))
}
