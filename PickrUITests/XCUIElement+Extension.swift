//
//  XCUIElement+Extension.swift
//  PickrUITests
//
//  Created by Amy Cheong on 21/10/20.
//

import XCTest

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
}
