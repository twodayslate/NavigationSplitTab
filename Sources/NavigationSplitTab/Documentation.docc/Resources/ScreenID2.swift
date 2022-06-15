import NavigationSplitTabView

enum ScreenID: ScreenIdentifierProtocol {
    case homeScreen
    case profileScreen(profile: Profile)
    case settingsScreen
    case showMore
}
