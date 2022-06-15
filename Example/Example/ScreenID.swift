//
//  ScreenID.swift
//  Example
//
//  Created by Zachary Gorak on 6/12/22.
//

import Foundation
import NavigationSplitTab
import SwiftUI

enum ScreenID: ScreenIdentifierProtocol {
    case settings
    case details(id: Int)
    case showMore

    var id: Int {
        self.hashValue
    }
    
    var title: String {
        switch self {
        case .showMore:
            return "More"
        case .settings:
            return "Settings"
        case .details(let id):
            return "Detail \(id)"
        }
    }
    
    var tabImage: Image {
        switch self {
        case .showMore:
            return Image(systemName: "ellipsis.circle")
        case .settings:
            return Image(systemName: "gear.circle")
        case .details(let id):
            return Image(systemName: "\(id).circle")
        }
    }
    
    var selectedTabImage: Image {
        switch self {
        case .showMore:
            return Image(systemName: "ellipsis.circle.fill")
        case .settings:
            return Image(systemName: "gear.circle.fill")
        case .details(let id):
            return Image(systemName: "\(id).circle.fill")
        }
    }
    
    var isDisabled: Bool {
        if case let .details(id) = self, id == 3 {
            return true
        }
        return false
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .showMore:
            ShowMoreView()
        case .settings:
            SettingsView()
        case .details(let id):
            DetailView(id: id)
        }
    }
    
    
}
