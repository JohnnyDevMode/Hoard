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
      XCTAssertEqual("key", key.key)
    }
  }
  
  func testFromArraySimpleKey() {
    let key = Key.from(segments: ["key"])
    XCTAssertNotNil(key as? SimpleKey)
    if let key = key as? SimpleKey {
      XCTAssertEqual("key", key.key)
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
  
  func testFromPathSimpleKey() {
    let key = "key".asKey()
    XCTAssertNotNil(key as? SimpleKey)
    if let key = key as? SimpleKey {
      XCTAssertEqual("key", key.key)
    }
  }
  
  func testFromPathComplexKey() {
    let key = "root/mid/leaf".asKey()
    XCTAssertNotNil(key as? ComplexKey)
    if let key = key as? ComplexKey {
      XCTAssertEqual("root", key.head)
    }
  }
  
  func testFromUrlSimpleKey() {
    let key = NSURL(string: "http://www.google.com")!.asKey()
    XCTAssertNotNil(key as? SimpleKey)
    if let key = key as? SimpleKey {
      XCTAssertEqual("www.google.com", key.key)
    }
  }
  
  func testFromUrlComplexKey() {
    let key = NSURL(string: "http://www.google.com/path/to/file.html")!.asKey()
    XCTAssertNotNil(key as? ComplexKey)
    if let key = key as? ComplexKey {
      XCTAssertEqual("www.google.com", key.head)
      var tail = key.tail as! ComplexKey
      XCTAssertEqual("path", tail.head)
      tail = tail.tail as! ComplexKey
      XCTAssertEqual("to", tail.head)
      let leaf = tail.tail as! SimpleKey
      XCTAssertEqual("file.html", leaf.key)
    }
  }
  
}
