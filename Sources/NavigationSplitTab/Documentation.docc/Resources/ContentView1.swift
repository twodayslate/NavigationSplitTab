import SwiftUI
import NavigationSplitTabView

struct ContentView: View {
    @StateObject var model = NavigationSplitTabModel(
        root: .rootView,
        screens: [
            ScreenID.homeScreen,
            ScreenID.profileScreen(profile: Profile.current),
            ScreenID.settingsScreen
        ])
    
    var body: some View {
        model.navigation()
    }
}
