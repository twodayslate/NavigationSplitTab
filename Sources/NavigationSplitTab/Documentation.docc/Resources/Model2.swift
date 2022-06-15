import SwiftUI
import NavigationSplitTabView

@StateObject var model = NavigationSplitTabModel(
    root: .rootView,
    screens: [
        ScreenID.homeScreen,
        ScreenID.profileScreen(profile: Profile.current),
        ScreenID.settingsScreen
    ],
    allowsScrollingTabBar: false
)
