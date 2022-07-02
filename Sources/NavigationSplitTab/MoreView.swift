import Foundation
import SwiftUI

extension ScreenIdentifierProtocol {
    /// The default show more view
    public func ShowMoreView() -> some View {
        MoreView<Self, EditingNavigationSplitTabView<Self>> { EditingNavigationSplitTabView<Self>()
        }
    }
}


public struct MoreView<ScreenIdentifier: ScreenIdentifierProtocol, EditView: View>: View {
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
                notEditingView()
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("More", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if model.allowsEditing {
                    Button(action: { model.isEditing.toggle() }, label: {
                        Text(model.isEditing ? "Done" : "Edit")
                    })
                    .onAppear {
                        model.selectedScreenInMore = .showMore
                    }
                }
            }
        }
        .environment(\.editMode, Binding.constant(model.isEditing ? .active : .inactive))
    }
    
    @ViewBuilder
    private func notEditingView() -> some View {
        if model.screens.count <= model.tabItemLimit {
            ForEach(model.screens) { option in
                Button {
                    model.selectedScreen = option
                } label: {
                    Label(title: {
                        Text(option.title)
                    }, icon: {
                        option.tabImage
                    })
                }
                .disabled(option.isDisabled)
            }
        } else {
            let items = model.screens.suffix(from: model.tabItemLimit - 1)
            ForEach(items) { option in
                link(option)
            }
        }
    }
    
    func link(_ option: ScreenIdentifier) -> some View {
        NavigationLink(destination: {
            option
                .onUIKitAppear(viewWillAppearAction: { _ in
                    model.selectedScreenInMore = option
                })
        }, label: {
            Label(title: {
                Text(option.title)
            }, icon: {
                option.tabImage
            })
        })
        .disabled(option.isDisabled)
    }
}
