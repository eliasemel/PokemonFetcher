//
//  DetailViewModel.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
import Combine

@MainActor
class DetailViewModel: ObservableObject {
    
    @Published var state: LoadState<Pokemon> = .loading
    
    private let service: PokemonService
        
    init(pokemon: PokemonListItem, service: PokemonService) {
        self.service = service
        fetchDetails(pokemon)
    }
    
    func fetchDetails(_ pokeListItem: PokemonListItem) {
        Task {
            do {
                let details = try await service.details(url: pokeListItem.url)
                self.state = .loaded(details)
            } catch let error {
                self.state = .failure(error as? PokemonError)
            }
        }
    }
}
