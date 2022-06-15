import Foundation
import SwiftUI
import Combine

open class NavigationSplitTabModel<ScreenIdentifier: ScreenIdentifierProtocol>: ObservableObject {
    /// The split view provided by UIKit
    @Published public var controller: UISplitViewController? {
        didSet {
            controller?.preferredSplitBehavior = preferredSplitBehavior
            controller?.displayModeButtonVisibility = displayModeButtonVisibility
        }
    }
    
    /// A Boolean value that indicates the current open state of the sidebar
    ///
    /// - Returns:`true` when the sidebar is open, `false` otherwise
    @Published public var sidebarIsOpen: Bool = false
    
    /// The selected screen
    @Published public var selectedScreen: ScreenIdentifier {
        didSet {
            isEditing = screens.isEmpty
            if selectedScreenInMore != ScreenIdentifier.showMore, selectedScreen != ScreenIdentifier.showMore {
                selectedScreenInMore = ScreenIdentifier.showMore
            }
        }
    }
    
    /// The selected screen when inside the more view
    @Published public var selectedScreenInMore = ScreenIdentifier.showMore {
        didSet {
            isEditing = screens.isEmpty
        }
    }
    
    /// The available screens to navigation too
    @Published public var screens: [ScreenIdentifier] {
        didSet {
            if screens.isEmpty {
                isEditing = true
            }
        }
    }
    
    /// The screens that are currently hidden from navigation
    @Published public var hiddenNavigationOptions = [ScreenIdentifier]()
    
    /// A Boolean value that indicates whether the user is allowed to edit the screens
    @Published public var allowsEditing: Bool
    
    /// A Boolean value that indicates if the screens are currently being edited
    @Published public var isEditing = false {
        didSet {
            if !isEditing, screens.isEmpty {
                isEditing = true
            }
        }
    }
    
    /// - SeeAlso: ``UISplitViewController.displayModeButtonVisibility``
    @Published public var displayModeButtonVisibility: UISplitViewController.DisplayModeButtonVisibility
    
    /// - SeeAlso: ``UISplitViewController.preferredSplitBehavior``
    @Published public var preferredSplitBehavior: UISplitViewController.SplitBehavior
    
    /// A Boolean value that indicates if the tab bar allows for scrolling
    @Published public var allowsScrollingTabBar: Bool
    
    @Published var sizeMapping = [String: CGSize]()
    
    /// The current sidebar size
    public var sidebarSize: CGSize {
        sizeMapping["sidebar"] ?? .zero
    }
    
    /// The current size of the tab bar
    public var tabBarSize: CGSize {
        sizeMapping["tabbar"] ?? .zero
    }
    
    /// The current display mode
    ///
    ///  This is the ``controller``'s ``UISplitViewController.displayMode``
    ///
    ///  - SeeAlso: ``UISplitViewController.displayMode``
    public var displayMode: UISplitViewController.DisplayMode? {
        controller?.displayMode
    }
    
    /// The tracked horizontal size class
    @Published public var horizontalSizeClass: UserInterfaceSizeClass?
    
    /// The number of tab bar items to display if the horizontal size class is compact
    /// This value is used in ``tabItemLimit``
    public let compactTabItemLimit: Int
    /// The number of tab bar items to display if the horizontal size class is not compact
    /// This value is used in ``tabItemLimit``
    public let regularTabItemLimit: Int
    /// The number of tab bar items to display
    public var tabItemLimit: Int {
        horizontalSizeClass == .compact ? compactTabItemLimit : regularTabItemLimit
    }
    
    /// A Boolean value that indiates if the tab bar should always be shown
    @Published public var alwaysShowTabBar: Bool
    
    /// A Bolean value that indicates if the tab bar should be displayed
    public var shouldShowTabBar: Bool {
#if targetEnvironment(macCatalyst)
        return false
#else
        if alwaysShowTabBar {
            return true
        }

        if !sidebarIsOpen {
            return true
        }

        guard let displayMode = displayMode else {
            return true
        }
        
        if displayMode == .secondaryOnly {
            return true
        }
        
        return false
#endif
    }
    
    /// A Boolean value that indicates if the only the detail view should be displayed
    var shouldOnlyShowDetailView: Bool {
        horizontalSizeClass == .compact
    }
    
    // MARK: - Init/Deinit
    
    public init(
        root: ScreenIdentifier,
        screens: [ScreenIdentifier],
        hiddenNavigationOptions: [ScreenIdentifier] = [ScreenIdentifier](),
        allowsEditing: Bool = true,
        compactTabItemLimit: Int = 5,
        regularTabItemLimit: Int = 8,
        allowsScrollingTabBar: Bool = true,
        alwaysShowTabBar: Bool = false,
        prefferedSplitBehavior: UISplitViewController.SplitBehavior = .automatic,
        displayModeButtonVisibility: UISplitViewController.DisplayModeButtonVisibility = .automatic
    ) {
        self.selectedScreen = root
        self.screens = screens
        self.allowsEditing = allowsEditing
        self.hiddenNavigationOptions = hiddenNavigationOptions
        self.compactTabItemLimit = compactTabItemLimit
        self.regularTabItemLimit = regularTabItemLimit
        self.allowsScrollingTabBar = allowsScrollingTabBar
        self.alwaysShowTabBar = alwaysShowTabBar
        self.preferredSplitBehavior = prefferedSplitBehavior
        self.displayModeButtonVisibility = displayModeButtonVisibility
    }
    
    // MARK: - Open Functions
    
    /// Determine if a screen is selected
    ///
    /// A screen can be selected in the show more view
    ///
    /// - Parameter screen: The screen to evaluate
    /// - Returns: `true` is the screen is currently selected, `false` otherwise
    open func isSelected(_ screen: ScreenIdentifier) -> Bool {
        if selectedScreen == screen {
            return true
        }
        
        if selectedScreen == .showMore {
            return selectedScreenInMore == screen
        }
        
        return false
    }
    
    /// The navigation for this model
    @ViewBuilder open func navigation() -> some View {
        NavigationSplitTabView<ScreenIdentifier, NavigationListView<_, EditingNavigationSplitTabView<_>>, TabBarView>(self) {
            NavigationListView<ScreenIdentifier, EditingNavigationSplitTabView<_>> {
                EditingNavigationSplitTabView<ScreenIdentifier>()
            }
        } tabBarView: {
            TabBarView<ScreenIdentifier>()
        }
    }
}
