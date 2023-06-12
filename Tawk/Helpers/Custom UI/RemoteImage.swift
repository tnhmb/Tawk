//
//  RemoteImage.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import SwiftUI

struct RemoteImage: View {
    let urlString: String
        @State private var image: UIImage? = nil
        
        var body: some View {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image("avatar")
                    .resizable()
                    .onAppear {
                        loadImage()
                    }
            }
        }
        
        private func loadImage() {
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Image download failed: \(error)")
                    return
                }
                
                if let data = data, let loadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = loadedImage
                    }
                }
            }.resume()
        }
}

