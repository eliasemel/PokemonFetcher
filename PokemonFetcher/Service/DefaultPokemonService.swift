//
//  DefaultPokemonService.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
class DefaultPokemonService: PokemonService {
    let cacheHelper: CacheDataFetchHelper
    
    init(cacheHelper: CacheDataFetchHelper) {
        self.cacheHelper = cacheHelper
    }
    
    func fetchPokemons(url: URL) async throws -> PageContent<PokemonListItem> {
        try await self.cacheHelper.fetchData(url: url, useCache: false)
    }
    func details(url: URL) async throws -> Pokemon {
        try await self.cacheHelper.fetchData(url: url, useCache: false)
    }
}

