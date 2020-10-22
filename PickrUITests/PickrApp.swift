//
//  PickrApp.swift
//  PickrUITests
//
//  Created by Amy Cheong on 21/10/20.
//

import XCTest

class PickrApp: XCUIApplication {

    override init() {
        super.init()
        launch()
    }

    func tap(_ element: XCUIElement) {
        guard element.waitForExistence(timeout: 1.0) else { return XCTFail("\(element) does not exist") }
        element.press(forDuration: 0.3) // Looks nicer in the App Preview recording
    }
    
    func forceTap(_ element: XCUIElement) {
        guard element.waitForExistence(timeout: 1.0) else { return XCTFail("\(element) does not exist") }
        element.forceTapElement()
    }


    func tap(_ coordinate: XCUICoordinate) {
        coordinate.tap()
    }

    func scrollUp(_ element: XCUIElement) {
        element.swipeDown()
    }

    func scrollDown(_ element: XCUIElement) {
        element.swipeUp()
    }

    func scrollLeft(_ element: XCUIElement) {
        element.swipeRight()
    }

    func scrollRight(_ element: XCUIElement) {
        element.swipeLeft()
    }

    func pause(for time: TimeInterval) {
        let e = XCTestExpectation()

        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            e.fulfill()
        }

        XCTWaiter().wait(for: [e], timeout: time + 1)
    }

    func screenshot(filename: String) {
        do {
            try screenshot().pngRepresentation.write(to: URL(fileURLWithPath: "/tmp/" + filename))
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

}
