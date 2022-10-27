import Foundation
import SwiftUI

enum Style {
    static var horizontalPadding: CGFloat = 10
}

public protocol TabBarViewProtocol: View {
    associatedtype ScreenIdentifier: ScreenIdentifierProtocol
    var model: NavigationSplitTabModel<ScreenIdentifier> { get }
    var tabBarHeight: CGFloat { get }
}

public struct TabBarView<ScreenIdentifier: ScreenIdentifierProtocol>: TabBarViewProtocol {
    @EnvironmentObject public var model: NavigationSplitTabModel<ScreenIdentifier>
    
    @Environment(\.sizeCategory) var sizeCategory
    
    public init() {
        
    }
        
    public var tabBarHeight: CGFloat {
        //let safeArea = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom ?? 0
        // the safe area is going to give us some bottom padding so if we don't have that then we will add some ourself
        let min = 64.0
        switch sizeCategory {
        case .extraSmall:
            return min
        case .small:
            return min
        case .medium:
            return min
        case .large:
            return min
        case .extraLarge:
            return min + 10
        case .extraExtraLarge:
            return min + 10
        case .extraExtraExtraLarge:
            return min + 10
        case .accessibilityMedium:
            return min + 10
        case .accessibilityLarge:
            return min + 20
        case .accessibilityExtraLarge:
            return min + 20
        case .accessibilityExtraExtraLarge:
            return min + 20
        case .accessibilityExtraExtraExtraLarge:
            return min + 30
        @unknown default:
            return min
        }
    }
    
    @State var orientation = UIDevice.current.orientation

        let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
                Divider()
                    .ignoresSafeArea()
                
                ZStack {
                    Color.clear.ignoresSafeArea()
                        .background(.regularMaterial)
                        .ignoresSafeArea()
                    
                    VStack(alignment: .center, spacing: 0) {
                        GeometryReader { reader in
                            if model.allowsScrollingTabBar {
                                ScrollViewIfNeeded(.horizontal, showsIndicators: false) {
                                    tabItems(reader)
                                }.mask {
                                    LinearGradient(stops: [Gradient.Stop(color: Color.clear, location: 0), Gradient.Stop(color: .black, location: Style.horizontalPadding/reader.size.width), Gradient.Stop(color: .black, location: (reader.size.width-Style.horizontalPadding)/reader.size.width), Gradient.Stop(color: Color.clear, location: 1)], startPoint: .leading, endPoint: .trailing)
                                        .ignoresSafeArea()
                                }
                            } else {
                                tabItems(reader)
                            }
                        }
                    }
                }
        }
        .frame(height: tabBarHeight)
        .offset(y: model.shouldShowTabBar ? 0 : tabBarHeight * 2)
        .onReceive(orientationChanged) { _ in
                    self.orientation = UIDevice.current.orientation
                }
    }
    
    @ViewBuilder
    private func tabItems(_ reader: GeometryProxy) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            Spacer(minLength: 0)
            Group {
                if totalNumberOfTabs <= 0 {
                    button(for: ScreenIdentifier.showMore, size: reader.size)
                } else {
                    ForEach(model.screens.prefix(upTo: tabsToDisplayNotMore)) { option in
                        button(for: option, size: reader.size)
                    }
                    
                    if model.screens.count > model.tabItemLimit {
                        button(for: ScreenIdentifier.showMore, size: reader.size)
                    }
                }
            }
            .layoutPriority(1.0)
            Spacer(minLength: 0)
        }
        .padding(.trailing, 12)
    }
    
    var leftSizePaddingOffset: CGFloat {
        model.allowsScrollingTabBar ? 0 : orientation.isPortrait ? 2 : 1
    }
    
    var totalNumberOfTabs: Int {
        min(model.tabItemLimit, model.screens.count)
    }
    
    var tabsToDisplayNotMore: Int {
        model.screens.count <= model.tabItemLimit ? totalNumberOfTabs : totalNumberOfTabs - 1
    }
    
    @ViewBuilder
    private func button(for option: ScreenIdentifier, size: CGSize) -> some View {
        let leftPadding = 12.0
        let calcPadding = leftPadding * CGFloat(totalNumberOfTabs)
        let maxWidth = (size.width - (calcPadding)) / CGFloat(totalNumberOfTabs)
        
        let preferredSize = CGSize(width: maxWidth, height: size.height)
        
        Button {
            model.selectedScreen = option
            // if showMore is pressed then go back to showMore
            if option == .showMore {
                model.selectedScreenInMore = .showMore
            }
        } label: {
            option.tabItem(prefferedSize: preferredSize)
        }
        .padding(.leading, leftPadding)
        .disabled(option.isDisabled)
        //.fixedSize()
        //.frame(alignment: .center)
        
    }
}
