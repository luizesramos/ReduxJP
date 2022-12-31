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
            Group {
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.5)
                        ProgressView()
                    }
                    
                case .failure:
                    Color.gray.opacity(0.5)
                    
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                    
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(10)
            .frame(width: abs(imageSize), height: abs(imageSize))
        }
    }
}

struct ThumbnailAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailAsyncImage(url: Preview.imageUrl, imageSize: 50)
    }
}
