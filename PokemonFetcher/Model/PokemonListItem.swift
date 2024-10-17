//
//  PokemonListItem.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
struct PokemonListItem: Decodable {
    let name: String
    let url: URL
}


extension PokemonListItem: CustomStringConvertible {
    var description: String {
        "pokemon url :: \(url.absoluteURL)"
    }
}
