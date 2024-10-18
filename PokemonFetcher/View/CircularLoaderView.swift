//
//  CircularLoaderView.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-18.
//

import SwiftUI

struct CircularLoaderView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5) // Adjust the size of the loader
                .padding()
            
            Text("Loading...")
                .font(.headline)
        }
    }
}

#Preview {
    CircularLoaderView()
}
