## Integration Testing

Integration Testing is a different concept to Unit Testing. It is the idea of testing changes in aggregate, as opposed to individual units. The aim is to have a lot of the finer-grained ( thinner brush ) tests covered by unit testing, then Integration Testing will help you deal with larger ideas ( a paint roller. )

Within the context of Cocoa, integration tests generally means writing tests against things you have no control over. Which you could argue is all of UIKit, but hey, gotta do that to build an app. Seriously though, UIKit is the most common thing against which people have done integration testing.

### UI Testing

UI Testing involves running your app as though there was a human on the other side tappig buttons, waiting for animations and filling in all of bits of data. The APIs make it easy to make tests like "If I've not added an email, is the submit button disabled?"  and "After hitting submit with credentials, do it go to the home screen?" These let you write tests pretty quickly ( it's now built into Xcode ) and it can be used to provide a lot of coverage fast.

 The tooling for in the OSS world is pretty mature now. The dominant player is [Square's KIF](https://github.com/square/kif). [KIF's tests](https://github.com/mozilla/firefox-ios/blob/451665a7239c46cf2be3f47e3c903d88d2d710ec/UITests/ReaderViewUITests.swift#L8) generally look like this:

 ``` swift
 class ReaderViewUITests: KIFTestCase, UITextFieldDelegate {
   [...]
   func markAsReadFromReaderView() {
       tester().tapViewWithAccessibilityLabel("Mark as Read")
       tester().tapViewWithAccessibilityIdentifier("url")
       tester().tapViewWithAccessibilityLabel("Reading list")
       tester().swipeViewWithAccessibilityLabel("Reader View Test", inDirection: KIFSwipeDirection.Right)
       tester().waitForViewWithAccessibilityLabel("Mark as Unread")
       tester().tapViewWithAccessibilityLabel("Cancel")
   }
   [...]
 }
 ```

 Where KIF will look or wait for specific views in the view hierarchy, then perform some actions. Apple's version of KIF is similar, but different. It works by having a completely different test target just for UI Integration Tests, separate from your Unit Tests. It can build out your testsuite much faster, as it can record the things you click on in Xcode, and save those to your source files in Xcode.

 These tests look like vanilla XCTest, here's some examples from [Deck-Tracker](https://github.com/raiden007/Deck-Tracker/blob/aa6aba5dbfb2762f6e45aab9749c28fa5e8329c4/Deck%20TrackerUITests/About.swift)

 ``` swift
 class About: XCTestCase {

     let backButton = XCUIApplication().navigationBars["About"].buttons["Settings"]
     let aboutTitleScreen = XCUIApplication().navigationBars["About"].staticTexts["About"]
     let hearthstoneImage = XCUIApplication().images["Hearthstone About"]
     [...]

     override func setUp() {
         super.setUp()
         continueAfterFailure = false
         XCUIApplication().launch()
         let app = XCUIApplication()
         app.navigationBars["Games List"].buttons["More Info"].tap()
         app.tables.staticTexts["About"].tap()
     }

     func testElementsOnScreen() {
         XCTAssert(backButton.exists)
         XCTAssert(aboutTitleScreen.exists)
         XCTAssert(hearthstoneImage.exists)
         XCTAssert(versionNumberLabel.exists)
         XCTAssert(createdByLabel.exists)
         XCTAssert(emailButton.exists)
         XCTAssert(nounIconsLabel.exists)
     }
    [...]
 }

 ```

There are some good up-sides to this approach,

### API Testing

If you have a staging
