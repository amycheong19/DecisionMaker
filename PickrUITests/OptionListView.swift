//
//  OptionListView.swift
//  PickrUITests
//
//  Created by Amy Cheong on 21/10/20.
//

import XCTest

class OptionListView {

    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    var newOptionButton: XCUIElement { app.buttons[AI.OptionListView.newOptionButton] }
    var pickrButton: XCUIElement { app.buttons[AI.OptionListView.pickrButton] }
    var newOptionTextField: XCUIElement { app.textFields[AI.OptionRowView.newOptionTextField] }
    var firstOptionToggleButton: XCUIElement { app.switches.element(matching: .any, identifier: AI.OptionListView.option(at: 0)) }
    var secondOptionToggleButton: XCUIElement { app.switches.element(matching: .any, identifier: AI.OptionListView.option(at: 1)) }
    var thirdOptionToggleButton: XCUIElement { app.switches.element(matching: .any, identifier: AI.OptionListView.option(at: 2)) }
}

