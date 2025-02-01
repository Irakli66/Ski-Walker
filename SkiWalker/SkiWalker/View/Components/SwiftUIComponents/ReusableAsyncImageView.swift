//
//  ReusableAsyncImageView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 18.01.25.
//
import SwiftUI

struct ReusableAsyncImageView: View {
    let url: String
    var width: CGFloat = 100
    var height: CGFloat = 100
    var cornerRadius: CGFloat = 10
    
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            } else if isLoading {
                ProgressView()
                    .frame(width: width, height: height)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.customGrey)
                    .frame(width: width, height: height)
                    .onAppear(perform: loadImage)
            }
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: url) else { return }
        
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            self.image = cachedImage
            return
        }
        
        isLoading = true
        URLSession.shared.dataTask(with: request) { data, response, _ in
            defer { isLoading = false }
            
            guard
                let data = data,
                let response = response,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let fetchedImage = UIImage(data: data)
            else {
                return
            }
            
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: request)
            
            DispatchQueue.main.async {
                self.image = fetchedImage
            }
        }.resume()
    }
}
