//
//  Option+SwiftUI.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import SwiftUI

// MARK: - SwiftUI.Image
extension Option {
    var image: Image {
        return Image("\(id)", label: Text(title))
            .renderingMode(.original)
    }
}
