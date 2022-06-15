import SwiftUI
import NavigationSplitTabView

public struct ListView<ScreenIdentifier: ScreenIdentifierProtocol>: NavigationListviewProtocol {
    @EnvironmentObject var model: NavigationSplitTabModel<ScreenIdentifier>
    
    var body: some View {
        List {
            ForEach(model.screens) { screen in
                Button {
                    model.selectedScreen = screen
                }, label {
                    Text("\(screen.title)")
                }
            }
        }
    }
}

struct TabBarView<ScreenIdentifier: ScreenIdentifierProtocol>: TabBarViewProtocol {
    @EnvironmentObject var model: NavigationSplitTabModel<ScreenIdentifier>
    
    var body: some View {
        HStack {
            ForEach(model.screens) { screen in
                Button {
                    model.selectedScreen = screen
                }, label {
                    screen.tabImage
                }
            }
        }
        .frame(height: 64.0)
    }
}

struct ContentView: View {
    @StateObject var model = NavigationSplitTabModel(
        root: .rootView,
        screens: [
            ScreenID.homeScreen,
            ScreenID.profileScreen(profile: Profile.current),
            ScreenID.settingsScreen
        ])
    
    var body: some View {
        NavigationSplitTabView(model, listView: {
            ListView()
        }, tabBarView: {
            TabBarView()
        })
    }
}
