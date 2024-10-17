//
//  DefaultPokemonService.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
class DefaultPokemonService: PokemonService {
    func fetchPokemons(url: URL) async throws -> PageContent<PokemonListItem> {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let contentPage = try decoder.decode(PageContent<PokemonListItem>.self, from: data)
            return contentPage
        } catch let error {
            throw PokemonError.generic(error)
        }
    }
    
    func details(url: URL) async throws -> Pokemon {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let contentPage = try decoder.decode(Pokemon.self, from: data)
            return contentPage
        } catch let error {
            throw PokemonError.generic(error)
        }
    }
}
