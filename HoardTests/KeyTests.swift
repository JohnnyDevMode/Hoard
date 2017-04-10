//
//  KeyTests.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import XCTest
@testable import Hoard


class KeyTests : XCTestCase {

  func testFromInvalid() {
    XCTAssertEqual(Key.Invalid, Key.from())
    XCTAssertEqual(Key.Invalid, Key.from(segments: []))
  }
  
  func testFromVarargsSimpleKey() {
    let key = Key.from("key")
    XCTAssertNotNil(key as? SimpleKey)
    if let key = key as? SimpleKey {
      XCTAssertEqual("key", key.segment)
    }
  }
  
  func testFromArraySimpleKey() {
    let key = Key.from(segments: ["key"])
    XCTAssertNotNil(key as? SimpleKey)
    if let key = key as? SimpleKey {
      XCTAssertEqual("key", key.segment)
    }
  }
  
  func testFromVarargsComplexKey() {
    let key = Key.from("root", "mid", "leaf")
    XCTAssertNotNil(key as? ComplexKey)
    if let key = key as? ComplexKey {
      XCTAssertEqual("root", key.head)
    }
  }
  
  func testFromArrayComplexKey() {
    let key = Key.from(segments: ["root", "mid", "leaf"])
    XCTAssertNotNil(key as? ComplexKey)
    if let key = key as? ComplexKey {
      XCTAssertEqual("root", key.head)
    }
  }
  
}
