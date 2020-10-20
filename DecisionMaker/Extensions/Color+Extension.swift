//
//  Color+Extension.swift
//  Pickr
//
//  Created by Amy Cheong on 20/10/20.
//

import SwiftUI

extension Color {
    static var orangeG: Color {
        Color(red: 255/255, green: 129/255, blue: 38/255)
    }
    
    static var pinkG: Color {
        Color(red: 255/255, green: 17/255, blue: 126/255)
    }
    
    static var primaryGradientColor: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.orangeG, Color.pinkG]),
                       startPoint: .leading,
                       endPoint: .trailing)
    }
}
