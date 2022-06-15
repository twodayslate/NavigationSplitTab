//
//  DetailView.swift
//  Example
//
//  Created by Zachary Gorak on 6/12/22.
//

import Foundation
import SwiftUI

struct DetailView: View {
    var id: Int
    
    var body: some View {
        Text("\(id)")
            .navigationTitle("Detail \(id)")
    }
}
