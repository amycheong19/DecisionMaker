//
//  AppTabNavigation.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import SwiftUI

struct AppTabNavigation: View {
    @State private var selection: Tab = .DecisionMaker
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                Menu()
            }.tabItem {
                Label("Where to Eat", systemImage: "list.bullet")
                    .accessibility(label: Text("Where to Eat"))
            }.tag(Tab.DecisionMaker)
            
        }
    }
}

extension AppTabNavigation {
    enum Tab {
        case DecisionMaker
        case settings
    }
}
