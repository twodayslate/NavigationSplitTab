import SwiftUI

public protocol NavigationListviewProtocol: View { }

/// The default sidebar navigation for ``NavigationSplitTabView``
///
/// In a UISplitviewController this would be considered the master view if the sidebar is present
public struct NavigationListView<ScreenIdentifier: ScreenIdentifierProtocol, EditView: View>: NavigationListviewProtocol {
    @EnvironmentObject var model: NavigationSplitTabModel<ScreenIdentifier>

    @ViewBuilder var editingView: EditView
    
    public init(@ViewBuilder editingView: () -> EditView) {
        self.editingView = editingView()
    }
    
    public var body: some View {
        List {
            if model.isEditing {
                editingView
            } else {
                ForEach(model.screens) { option in
                    Button {
                        model.selectedScreen = option
                    } label: {
                        Label(title: {
                            Text(option.title)
                        }, icon: {
                            model.isSelected(option) ? option.selectedTabImage : option.tabImage
                        })
                    }
                    .disabled(option.isDisabled)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if model.allowsEditing {
                    Button(action: { model.isEditing.toggle() }, label: {
                        Text(model.isEditing ? "Done" : "Edit")
                    })
                }
            }
        }
        .listStyle(.sidebar)
        .navigationViewStyle(.stack)
        .navigationTitle("Navigation")
    }
}
