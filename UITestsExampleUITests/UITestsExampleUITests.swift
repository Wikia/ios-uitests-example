//
//  UITestsExampleUITests.swift
//  UITestsExampleUITests
//
//  Created by Rafał Kwiatkowski on 16/10/2020.
//

import XCTest

class UITestsExampleUITests: XCTestCase {

    private lazy var trackingVerifier = TrackingVerifier(with: self)
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        trackingVerifier.start()
    }

    override func tearDownWithError() throws {
        trackingVerifier.stop()
        super.tearDown()
    }

    func testTapButton1() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        trackingVerifier.start()
        let expectedEvent = TrackingEvent(name: "button_tapped", params: [
            .eventName: "button1_tapped",
            .screen: "main_screen",
            .custom(key: "screen_orientation"): "portrait"
        ])
        
        // When
        app.buttons["Button 1"].tap()
        
        // Then
        trackingVerifier.wait(for: expectedEvent)
    }
    
    func testTapButton2() throws {
        // Given
        let app = XCUIApplication()
        app.launch()
        let expectedEvent = TrackingEvent(name: "button_tapped", params: [
            .eventName: "button2_tapped",
            .screen: "main_screen",
            .custom(key: "screen_orientation"): "portrait"
        ])
        
        // When
        app.buttons["Button 2"].tap()
        
        // Then
        trackingVerifier.wait(for: expectedEvent)
    }
}
