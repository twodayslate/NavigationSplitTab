import SwiftUI
import NavigationSplitTab

struct ListView<ScreenIdentifier: ScreenIdentifierProtocol>: NavigationListviewProtocol {
    @EnvironmentObject var model: NavigationSplitTabModel<ScreenIdentifier>
    
    var body: some View {
        List {
            ForEach(model.screens) { screen in
                Button {
                    model.selectedScreen = screen
                    model.notificationCenter.post(name: .NavigationSplitTab.didSelect, object: option)
                } label: {
                    Text("\(screen.title)")
                }
            }
        }
    }
}

struct TabBarView<ScreenIdentifier: ScreenIdentifierProtocol>: TabBarViewProtocol {
    @EnvironmentObject var model: NavigationSplitTabModel<ScreenIdentifier>
    
    var tabBarHeight: CGFloat
    
    var body: some View {
        HStack {
            ForEach(model.screens) { screen in
                Button {
                    model.selectedScreen = screen
                    model.notificationCenter.post(name: .NavigationSplitTab.didSelect, object: option)
                } label: {
                    screen.tabImage
                }
            }
        }
        .frame(height: 64.0)
    }
}

struct ContentView: View {
    @StateObject var model = NavigationSplitTabModel<ScreenID>(
        root: .rootView,
        screens: [
            ScreenID.homeScreen,
            ScreenID.profileScreen(profile: Profile.current),
            ScreenID.settingsScreen
        ])
    
    var body: some View {
        NavigationSplitTabView(model, listView: {
            ListView<ScreenID>()
        }, tabBarView: {
            TabBarView<ScreenID>(tabBarHeight: 44)
        })
    }
}
