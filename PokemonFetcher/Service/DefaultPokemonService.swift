//
//  DefaultPokemonService.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
class DefaultPokemonService: PokemonService {
    let datafetchable: Datafetchable
    
    init(datafetchable: Datafetchable) {
        self.datafetchable = datafetchable
    }
    
    func fetchPokemons(url: URL) async throws -> PageContent<PokemonListItem> {
        try await self.datafetchable.fetch(url: url)
    }
    func details(url: URL) async throws -> Pokemon {
        try await self.datafetchable.fetch(url: url)
    }
}

