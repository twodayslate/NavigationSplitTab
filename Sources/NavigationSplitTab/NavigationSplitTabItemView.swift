import Foundation
import SwiftUI

/// The default tab bar item view
public struct NavigationSplitTabItemView<ScreenIdentifier: ScreenIdentifierProtocol>: View {
    @EnvironmentObject var model: NavigationSplitTabModel<ScreenIdentifier>
    
    var screen: ScreenIdentifier
    var prefferedSize: CGSize
    
    public var body: some View {
        Label(title: {
            Text(screen.title)
        }, icon: {
            model.isSelected(screen) ? screen.selectedTabImage : screen.tabImage
        })
        .labelStyle(TabBarLabelStyle<ScreenIdentifier>(prefferedSize: prefferedSize))
        .foregroundColor(model.isSelected(screen) ? .accentColor : .gray)
        .opacity(screen.isDisabled ? 0.5 : 1.0)
    }
}

// MARK: - ScreenIdentifierProtocol

public extension ScreenIdentifierProtocol {
    /// The tab bar item for the screen
    /// - Parameter prefferedSize: The preferred size of the tab bar item
    /// - Returns: The screen's tab bar Item
    func tabItem(prefferedSize: CGSize = .zero) -> some View {
        NavigationSplitTabItemView(screen: self, prefferedSize: prefferedSize)
    }
}
