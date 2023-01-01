//
//  PhotoAsyncImage.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 1/1/23.
//

import SwiftUI

struct PhotoAsyncImage: View {
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    let url: URL
    let size: CGSize
    let scaleRange: ClosedRange<CGFloat> = (1 ... 4)
    
    var body: some View {
        AsyncImage(url: url, scale: scale) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .failure:
                Text("Something went wrong")
            case let .success(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width * scale, height: size.height * scale)
                    .gesture(magnificationGesture)
                    .onTapGesture(count: 2, perform: tapGesture)
                
            @unknown default:
                Text("Something went wrong")
            }
        }
    }
    
    var magnificationGesture: _EndedGesture<_ChangedGesture<MagnificationGesture>> {
        MagnificationGesture()
            .onChanged { val in
                let delta = val / self.lastScaleValue
                self.lastScaleValue = val
                scale = (self.scale * delta).clamped(to: self.scaleRange)
            }.onEnded { val in
                self.lastScaleValue = 1.0 // needed to handle the next gesture
            }
    }
    
    func tapGesture() {
        if abs(scaleRange.upperBound - scale) > abs(scaleRange.lowerBound - scale) {
            self.scale = scaleRange.upperBound
        } else {
            self.scale = scaleRange.lowerBound
        }
    }
}

private extension CGFloat {
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        if self < range.lowerBound {
            return range.lowerBound
        } else if self > range.upperBound {
            return range.upperBound
        } else {
            return self
        }
    }
}
