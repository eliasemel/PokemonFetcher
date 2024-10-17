//
//  MokePokemonService.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
class MockPokemonService: PokemonService {
    func fetchPokemons(url: URL) async throws -> PageContent<PokemonListItem> {
        .init()
    }
    
    func details(url: URL) async throws -> Pokemon {
        Pokemon(name: "test", height: 3, weight: 3)
    }
}

