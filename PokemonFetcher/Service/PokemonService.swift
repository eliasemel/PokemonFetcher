//
//  PokemonService.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation

protocol PokemonService {
    func fetchPokemons(url: URL) async throws -> PageContent<PokemonListItem>
    func details(url: URL) async throws -> Pokemon
}
