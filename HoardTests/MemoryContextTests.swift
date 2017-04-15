//
//  MemoryContextTests.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import XCTest
@testable import Hoard


class MemoryContextTests : XCTestCase {

  func testPutSimple() {
    let context = MemoryContext()
    let key = SimpleKey(key: "key")
    context.put(key: key, value: "value")
    XCTAssertEqual("value", (context["key"] as! Entry).value as! String)
  }
  
  func testPutComplex() {
    let context = MemoryContext()
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    context.put(key: key, value: "value")
    let root : MemoryContext? = context.get(key: "root")
    let mid : MemoryContext? = root?.get(key: "mid")
    let nextmid : MemoryContext? = mid?.get(key: "nextmid")
    let value : String? = nextmid?.getLocal(key: "leaf")
    XCTAssertEqual("value", value)
  }

  func testGetSimpleMissing() {
    let context = MemoryContext()
    let key = SimpleKey(key: "key")
    let result : String? = context.get(key: key)
    XCTAssertNil(result)
  }
  
  func testGetSimple() {
    let context = MemoryContext()
    let key = SimpleKey(key: "key")
    context.put(key: key, value: "value")
    let result : String? = context.get(key: key)
    XCTAssertEqual("value", result)
  }
  
  func testGetSimpleWrongType() {
    let context = MemoryContext()
    let key = SimpleKey(key: "key")
    context.put(key: key, value: "value")
    let result : Int? = context.get(key: key)
    XCTAssertNil(result)
  }
  
  func testGetComplexMissing() {
    let context = MemoryContext()
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    let result : String? = context.get(key: key)
    XCTAssertNil(result)
  }
  
  func testGetComplex() {
    let context = MemoryContext()
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    context.put(key: key, value: "value")
    let result : String? = context.get(key: key)
    XCTAssertEqual("value", result)
  }
  
  func testGetComplexWrongType() {
    let context = MemoryContext()
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    context.put(key: key, value: "value")
    let result : Int? = context.get(key: key)
    XCTAssertNil(result)
  }
  
//  func testGetExpired() {
//    let context = MemoryContext()
//    let key = SimpleKey(key: "key")
//    context.put(key: key, value: "value", validFor: -1)
//    let result : String? = context.get(key: key)
//    XCTAssertNil(result)
//  }
  
  func testRemoveSimple() {
    let context = MemoryContext()
    let key = SimpleKey(key: "key")
    context.put(key: key, value: "value" as Any)
    XCTAssertNotNil(context.get(key: key))
    context.remove(key: key)
    XCTAssertNil(context.get(key: key))
  }
  
  func testRemoveComplex() {
    let context = MemoryContext()
    let key = ComplexKey(segments: ["root", "mid", "nextmid", "leaf"])
    context.put(key: key, value: "value" as Any)
    XCTAssertNotNil(context.get(key: key))
    context.remove(key: key)
    XCTAssertNil(context.get(key: key))
  }

//  func testChildrenEmpty() {
//    let context = MemoryContext()
//    let result : Set<String> = context.children()
//    XCTAssertEqual(0, result.count)
//  }
//  
//  func testChildren() {
//    let context = MemoryContext()
//    context.put(key: "key1", value: "value1")
//    context.put(key: "key2", value: "value2")
//    context.put(key: "key3", value: "value3")
//    let result : Set<String> = context.children()
//    XCTAssertEqual(3, result.count)
//  }
//  
//  func testChildrenFilters() {
//    let context = MemoryContext()
//    context.put(key: "key1", value: "value1")
//    context.put(key: "key2", value: 2)
//    context.put(key: "key3", value: "value3")
//    context.put(key: "key4", value: 4)
//    context.put(key: "key5", value: "value5")
//    let stringResult : Set<String> = context.children()
//    XCTAssertEqual(3, stringResult.count)
//    let intResults : Set<Int> = context.children()
//    XCTAssertEqual(2, intResults.count)
//  }
//  
  func testGetAsync() {
    let context = MemoryContext()
    let key = SimpleKey(key: "key")
    context.put(key: key, value: "value")
    let exp = expectation(description: "Callback")
    context.get(key: key) { (result: String?) in
      XCTAssertEqual("value", result)
      exp.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  func testGetAsyncNotFound() {
    let context = MemoryContext()
    let key = SimpleKey(key: "key")
    let exp = expectation(description: "Callback")
    context.get(key: key) { (result: String?) in
      XCTAssertNil(result)
      exp.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  func testGetAsyncWrongType() {
    let context = MemoryContext()
    let key = SimpleKey(key: "key")
    context.put(key: key, value: "value")
    let exp = expectation(description: "Callback")
    context.get(key: key) { (result: Int?) in
      XCTAssertNil(result)
      exp.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  func testGetAsyncCustomLoader() {
    let context = MemoryContext()
    let loaderExp = expectation(description: "Loader")
    let callbackExp = expectation(description: "Callback")
    context.get(key: "key", loader: { done in
      done("value")
      loaderExp.fulfill()
    }) { (result: String?) in
      XCTAssertEqual("value", result)
      callbackExp.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
  func testGetAsyncCustomLoaderNoResult() {
    let context = MemoryContext()
    let loaderExp = expectation(description: "Loader")
    let callbackExp = expectation(description: "Callback")
    context.get(key: "key", loader: { done in
      done(nil)
      loaderExp.fulfill()
    }) { (result: String?) in
      XCTAssertNil(result)
      callbackExp.fulfill()
    }
    waitForExpectations(timeout: 1.0, handler: nil)
  }
  
//  func testClean() {
//    let context = MemoryContext()
//    let key = SimpleKey(key: "key")
//    context.put(key: key, value: "value", validFor: -1)
//    context.clean()
//    XCTAssertNil(context["key"])
//  }
//  
//  func testCleanNested() {
//    let context = MemoryContext()
//    let key = ComplexKey(segments: ["complex", "key"])
//    context.put(key: key, value: "value", validFor: -1)
//    context.clean()
//    XCTAssertNil((context["complex"] as! MemoryContext)["key"])
//  }
//  
//  func testCleanChild() {
//    let context = MemoryContext()
//    let key = ComplexKey(segments: ["complex", "key"])
//    context.put(key: SimpleKey(key: "rootvalue"), value: "value", validFor: -1)
//    context.put(key: key, value: "value", validFor: -1)
//    (context.get(key: "complex") as Context?)?.clean(deep: false)
//    XCTAssertNotNil(context["rootvalue"])
//    XCTAssertNil((context["complex"] as! MemoryContext)["key"])
//  }
//  
  func testClear() {
    let context = MemoryContext()
    context.put(key: SimpleKey(key: "key"), value: "value")
    context.clear()
    XCTAssertNil(context["key"])
  }
  
  func testClearChild() {
    let context = MemoryContext()
    let key = ComplexKey(segments: ["complex", "key"])
    context.put(key: SimpleKey(key: "rootvalue"), value: "value")
    context.put(key: key, value: "value")
    (context.get(key: "complex") as Context?)?.clear()
    XCTAssertNotNil(context["rootvalue"])
    let complex : MemoryContext? = context.getLocal(key: "complex")
    XCTAssertNil(complex?["key"])
  }
}
