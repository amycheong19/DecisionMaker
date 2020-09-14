//
//  AppTabNavigation.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import SwiftUI

struct AppTabNavigation: View {
    @State private var selection: Tab = .Pickr
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                Menu()
            }.tabItem {
                Label("Pickr", systemImage: "list.bullet")
                    .accessibility(label: Text("Picker"))
            }.tag(Tab.Pickr)
            
        }
    }
}

extension AppTabNavigation {
    enum Tab {
        case Pickr
        case settings
    }
}
