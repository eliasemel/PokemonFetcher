//
//  LoadState.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
/// Different Load states for UI
enum LoadState<Content> {
    case empty
    case loading
    case loaded(Content)
    case failure(PokemonError?)
}
