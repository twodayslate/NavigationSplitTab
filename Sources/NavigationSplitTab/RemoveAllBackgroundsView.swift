//
//  File.swift
//  
//
//  Created by Zachary Gorak on 6/14/22.
//

import Foundation
import SwiftUI

struct RemoveAllBackgroundsView: UIViewRepresentable {
    func removeBackground(_ view: UIView?) {
        guard let view = view else {
            return
        }
        view.backgroundColor = .clear
        removeBackground(view.superview)
    }
    func makeUIView(context: Context) -> UIView {
        let view = UILabel()
        DispatchQueue.main.async {
            removeBackground(view)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
