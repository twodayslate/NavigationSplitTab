import SwiftUI

/// A view that switches between multiple child views using interactive user interface elements.
public struct NavigationSplitTabView<ScreenIdentifier: ScreenIdentifierProtocol, ListView: NavigationListviewProtocol, TabBarView: TabBarViewProtocol>: View {
    // MARK: - Environment
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // MARK: - ObservedObjects
    @ObservedObject public var model: NavigationSplitTabModel<ScreenIdentifier>
    
    @ViewBuilder public var tabBarView: TabBarView
    public var listView: ListView
    
    
    public init(_ model: NavigationSplitTabModel<ScreenIdentifier>, @ViewBuilder listView: () -> ListView, @ViewBuilder tabBarView: () -> TabBarView) {
        self.model = model
        self.tabBarView = tabBarView()
        self.listView = listView()
    }
    
    // MARK: - body
    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                NavigationView {
                    if model.shouldOnlyShowDetailView {
                        model.selectedScreen
                            .onUIKitAppear(viewWillAppearAction: { controller in
                                model.controller = controller.splitViewController
                                withAnimation {
                                    model.sidebarIsOpen = false
                                }
                            })
                    } else {
                        listView
                            .onUIKitAppear(viewWillAppearAction: { controller in
                                model.controller = controller.splitViewController
                                withAnimation {
                                    model.sidebarIsOpen = true
                                }
                            }, viewWillDisappearAction: { controller in
                                model.controller = controller.splitViewController
                                withAnimation {
                                    model.sidebarIsOpen = false
                                }
                            })
                            .trackSize(forName: "sidebar")
                        
                        model.selectedScreen
                            .onUIKitAppear(viewWillAppearAction: { controller in
                                model.controller = controller.splitViewController
                            })
                    }
                }
                .frame(alignment: .top)
                
                tabBarView
                    .frame(maxHeight: model.shouldShowTabBar ? nil : 0)
                    .trackSize(forName: "tabbar")
            }
        }
        .ignoresSafeArea(.keyboard, edges: model.shouldShowTabBar ? .bottom : [])
        .environmentObject(model)
        .onAppear {
            model.horizontalSizeClass = horizontalSizeClass
        }
        .onChange(of: horizontalSizeClass, perform: {
            model.horizontalSizeClass = $0
        })
        .onPreferenceChange(SizeMapPreferenceKey.self, perform: { map in
            DispatchQueue.main.async {
                model.sizeMapping = map
            }
        })
    }
}
