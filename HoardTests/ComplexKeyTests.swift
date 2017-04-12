//
//  ComplexKeyTests.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import XCTest
@testable import Hoard


class ComplexKeyTests : XCTestCase {
  
  func testNoSegmentsInvalid() {
    let key = ComplexKey(segments: [])
    XCTAssertEqual("INVALID", key.head)
    XCTAssertEqual(Key.Invalid, key.tail)
  }
  
  func testSingleSegmentInvalidTail() {
    let key = ComplexKey(segments: ["key"])
    XCTAssertEqual("key", key.head)
    XCTAssertEqual(Key.Invalid, key.tail)
  }
  
  func testTwoSegment() {
    let key = ComplexKey(segments: ["root", "leaf"])
    XCTAssertEqual("root", key.head)
    XCTAssertNotNil(key.tail as? SimpleKey)
    if let tail = key.tail as? SimpleKey {
      XCTAssertEqual("leaf", tail.key)
    }
  }
  
  func testMultiSegment() {
    let key = ComplexKey(segments: ["root", "mid", "leaf"])
    XCTAssertEqual("root", key.head)
    XCTAssertNotNil(key.tail as? ComplexKey)
    if let mid = key.tail as? ComplexKey {
      XCTAssertEqual("mid", mid.head)
      XCTAssertNotNil(mid.tail as? SimpleKey)
      if let leaf = mid.tail as? SimpleKey {
        XCTAssertEqual("leaf", leaf.key)
      }
    }
  }
  
  func testCrazySegment() {
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    XCTAssertEqual("root", key.head)
    XCTAssertNotNil(key.tail as? ComplexKey)
    if let mid = key.tail as? ComplexKey {
      XCTAssertEqual("mid", mid.head)
      XCTAssertNotNil(mid.tail as? ComplexKey)
      if let nextmid = mid.tail as? ComplexKey {
        XCTAssertEqual("nextmid", nextmid.head)
        XCTAssertNotNil(nextmid.tail as? SimpleKey)
        if let leaf = nextmid.tail as? SimpleKey {
          XCTAssertEqual("leaf", leaf.key)
        }
      }
    }
  }
}
