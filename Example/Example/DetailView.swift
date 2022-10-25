//
//  DetailView.swift
//  Example
//
//  Created by Zachary Gorak on 6/12/22.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss

    var id: Int
    var count: Int = 1

    @State var contentOffset: CGFloat = .zero
    
    var body: some View {
        ScrollViewReader { reader in
            GeometryReader { outsideProxy in
                ScrollView {
                    ZStack(alignment: .top) {
                        GeometryReader { insideProxy in
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self, value: [self.calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)])
                        }

                        VStack {
                            EmptyView()
                                .id("top")
                            ForEach(1...count, id: \.self) { _ in
                                Text("\(id)")
                            }
                            if count > 1 {
                                NavigationLink(destination: DetailView(id: id, count: count - 1), label: {
                                    Text("Next")
                                        .frame(maxWidth: .infinity)
                                })
                            }
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .NavigationSplitTab.didSelect)) { obj in
                guard let item = obj.object as? ScreenID else {
                    return
                }

                if contentOffset > 0 {
                    reader.scrollTo("top")
                    return
                }

                if case let .details(id, _) = item, id == id {
                    dismiss()
                }
            }
        }
        .navigationTitle("Detail \(id)")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            self.contentOffset = value[0]
        }
    }

    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]

    static var defaultValue: [CGFloat] = [0]

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
