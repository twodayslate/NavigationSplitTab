import NavigationSplitTab

enum ScreenID: ScreenIdentifierProtocol {
    case homeScreen
    case profileScreen(profile: Profile)
    case settingsScreen
    case showMore
    
    var title: String {
        switch self {
        case .homeScreen:
            "Home"
        case .profileScreen(let profile):
            profile.name
        case .settingsScreen:
            "Settings"
        case .showMore:
            "More"
        }
    }
}
