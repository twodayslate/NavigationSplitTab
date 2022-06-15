//
//  SettingsView.swift
//  Example
//
//  Created by Zachary Gorak on 6/12/22.
//

import Foundation
import SwiftUI
import NavigationSplitTab

extension UISplitViewController.DisplayMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .automatic:
            return "automatic"
        case .secondaryOnly:
            return "secondaryOnly"
        case .oneBesideSecondary:
            return "oneBesidesSecondary"
        case .oneOverSecondary:
            return "oneOverSecondary"
        case .twoBesideSecondary:
            return "twoBesidesSecondary"
        case .twoOverSecondary:
            return "twoOverSecondary"
        case .twoDisplaceSecondary:
            return "twoDisplacesSecondary"
        @unknown default:
            return "unknown"
        }
    }
}

extension UserInterfaceSizeClass: CustomStringConvertible {
    public var description: String {
        switch self {
        case .regular:
            return "regular"
        case .compact:
            return "compact"
        @unknown default:
            return "unknown"
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var model: NavigationSplitTabModel<ScreenID>
    
    var body: some View {
        List {
            Section {
                Toggle("Allows Editing", isOn: $model.allowsEditing)
                Toggle("Allows Scrolling Tab Bar", isOn: $model.allowsScrollingTabBar)
                Picker("Preferred Split Behavior", selection: $model.preferredSplitBehavior) {
                    Text("Automatic")
                        .tag(UISplitViewController.SplitBehavior.automatic)
                    Text("Tile")
                        .tag(UISplitViewController.SplitBehavior.tile)
                    Text("Displace")
                        .tag(UISplitViewController.SplitBehavior.displace)
                    Text("Overlay")
                        .tag(UISplitViewController.SplitBehavior.overlay)
                }
                Picker("Display Mode Button Visibility", selection: $model.displayModeButtonVisibility) {
                    Text("Automatic")
                        .tag(UISplitViewController.DisplayModeButtonVisibility.automatic)
                    Text("Always")
                        .tag(UISplitViewController.DisplayModeButtonVisibility.always)
                    Text("Never")
                        .tag(UISplitViewController.DisplayModeButtonVisibility.never)
                }
            }
            
            Section {
                Text("Controller: \(model.controller?.description ?? "nil")")
                Text("Is editing: \(model.isEditing ? "Yes" : "No")")
                Text("Sidebar is open: \(model.sidebarIsOpen ? "Yes" : "No")")
                Text("Display mode: \(model.displayMode?.description ?? "nil")")
                Text("Tab bar size: \(model.tabBarSize.width)w \(model.tabBarSize.height)h")
                Text("Sidebar size: \(model.sidebarSize.width)w \(model.sidebarSize.height)h")
                Text("Horizontal Size Class: \(model.horizontalSizeClass?.description ?? "nil")")
            }
        }
        .navigationTitle("Settings")
    }
}
