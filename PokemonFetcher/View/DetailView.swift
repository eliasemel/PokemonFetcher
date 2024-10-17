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
    
    private func mainView(state: LoadState<Pokemon>) -> AnyView {
        switch state {
            
        case .loaded(let pokemon):
            return AnyView(pokeView(pokemon: pokemon))
        case .failure:
            return AnyView(Text("oops something went wrong!!!"))
        case .loading:
            return AnyView(ProgressView().frame(width: 100, height: 100))
        }
    }
    
    private func pokeView(pokemon: Pokemon) -> some View {
        
        HStack {
            Spacer()
            VStack {
                Text(pokemon.name).font(.title).padding()
                Text("Height  ---> \(String(pokemon.height))" ).font(.subheadline)
                Text("Weight  ---> \(String(pokemon.weight))" ).font(.subheadline)
                Spacer()
                if let imageURL = pokemon.imageURL {
                    RemoteImage(url: imageURL)
                    Spacer()
                }
                
            }
            
            Spacer()
        }
        
    }
    
}

struct RemoteImage: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.af.setImage(withURL: url, completion:  { _ in
            uiView.backgroundColor = .white
        })
    }
}

#Preview {
    DetailView(model: .init(pokemon: .init(name: "dsefds", url: URL(string: "http://test.com")!), service: DefaultPokemonService()))
}
