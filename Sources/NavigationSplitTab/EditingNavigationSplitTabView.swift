import Foundation
import SwiftUI

public protocol EditingNavigationSplitTabViewProtocol: View {}

public struct EditingNavigationSplitTabView<ScreenIdentifier: ScreenIdentifierProtocol>: EditingNavigationSplitTabViewProtocol {
    @EnvironmentObject var model: NavigationSplitTabModel<ScreenIdentifier>

    public init() {}
    
    public var body: some View {
        Section("Visible") {
            ForEach(model.screens) { option in
                Button {
                    model.hiddenNavigationOptions.append(option)
                    model.screens.removeAll(where: { $0 == option })
                } label: {
                    HStack {
                        Text(option.title)
                        Spacer()
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
                
        Section("Hidden") {
            ForEach(model.hiddenNavigationOptions) { option in
                Button {
                    model.screens.append(option)
                    model.hiddenNavigationOptions.removeAll(where: { $0 == option })
                } label: {
                    HStack {
                        Text(option.title)
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
    }
}
