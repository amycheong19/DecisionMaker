//
//  DecisionMakerApp.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import SwiftUI

@main
struct DecisionMakerApp: App {
    @StateObject private var model = DecisionMakerModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
