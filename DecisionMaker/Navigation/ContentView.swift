//
//  ContentView.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import SwiftUI
import Mixpanel

struct ContentView: View {
    var body: some View {
        AppTabNavigation()
            .onAppear {
                let uuid = UUID().uuidString
                AnalyticsManager.shared.identify(distinctId: uuid)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
