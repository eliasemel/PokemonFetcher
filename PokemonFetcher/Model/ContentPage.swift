//
//  ContentPage.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
/// Represents a page in response
struct ContentPage<Model: Decodable & Identifiable>: Decodable {
    
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [Model]
    
    init(count: Int = 0, next: URL? = nil, previous: URL? = nil, results: [Model] = []) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
    
    func with(results: [Model]) -> ContentPage {
        .init(
            count: self.count,
            next: self.next,
            previous: self.previous,
            results: results
        )
    }
}


extension ContentPage {
    
    var hasNext: Bool {
        self.next != nil
    }
}
