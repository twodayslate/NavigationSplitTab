import Foundation
import SwiftUI

public protocol EditingNavigationSplitTabViewProtocol: View {}

public struct EditingNavigationSplitTabView<ScreenIdentifier: ScreenIdentifierProtocol>: EditingNavigationSplitTabViewProtocol {
    @EnvironmentObject var model: NavigationSplitTabModel<ScreenIdentifier>

    public init() {}
    
    public var body: some View {
        Section("Visible") {
            ForEach(model.screens) { option in
                Text(option.title)
            }
            .onDelete { indexSet in
                let screens = indexSet.map({ model.screens[$0] })
                model.screens.remove(atOffsets: indexSet)
                screens.forEach { screen in
                    model.hiddenNavigationOptions.append(screen)
                }
            }
            .onMove { indexSet, offset in
                withAnimation {
                    self.model.objectWillChange.send()
                    self.model.screens.move(fromOffsets: indexSet, toOffset: offset)
                }
            }
        }
                
        Section("Hidden") {
            ForEach(model.hiddenNavigationOptions) { option in
                Text(option.title)
            }
            .onDelete { indexSet in
                let screens = indexSet.map({ model.hiddenNavigationOptions[$0] })
                model.hiddenNavigationOptions.remove(atOffsets: indexSet)
                screens.forEach { screen in
                    model.screens.append(screen)
                }
            }
            .onMove { indexSet, offset in
                withAnimation {
                    self.model.objectWillChange.send()
                    self.model.hiddenNavigationOptions.move(fromOffsets: indexSet, toOffset: offset)
                }
            }
        }
    }
}
