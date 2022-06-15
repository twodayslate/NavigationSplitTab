import NavigationSplitTab
import SwiftUI

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
    
    var tabImage: Image {
        switch self {
        case .homeScreen:
            return Image(systemName: "house.circle")
        case .profileScreen(let profile):
            return profile.avatar
        case .settingsScreen:
            return Image(systemName: "gear.circle")
        case .showMore:
            return Image.init(systemName: "ellipsis.circle")
        }
    }
    
    var selectedTabImage: Image {
        switch self {
        case .homeScreen:
            return Image(systemName: "house.circle.fill")
        case .profileScreen(let profile):
            return profile.avatar
        case .settingsScreen:
            return Image(systemName: "gear.circle.fill")
        case .showMore:
            return Image.init(systemName: "ellipsis.circle.fill")
        }
    }
    
    var id: Int {
        return self.hashValue
    }
    
    var body: some View {
        switch self {
        case .homeScreen:
            return HomeView()
        case .profileScreen(let profile):
            return ProfileView(for: profile)
        case .settingsScreen:
            return SettingsView()
        case .showMore:
            return ShowMoreView()
        }
    }
}
