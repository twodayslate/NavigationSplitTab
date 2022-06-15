import Foundation
import SwiftUI

struct TabBarLabelStyle<ScreenIdentifier: ScreenIdentifierProtocol>: LabelStyle {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @EnvironmentObject var model: NavigationSplitTabModel<ScreenIdentifier>
    
    var prefferedSize: CGSize
    
    func makeBody(configuration: Configuration) -> some View {
            if horizontalSizeClass == .compact {
                VStack(alignment: .center, spacing: 0) {
                    Spacer(minLength: 0)
                    configuration.icon
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: prefferedSize.height/4, alignment: .bottom)
                        .padding(.bottom, 8)
                            
                    configuration.title
                        .fixedSize(horizontal: model.allowsScrollingTabBar, vertical: model.allowsScrollingTabBar)
                        .font(.caption)
                        .lineLimit(1)
                        .frame(alignment: .bottom)
                }
                .imageScale(.large)
                .padding(.vertical, 8)
                .frame(minWidth: model.allowsScrollingTabBar ? nil : prefferedSize.width, alignment: .center)
                .fixedSize(horizontal: model.allowsScrollingTabBar, vertical: false)
            } else {
                HStack(alignment: .center, spacing: 0) {
                    Spacer(minLength: 0)
                    configuration.icon
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 16, alignment: .trailing)
                        .padding(.trailing, 8)
                        
                    configuration.title
                        .font(.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                        .fixedSize(horizontal: model.allowsScrollingTabBar, vertical: model.allowsScrollingTabBar)
                    
                    Spacer(minLength: 0)
                }
                .imageScale(.large)
                .padding(.vertical, 8)
                .frame(minWidth: model.allowsScrollingTabBar ? nil : prefferedSize.width, minHeight: prefferedSize.height, alignment: .center)
                .fixedSize(horizontal: model.allowsScrollingTabBar, vertical: false)
            }
    }
}
