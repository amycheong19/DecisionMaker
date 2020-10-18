//
//  CardTitle.swift
//  Pickr
//
//  Created by Amy Cheong on 19/9/20.
//

import SwiftUI

/// Defines how the `Ingredient`'s title should be displayed in card mode
struct CardTitle {
    var color = Color.white
    var rotation = Angle.degrees(0)
    var offset = CGSize.zero
    var blendMode = BlendMode.normal
    var opacity: Double = 1
    var fontSize: CGFloat = 1
}


extension CardTitle {

    static let vertical = CardTitle(
        rotation: Angle.degrees(-90),
        offset: CGSize(width: -130, height: -60),
        blendMode: .difference,
        fontSize: 80.0
    )
    
}
