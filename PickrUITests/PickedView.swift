//
//  PickedView.swift
//  PickrUITests
//
//  Created by Amy Cheong on 22/10/20.
//

import XCTest

class PickedCardView {

    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    var dismissButton: XCUIElement { app.buttons[AI.PickedCardView.dismissButton] }
    var backButton: XCUIElement { app.buttons[AI.PickedCardView.backButton] }
    var infoButton: XCUIElement { app.buttons[AI.PickedCardView.infoButton] }

    var voteLikeButton: XCUIElement { app.buttons[AI.PickedCardView.likeButton] }
}
