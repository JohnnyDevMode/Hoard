//
//  TraversableContextTests.swift
//  Hoard
//
//  Created by John Bailey on 4/14/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import XCTest
@testable import Hoard

class TraversableContextTests : XCTestCase {
  
  func testContextForSimple() {
    let context = TraversableContext()
    let result = context.contextFor(key: SimpleKey(key: "key")) as! TraversableContext
    XCTAssertEqual(context, result)
  }

  func testContextForChildContext() {
    let context = TraversableContext()
    let childContext = TraversableContext()
    context.childContexts["root"] = childContext
    let result = context.contextFor(key: ComplexKey(segments: ["root", "leaf"])) as! TraversableContext
    XCTAssertEqual(childContext, result)
  }
  
  func testContextForNestedChildContext() {
    let context = TraversableContext()
    let rootContext = TraversableContext()
    context.childContexts["root"] = rootContext
    let midContext = TraversableContext()
    rootContext.childContexts["mid"] = midContext
    let result = context.contextFor(key: ComplexKey(segments: ["root", "mid", "leaf"])) as! TraversableContext
    XCTAssertEqual(midContext, result)
  }
  
  func testContextForDoubleNestedChildContext() {
    let context = TraversableContext()
    let rootContext = TraversableContext()
    context.childContexts["root"] = rootContext
    let midContext = TraversableContext()
    rootContext.childContexts["mid"] = midContext
    let nextMidContext = TraversableContext()
    midContext.childContexts["nextmid"] = nextMidContext
    let result = context.contextFor(key: ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])) as! TraversableContext
    XCTAssertEqual(nextMidContext, result)
  }
  
  func testContextForWithCreate() {
    let context = TraversableContext()
    let result = context.contextFor(key: ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])) as! TraversableContext
    XCTAssertNotNil(result)
    let root : TraversableContext? = context.get(key: "root")
    let mid : TraversableContext? = root?.get(key: "mid")
    let nextmid : TraversableContext? = mid?.get(key: "nextmid")
    XCTAssertEqual(result, nextmid)
  }
  
  func testContextForWithCreateSetsExpiry() {
    let context = TraversableContext()
    context.expiry = 99
    let result = context.contextFor(key: ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])) as! TraversableContext
    XCTAssertNotNil(result)
    let root : TraversableContext? = context.get(key: "root")
    XCTAssertEqual(99, root!.expiry)
    let mid : TraversableContext? = root?.get(key: "mid")
    XCTAssertEqual(99, mid!.expiry)
    let nextmid : TraversableContext? = mid?.get(key: "nextmid")
    XCTAssertEqual(result, nextmid)
    XCTAssertEqual(99, result.expiry)
  }
  
  

}

