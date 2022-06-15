import Foundation
import SwiftUI

public protocol ScreenIdentifierProtocol: Hashable, Identifiable, View {
    static var showMore: Self { get }
    
    var title: String { get }
    var tabImage: Image { get }
    var selectedTabImage: Image { get }
    var isDisabled: Bool { get }
}
