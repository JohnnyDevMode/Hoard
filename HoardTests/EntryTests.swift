//
//  EntryTests.swift
//  Hoard
//
//  Created by John Bailey on 4/10/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import XCTest
@testable import Hoard


class EntryTests : XCTestCase {

  func testIsValidExpired() {
    let entry = Entry(value: "string", validFor: 0)
    XCTAssertFalse(entry.isValid)
  }
 
  func testIsValid() {
    let entry = Entry(value: "string", validFor: 60)
    XCTAssertTrue(entry.isValid)
  }
  
  func testIsValidAfterAccess() {
    let entry = Entry(value: "string", validFor: 0.1)
    XCTAssertTrue(entry.isValid)
    let exp = expectation(description: "Dispatch")
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
      XCTAssertFalse(entry.isValid)
      entry.access()
      XCTAssertTrue(entry.isValid)
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1 )) {
        XCTAssertFalse(entry.isValid)
        exp.fulfill()
      }
    }
    waitForExpectations(timeout: 5, handler: nil)
  }
  
}
