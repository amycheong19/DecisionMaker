//
//  HapticGenerator.swift
//  Pickr
//
//  Created by Amy Cheong on 25/10/20.
//

import UIKit

struct HapticGenerator {
    static let generator = UINotificationFeedbackGenerator()

    static func successNotification (){
        self.generator.notificationOccurred(.success)
    }
    
    static func errorNotification (){
        self.generator.notificationOccurred(.error)
    }
    
    static func lightNotification (){
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    static func mediumNotification (){
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    static func changedNotification (){
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}
