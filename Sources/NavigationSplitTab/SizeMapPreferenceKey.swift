import Foundation
import SwiftUI

struct SizeMapPreferenceKey: PreferenceKey {
    static var defaultValue = [String: CGSize]()
    static func reduce(value: inout [String: CGSize], nextValue: () -> [String: CGSize]) {
        value.merge(nextValue(), uniquingKeysWith: { (_, new) in new })
  }
}

public extension View {
    
    func trackSize(forName name: String) -> some View {
        self.background {
            GeometryReader { reader in
                Color.clear.preference(key: SizeMapPreferenceKey.self, value: [name: reader.size])
            }
        }
    }
}
