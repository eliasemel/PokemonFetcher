//
//  Pokemon.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation

struct Pokemon: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case height
        case weight
        case sprites
        enum SpriteCodingKeys: String, CodingKey {
            case other
        
            enum OtherCodingKeys: String, CodingKey {
                case officialArtwork = "official-artwork"
                enum OfficialArtworkCodingKeys: String, CodingKey {
                    case frontDefault = "front_default"
                }
            }
        }
    }
    
    let name: String
    let height: Int
    let weight: Int
    let imageURL: URL?
    
    init(name: String, height: Int, weight: Int, imageURL: URL? = nil) {
        self.name = name
        self.height = height
        self.weight = weight
        self.imageURL = imageURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.height = try container.decode(Int.self, forKey: .height)
        self.weight = try container.decode(Int.self, forKey: .weight)
        
        do {
            let sprites = try container.nestedContainer(keyedBy: CodingKeys.SpriteCodingKeys.self, forKey: .sprites)
            let others =  try sprites.nestedContainer(keyedBy: CodingKeys.SpriteCodingKeys.OtherCodingKeys.self, forKey: .other)
            let artWork =  try others.nestedContainer(keyedBy: CodingKeys.SpriteCodingKeys.OtherCodingKeys.OfficialArtworkCodingKeys.self, forKey: .officialArtwork)
            imageURL = try artWork.decodeIfPresent(URL.self, forKey: .frontDefault)
        } catch {
            imageURL = nil
        }
        
    }
}


extension Pokemon: CustomStringConvertible {
    var description: String {
        "name :: \(name)"
    }
}
