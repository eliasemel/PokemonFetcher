//
//  MokePokemonService.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
class MockPokemonService: PokemonService {
    func fetchPokemons(url: URL) async throws -> PageContent<PokemonListItem> {
        return MockData.pokeMonList()
    }
    
    func details(url: URL) async throws -> Pokemon {
        return MockData.pokemon()
    }
}

