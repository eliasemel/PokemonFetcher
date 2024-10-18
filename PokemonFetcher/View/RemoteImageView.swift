//
//  RemoteImageView.swift
//  PokemonFetcher
//
//  Created by Emel Elias on 2024-10-18.
//

import SwiftUI

struct RemoteImageView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.af.setImage(withURL: url, completion:  { _ in
            uiView.backgroundColor = .white
        })
    }
}

#Preview {
    RemoteImageView(url: URL(string: "https://dummyimage.com/300")!)
}
