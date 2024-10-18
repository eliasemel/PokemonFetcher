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

class URLCachedDataFetchHelper: Datafetchable {
    private let useCache: Bool
    private let session: URLSession
    private let cache: URLCache
    private let cacheExpirationInterval: TimeInterval

    init(
        session: URLSession = .shared,
        cacheSize: Int = 10 * 1024 * 1024,
        useCache: Bool = true,
        cacheExpirationInterval: TimeInterval = 300 // 5 minutes in seconds
    ) {
        let memoryCapacity = cacheSize
        let diskCapacity = cacheSize * 2
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "pokemonCache")
        self.useCache = useCache
        self.session = session
        self.cache = cache
        self.cacheExpirationInterval = cacheExpirationInterval
        
        URLCache.shared = cache
    }

    func fetch<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        
        // Modify cache policy: Use cache or force reload
        request.cachePolicy = useCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
        
        // Custom Cache Control for Manual Expiration
        if let cachedResponse = cache.cachedResponse(for: request) {
            if shouldUseCachedResponse(cachedResponse: cachedResponse) {
                print("Data was served from the cache.")
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: cachedResponse.data)
                    return decodedData
                } catch {
                    throw PokemonError.decodingError(error)
                }
            } else {
                // Cache expired or invalid, remove cached response
                cache.removeCachedResponse(for: request)
            }
        }
        
        // Proceed with Network Request
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw PokemonError.invalidResponse
            }
            
            // Respect Server Caching if Provided
            if useCache, let cacheControl = httpResponse.value(forHTTPHeaderField: "Cache-Control"), !cacheControl.isEmpty {
                print("Using server-provided Cache-Control headers.")
            } else {
                // Manually Store Response with Timestamp if no server Cache-Control headers
                let cachedResponse = CachedURLResponse(response: response, data: data, userInfo: ["cacheDate": Date()], storagePolicy: .allowed)
                cache.storeCachedResponse(cachedResponse, for: request)
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

    private func shouldUseCachedResponse(cachedResponse: CachedURLResponse) -> Bool {
        // Check if the server already provided caching rules
        if let httpResponse = cachedResponse.response as? HTTPURLResponse,
           let cacheControl = httpResponse.value(forHTTPHeaderField: "Cache-Control"),
           !cacheControl.isEmpty {
            // Let the system decide based on server cache headers
            return true
        }
        
        // Otherwise, use custom expiration based on timestamp
        if let responseDate = cachedResponse.userInfo?["cacheDate"] as? Date {
            let age = Date().timeIntervalSince(responseDate)
            return age < cacheExpirationInterval
        }
        
        return false
    }
}
