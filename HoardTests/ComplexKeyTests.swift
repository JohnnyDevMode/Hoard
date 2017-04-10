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
    XCTAssertEqual(Key.Invalid.segment, key.head)
    XCTAssertEqual(Key.Invalid.segment, key.segment)
    XCTAssertEqual(Key.Invalid, key.tail)
  }
  
  func testSingleSegmentInvalidTail() {
    let key = ComplexKey(segments: ["key"])
    XCTAssertEqual("key", key.head)
    XCTAssertEqual("key", key.segment)
    XCTAssertEqual(Key.Invalid, key.tail)
  }
  
  func testTwoSegment() {
    let key = ComplexKey(segments: ["root", "leaf"])
    XCTAssertEqual("root", key.head)
    XCTAssertEqual("root", key.segment)
    XCTAssertNotNil(key.tail as? SimpleKey)
    if let tail = key.tail as? SimpleKey {
      XCTAssertEqual("leaf", tail.segment)
    }
  }
  
  func testMultiSegment() {
    let key = ComplexKey(segments: ["root", "mid", "leaf"])
    XCTAssertEqual("root", key.head)
    XCTAssertEqual("root", key.segment)
    XCTAssertNotNil(key.tail as? ComplexKey)
    if let mid = key.tail as? ComplexKey {
      XCTAssertEqual("mid", mid.segment)
      XCTAssertNotNil(mid.tail as? SimpleKey)
      if let leaf = mid.tail as? SimpleKey {
        XCTAssertEqual("leaf", leaf.segment)
      }
    }
  }
  
  func testCrazySegment() {
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    XCTAssertEqual("root", key.head)
    XCTAssertEqual("root", key.segment)
    XCTAssertNotNil(key.tail as? ComplexKey)
    if let mid = key.tail as? ComplexKey {
      XCTAssertEqual("mid", mid.segment)
      XCTAssertNotNil(mid.tail as? ComplexKey)
      if let nextmid = mid.tail as? ComplexKey {
        XCTAssertEqual("nextmid", nextmid.segment)
        XCTAssertNotNil(nextmid.tail as? SimpleKey)
        if let leaf = nextmid.tail as? SimpleKey {
          XCTAssertEqual("leaf", leaf.segment)
        }
      }
    }
  }
}
