//
//  IOS_TMDBUITests.swift
//  IOS_TMDBUITests
//
//  Created by huangtengwei on 2023/8/11.
//

import XCTest

final class IOS_TMDBUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testNowPlayingIsLoaded() {
        let grid = app.otherElements["now_playing_grid"]
        XCTAssertTrue(grid.waitForExistence(timeout: 5), "The movie lazygrid should be visible")
        
        let predicate = NSPredicate(format: "identifier CONTAINS 'item_'")
        let gridItems = grid.buttons.containing(predicate)
        XCTAssertGreaterThan(gridItems.count, 0, "There should be some items on the screen")
    }

    func testSearchPresent() throws {
        let nowPlayingTab = app.tabBars.buttons.element(boundBy: 0)
        nowPlayingTab.tap()
       
        let searchBtn = app.buttons["now_play_search_btn"]
        XCTAssert(searchBtn.waitForExistence(timeout: 5), "Search icon not show")
        searchBtn.tap()
        XCTAssertTrue(app.navigationBars["Search"].waitForExistence(timeout: 5))
        
    }
    
    func testSettings() throws {
        let settingsTab = app.tabBars.buttons.element(boundBy: 2)
        settingsTab.tap()
       
    }


    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(
                metrics: [
                  XCTClockMetric(),
                  XCTCPUMetric(),
                  XCTStorageMetric(),
                  XCTMemoryMetric()
                ]
              ) {
                  XCUIApplication().launch()
              }
        }
    }
}
