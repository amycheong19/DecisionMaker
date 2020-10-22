//
//  PickrUITests.swift
//  PickrUITests
//
//  Created by Amy Cheong on 21/10/20.
//

import XCTest

class PickrUITests: XCTestCase {

    var app: PickrApp!
    var collectionListView: CollectionListView!
    var optionListView: OptionListView!
    var pickedCardView: PickedCardView!

    
    let tinyDelay: TimeInterval = 0.5
    let shortDelay: TimeInterval = 1.5
    let longDelay: TimeInterval = 4

    override func setUpWithError() throws {
        app = PickrApp()
        collectionListView = CollectionListView(app: app)
        optionListView = OptionListView(app: app)
        pickedCardView = PickedCardView(app: app)

    }
    
    func testPreview() throws {
                                
        // Create new collection
        app.screenshot(filename: "screenshot_1.png")
        app.forceTap(collectionListView.addCollectionButton)
        app.textFields.element.tap()
        app.textFields.element.typeText("Present ideas 🎁")
        app.buttons["Submit"].tap()
        
        app.screenshot(filename: "screenshot_4.png")
        
        //Tap the new collection
        app.tap(collectionListView.secondCollectionButton)

        // Add Option 1
        app.tap(optionListView.newOptionButton)
//        app.tap(optionListView.newOptionTextField)
        app.typeText("Toilet paper")
        app.pause(for: tinyDelay)
        app.keyboards.buttons["done"].tap()

        // Add Option 2
        app.tap(optionListView.newOptionButton)
//        app.tap(optionListView.newOptionTextField)
        app.typeText("Wine")
        app.pause(for: tinyDelay)
        app.keyboards.buttons["done"].tap()

        // Add Option 3
        app.tap(optionListView.newOptionButton)
//        app.tap(optionListView.newOptionTextField)
        app.typeText("Bag")
        app.pause(for: tinyDelay)
        app.keyboards.buttons["done"].tap()

        app.screenshot(filename: "screenshot_2.png")
        
        // Pickr options
        app.tap(optionListView.pickrButton)
        app.screenshot(filename: "screenshot_3.png")

        // Select buttons at PickedCard
        app.tap(pickedCardView.voteLikeButton)
        app.tap(pickedCardView.infoButton)
        app.tap(pickedCardView.backButton)
        app.tap(pickedCardView.dismissButton)
        
//        // Toggle buttons at PickedCard
//        app.tap(optionListView.firstOptionToggleButton)
//        app.tap(optionListView.secondOptionToggleButton)
//        app.tap(optionListView.thirdOptionToggleButton)
//        app.pause(for: tinyDelay)
    }
    
}

