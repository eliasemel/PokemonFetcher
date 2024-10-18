//
//  CacheHelper.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-17.
//

import Foundation
protocol Datafetchable {
    func fetch<T: Decodable>(url: URL) async throws -> T
}

class URLCacheDataFetchHelper: Datafetchable {
    private let useCache: Bool
    private let session: URLSession
    private let cache: URLCache
    init(
        session: URLSession = .shared,
        cacheSize: Int = 10 * 1024 * 1024,
        useCache: Bool = true
    ) { // 10MB cache size
        let memoryCapacity = cacheSize // In-memory cache size
        let diskCapacity = cacheSize * 2 // Disk cache size
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "pokemonCache")
        self.useCache = useCache
        self.session = session
        self.cache = cache
        
        // Set the URLCache for URLSession
        URLCache.shared = cache
    }
    /*
     eg
     GET /api/pokemon-list HTTP/1.1
     Host: example.com
     Cache-Control: max-age=5
     */
    // Generic method to fetch data and decode it with caching and cache control
    func fetch<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        
        // Modify cache policy: Use cache or force reload
        request.cachePolicy = useCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
        
        // Set custom cache headers if needed (e.g., override Cache-Control)
        if !useCache {
            request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        }
        let cacheControlHeader = "max-age=\(Int(5))"
        request.addValue(cacheControlHeader, forHTTPHeaderField: "Cache-Control")
        do {
            let (data, response) = try await session.data(for: request)
            
            // Check for HTTP errors
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw PokemonError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw PokemonError.decodingError(error)
            }
        } catch {
            throw PokemonError.networkError(error)
        }
    }
}
