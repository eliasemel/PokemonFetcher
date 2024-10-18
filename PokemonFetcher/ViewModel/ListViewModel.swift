//
//  ListViewModel.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
import Combine

typealias PokemonListState = LoadState<PageContent<PokemonListItem>>

@MainActor
class ListViewModel: ObservableObject {
    private(set) var service: PokemonService
    
    //load with an empty contentpage
    @Published var state: PokemonListState = .loading
    
    init(service: PokemonService) {
        self.service = service
        Task {
            await fetchPokemones()
        }
    }
    
    /// Fetch the `ContentPage` for particular URL
    /// - Parameter url: The url to fetch
    func fetchPokemones(url: URL = URL(string: "https://pokeapi.co/api/v2/pokemon")!) async {
        switch state {
        case .loading:
            do {
                let newContentPage = try await self.service.fetchPokemons(url: url)
                self.state = .loaded(newContentPage)
            } catch let error  {
                self.state = .failure(error as? PokemonError)
            }
        case .loaded(let oldPage):
            do {
                let newPage = try await self.service.fetchPokemons(url: url)
                let updatedResult = oldPage.results + newPage.results
                let newContentPage = newPage.with(results: updatedResult)
                self.state = .loaded(newContentPage)
            } catch let error  {
                self.state = .failure(error as? PokemonError)
            }
        case .failure:
            print("no ops")
        }
        
    }
    
    
    /// Fetches the next `ContentPage`
    func nextPage() async {
        guard case .loaded(let currentPage) = state, let next = currentPage.next else {
            return
        }
        await fetchPokemones(url: next)
    }
}
