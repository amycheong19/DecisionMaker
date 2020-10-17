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
                    .accessibility(label: Text("Tab.Pickr.title"))
            }.tag(Tab.Pickr.title)
            
            NavigationView {
                Settings()
            }.tabItem {
                Label("Settings", systemImage: "gear")
                    .accessibility(label: Text("Tab.settings.title"))
            }.tag(Tab.settings.title)
        }
    }
}

extension AppTabNavigation {
    enum Tab {
        case Pickr
        case settings
        
        var title: String {
            switch self {
            case .Pickr:
                return "Pickr"
            case .settings:
                return "Settings"
            }
        }
    }
}
