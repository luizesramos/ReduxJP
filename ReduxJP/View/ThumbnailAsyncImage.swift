//
//  ThumbnailAsyncImage.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/30/22.
//

import SwiftUI

struct ThumbnailAsyncImage: View {
    let url: URL
    let imageSize: CGFloat
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    placeholderView
                    ProgressView()
                }
                
            case .failure:
                placeholderView
                
            case let .success(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(width: abs(imageSize), height: abs(imageSize))
                    .cornerRadius(10)
                
            @unknown default:
                placeholderView
            }
        }
    }
    
    private var placeholderView: some View {
        Color.gray.opacity(0.5)
            .frame(width: abs(imageSize), height: abs(imageSize))
    }
}

struct ThumbnailAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailAsyncImage(url: Preview.imageUrl, imageSize: 60)
    }
}
