//
//  ListViewModel.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
import Combine

typealias PokemonListState = LoadState<ContentPage<PokemonListItem>>

@MainActor
class ListViewModel: ObservableObject {
    private(set) var service: PokemonService
    
    @Published var state: PokemonListState = .empty
    
    init(service: PokemonService) {
        self.service = service
        self.state = .empty
        Task {
           await fetchPokes()
        }
    }
    
    
    /// Fetch the `ContentPage` for particular URL
    /// - Parameter url: The url to fetch
    func fetchPokes(url: URL = URL(string: "https://pokeapi.co/api/v2/pokemon")!) async {
        state = .loading
        do {
            let page = try await self.service.fetchPokemons(url: url)
            self.state = .loaded(page)
        } catch let error  {
            self.state = .failure(error as? PokemonError)
        }
    }
    
    
    /// Fetches the next `ContentPage`
    func nextPage() async {
        guard case .loaded(let currentPage) = state, let next = currentPage.next else {
            return
        }
        await fetchPokes(url: next)
    }
}
