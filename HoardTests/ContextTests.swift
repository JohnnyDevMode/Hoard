//
//  ContextTests.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import XCTest
@testable import Hoard


class ContextTests : XCTestCase {

  func testContextForSimple() {
    let context = Context()
    let result = context.contextFor(key: SimpleKey(segment: "key"))
    XCTAssertEqual(context, result)
  }
  
  func testContextForInvalidRoot() {
    let context = Context()
    context["root"] = "value"
    let result = context.contextFor(key: ComplexKey(segments: ["root", "leaf"]))
    XCTAssertNil(result)
  }
  
  func testContextForChildContext() {
    let context = Context()
    let childContext = Context()
    context["root"] = childContext
    let result = context.contextFor(key: ComplexKey(segments: ["root", "leaf"]))
    XCTAssertEqual(childContext, result)
  }
  
  func testContextForNestedChildContext() {
    let context = Context()
    let rootContext = Context()
    context["root"] = rootContext
    let midContext = Context()
    rootContext["mid"] = midContext
    let result = context.contextFor(key: ComplexKey(segments: ["root", "mid", "leaf"]))
    XCTAssertEqual(midContext, result)
  }
  
  func testContextForDoubleNestedChildContext() {
    let context = Context()
    let rootContext = Context()
    context["root"] = rootContext
    let midContext = Context()
    rootContext["mid"] = midContext
    let nextMidContext = Context()
    midContext["nextmid"] = nextMidContext
    let result = context.contextFor(key: ComplexKey(segments: ["root", "mid", "nextmid", "leaf"]))
    XCTAssertEqual(nextMidContext, result)
  }
  
  func testContextForWithCreate() {
    let context = Context()
    let result = context.contextFor(key: ComplexKey(segments: ["root", "mid", "nextmid", "leaf"]))
    XCTAssertNotNil(result)
    XCTAssertEqual(result, (((context["root"] as! Context)["mid"] as! Context)["nextmid"] as! Context))
  }
 
  func testPutSimple() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    context.put(key: key, value: "value")
    XCTAssertEqual("value", (context["key"] as! Entry<String>).value)
  }
  
  func testPutComplex() {
    let context = Context()
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    context.put(key: key, value: "value")
    XCTAssertEqual("value", (((((context["root"] as! Context)["mid"] as! Context)["nextmid"] as! Context)["leaf"] as! Entry<String>)).value)
  }

  func testGetSimpleMissing() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    let result : String? = context.get(key: key)
    XCTAssertNil(result)
  }
  
  func testGetSimple() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    context.put(key: key, value: "value")
    let result : String? = context.get(key: key)
    XCTAssertEqual("value", result)
  }
  
  func testGetSimpleWrongType() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    context.put(key: key, value: "value")
    let result : Int? = context.get(key: key)
    XCTAssertNil(result)
  }
  
  func testGetComplexMissing() {
    let context = Context()
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    let result : String? = context.get(key: key)
    XCTAssertNil(result)
  }
  
  func testGetComplex() {
    let context = Context()
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    context.put(key: key, value: "value")
    let result : String? = context.get(key: key)
    XCTAssertEqual("value", result)
  }
  
  func testGetComplexWrongType() {
    let context = Context()
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    context.put(key: key, value: "value")
    let result : Int? = context.get(key: key)
    XCTAssertNil(result)
  }
  
  func testGetWithDefault() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    let result : String? = context.get(key: key, defaultValue: "value")
    XCTAssertEqual("value", result)
  }
  
  func testGetWithLoader() {
    let cache = Cache()
    let key = SimpleKey(segment: "key")
    let value = "value"
    let resultOne = cache.get(key: key) {
      return value
    }
    XCTAssertEqual(value, resultOne)
    let resultTwo : String? = cache.get(key: key)
    XCTAssertEqual(value, resultTwo)
  }
  
  func testGetExpired() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    context.put(key: key, value: "value", validFor: -1)
    let result : String? = context.get(key: key)
    XCTAssertNil(result)
  }
  
  func testRemoveSimple() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    context.put(key: key, value: "value" as Any)
    XCTAssertNotNil(context.get(key: key))
    context.remove(key: key)
    XCTAssertNil(context.get(key: key))
  }
  
  func testRemoveComplex() {
    let context = Context()
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    context.put(key: key, value: "value" as Any)
    XCTAssertNotNil(context.get(key: key))
    context.remove(key: key)
    XCTAssertNil(context.get(key: key))
  }

  func testChildrenEmpty() {
    let context = Context()
    let result : Set<String> = context.children(key: ComplexKey(segments: ["root", "mid"]))
    XCTAssertEqual(0, result.count)
  }
  
  func testChildren() {
    let context = Context()
    context.put(key: ComplexKey(segments: ["root", "mid", "leaf1"]), value: "value1")
    context.put(key: ComplexKey(segments: ["root", "mid", "leaf2"]), value: "value2")
    context.put(key: ComplexKey(segments: ["root", "mid", "leaf3"]), value: "value3")
    let result : Set<String> = context.children(key: ComplexKey(segments: ["root", "mid"]))
    XCTAssertEqual(3, result.count)
  }
  
  func testChildrenFilters() {
    let context = Context()
    context.put(key: ComplexKey(segments: ["root", "mid", "leaf1"]), value: "value1")
    context.put(key: ComplexKey(segments: ["root", "mid", "leaf2"]), value: 2)
    context.put(key: ComplexKey(segments: ["root", "mid", "leaf3"]), value: "value3")
    context.put(key: ComplexKey(segments: ["root", "mid", "leaf4"]), value: 4)
    context.put(key: ComplexKey(segments: ["root", "mid", "leaf5"]), value: "value5")
    let stringResult : Set<String> = context.children(key: ComplexKey(segments: ["root", "mid"]))
    XCTAssertEqual(3, stringResult.count)
    let intResults : Set<Int> = context.children(key: ComplexKey(segments: ["root", "mid"]))
    XCTAssertEqual(2, intResults.count)
  }
  
  func testGetAsync() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    context.put(key: key, value: "value")
    let exp = expectation(description: "Callback")
    context.getAsync(key: key) { (result: String?) in
      XCTAssertEqual("value", result)
      exp.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  func testGetAsyncNotFound() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    let exp = expectation(description: "Callback")
    context.getAsync(key: key) { (result: String?) in
      XCTAssertNil(result)
      exp.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  func testGetAsyncWrongType() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    context.put(key: key, value: "value")
    let exp = expectation(description: "Callback")
    context.getAsync(key: key) { (result: Int?) in
      XCTAssertNil(result)
      exp.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  func testGetAsyncCustomLoader() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    let loaderExp = expectation(description: "Loader")
    let callbackExp = expectation(description: "Callback")
    context.getAsync(key: key, loader: { done in
      done("value")
      loaderExp.fulfill()
    }) { (result: String?) in
      XCTAssertEqual("value", result)
      callbackExp.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  func testGetAsyncCustomLoaderNoResult() {
    let context = Context()
    let key = SimpleKey(segment: "key")
    let loaderExp = expectation(description: "Loader")
    let callbackExp = expectation(description: "Callback")
    context.getAsync(key: key, loader: { done in
      done(nil)
      loaderExp.fulfill()
    }) { (result: String?) in
      XCTAssertNil(result)
      callbackExp.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
}
