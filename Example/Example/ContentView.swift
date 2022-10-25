//
//  ContentView.swift
//  Example
//
//  Created by Zachary Gorak on 6/12/22.
//

import SwiftUI
import NavigationSplitTab

struct ContentView: View {
    @StateObject var model = NavigationSplitTabModel<ScreenID>(
        root: .settings,
        screens: [
        .settings,
        .details(id: 1),
        .details(id: 2, count: 200),
        .details(id: 3, count: 300),
        .details(id: 4, count: 400),
        .details(id: 5),
        .details(id: 6),
        .details(id: 7),
        .details(id: 8),
        .details(id: 9),
        .details(id: 10),
        ]
    )
    var body: some View {
        model.navigation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
