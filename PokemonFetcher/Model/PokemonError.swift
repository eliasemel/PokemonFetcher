//
//  PokemonError.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
enum PokemonError: Error {
    case generic(Error)
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
}
