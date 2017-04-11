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
  
  func testAccessed() {
    let entry = Entry(value: "string", validFor: 1)
    let initial = entry.accessed
    let exp = expectation(description: "Dispatch")
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
      entry.access()
      let after = entry.accessed
      XCTAssertNotEqual(initial, after)
      exp.fulfill()
    }
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testDrift() {
    let entry = Entry(value: "string", validFor: 1)
    let exp = expectation(description: "Dispatch")
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
      let drift = entry.drift
      XCTAssertTrue(drift > 1)
      exp.fulfill()
    }
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testRot() {
    let entry = Entry(value: "string", validFor: 2)
    let exp = expectation(description: "Dispatch")
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
      let rot = entry.rot
      XCTAssertTrue(rot > 0.5)
      exp.fulfill()
    }
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testIsRotten() {
    let entry = Entry(value: "string", validFor: 2)
    let exp = expectation(description: "Dispatch")
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
      XCTAssertTrue(entry.isRotten) // Assuming 0.5 rot threshold.
      exp.fulfill()
    }
    waitForExpectations(timeout: 5, handler: nil)
  }
  
}
