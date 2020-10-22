//
//  CollectionList.swift
//  PickrUITests
//
//  Created by Amy Cheong on 21/10/20.
//

import XCTest

class CollectionListView {

    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    var addCollectionButton: XCUIElement { app.navigationBars.buttons[AI.CollectionListView.addButton] }
    var editCollectionButton: XCUIElement { app.buttons[AI.CollectionListView.editButton] }
    var firstCollectionButton: XCUIElement { app.buttons[AI.CollectionListView.collection(at: 1)] }
    var secondCollectionButton: XCUIElement { app.buttons[AI.CollectionListView.collection(at: 1)] }
}
