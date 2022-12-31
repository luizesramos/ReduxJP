//
//  ScrollableLazyVGrid.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/30/22.
//

import SwiftUI

struct ScrollableLazyVGrid<Content: View, T: Hashable>: View {
    public var content: (T, CGFloat) -> Content
    public var config: GridConfiguration
    public var items: [T]
    
    public init(config: GridConfiguration = .init(),
                items: [T],
                @ViewBuilder content: @escaping (T, CGFloat) -> Content) {
        self.config = config
        self.items = items
        self.content = content
    }
    
    var body: some View {
        GeometryReader { g in
            let imageSize = config.imageSize(for: g.size)
            
            ScrollView {
                LazyVGrid(columns: config.gridItemLayout, spacing: config.gridSpacing) {
                    ForEach(items, id: \.self) { item in
                        content(item, imageSize)
                    }
                }
                .padding(4)
                .animation(.interactiveSpring(dampingFraction: 1, blendDuration: 3), value: config.gridItemLayout.count)
            }
        }
    }
}

struct GridConfiguration {
    let gridSpacing: CGFloat = 4
    let gridItemsPerRow: Int = 4
    
    var gridItemLayout: [GridItem] {
        let item = GridItem(.flexible(), spacing: gridSpacing)
        return (0 ..< gridItemsPerRow).reduce(into: []) { partialResult, _ in
            partialResult.append(item)
        }
    }
    
    func imageSize(for size: CGSize) -> CGFloat {
        let itemsPerRow = CGFloat(gridItemsPerRow)
        return (min(size.width, size.height) - (itemsPerRow * gridSpacing)) / itemsPerRow
    }
}
