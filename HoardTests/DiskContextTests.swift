//
//  DiskContext.swift
//  Hoard
//
//  Created by John Bailey on 4/14/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import XCTest
@testable import Hoard


class DiskContextTests : XCTestCase {
  
  let fileManager = FileManager.default
  var directoryUrl : URL?
  
  class TestPersistable : Persistable {
    
    let value : String
    
    init(value: String) {
      self.value = value
    }
    
    required init?(data: Data) {
      self.value = String(data: data, encoding: .utf8)!
    }
    
    func asData() -> Data? {
      return "data out".data(using: .utf8)
    }

  }
  
  override func setUp() {
    do {
      directoryUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString, isDirectory: true)
      try fileManager.createDirectory(at: directoryUrl!, withIntermediateDirectories: true, attributes: nil)
    } catch {
      print("Failed to create temp directory")
      XCTFail()
    }
  }
  
  func testDataPut() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let data = "Some String".data(using: .utf8)
    context.put(key: "file", value: data)
    let path = "\(directoryUrl!.path)/file"
    XCTAssertTrue(fileManager.fileExists(atPath: path))
    let stored = try! Data(contentsOf: directoryUrl!.appendingPathComponent("file"), options: .uncached)
    XCTAssertEqual(data, stored)
  }
  
  func testDataPutComplex() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let data = "Some String".data(using: .utf8)
    context.put(key: "path/to/file", value: data)
    let path = "\(directoryUrl!.path)/path/to/file"
    XCTAssertTrue(fileManager.fileExists(atPath: path))
    let stored = try! Data(contentsOf: directoryUrl!.appendingPathComponent("path/to/file"), options: .uncached)
    XCTAssertEqual(data, stored)
  }
  
  func testContextPut() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let childContext = MemoryContext()
    context.put(key: "child", value: childContext)
    XCTAssertFalse(fileManager.fileExists(atPath: "\(directoryUrl!.path)/child"))
    let stored : MemoryContext? = context.get(key: "child")
    XCTAssertNotNil(stored)
    XCTAssertEqual(childContext, stored)
  }
  
  func testPersistablePut() {
    let item = TestPersistable(value: "TestValue")
    let context = DiskContext(dirUrl: directoryUrl!)
    context.put(key: "pers", value: item)
    let path = "\(directoryUrl!.path)/pers"
    XCTAssertTrue(fileManager.fileExists(atPath: path))
    let stored = try! Data(contentsOf: directoryUrl!.appendingPathComponent("pers"), options: .uncached)
    XCTAssertEqual(item.asData(), stored)
  }
  
  func testNonPersistable() {
    let item = 1
    let context = DiskContext(dirUrl: directoryUrl!)
    context.put(key: "int", value: item)
    let path = "\(directoryUrl!.path)/int"
    XCTAssertFalse(fileManager.fileExists(atPath: path))
  }
  
  func testStringPersistable() {
    let string = "some string that should be stored"
    let context = DiskContext(dirUrl: directoryUrl!)
    context.put(key: "string", value: string)
    XCTAssertTrue(fileManager.fileExists(atPath: "\(directoryUrl!.path)/string"))
    let stored = try! Data(contentsOf: directoryUrl!.appendingPathComponent("string"), options: .uncached)
    XCTAssertEqual(string, String(data: stored, encoding: .utf8))
  }
  
  func testGetData() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let data = "Some String".data(using: .utf8)
    let fileUrl = directoryUrl!.appendingPathComponent("stored")
    try! data?.write(to: fileUrl)
    let stored : Data? = context.get(key: "stored")
    XCTAssertNotNil(stored)
    XCTAssertEqual(data, stored)
  }
  
  func testGetDataComplex() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let data = "Some String".data(using: .utf8)
    let dir = directoryUrl!.appendingPathComponent("path/to")
    try! fileManager.createDirectory(at: dir, withIntermediateDirectories: true, attributes: [:])
    let fileUrl = directoryUrl!.appendingPathComponent("path/to/file")
    try! data?.write(to: fileUrl)
    let stored : Data? = context.get(key: "path/to/file")
    XCTAssertNotNil(stored)
    XCTAssertEqual(data, stored)
  }
  
  func testGetPersitable() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let data = "Some String".data(using: .utf8)
    let fileUrl = directoryUrl!.appendingPathComponent("stored")
    try! data?.write(to: fileUrl)
    let stored : TestPersistable? = context.get(key: "stored")
    XCTAssertNotNil(stored)
    XCTAssertEqual("Some String", stored?.value)
  }
  
  func testGetAsync() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let data = "Some String".data(using: .utf8)
    let fileUrl = directoryUrl!.appendingPathComponent("stored")
    try! data?.write(to: fileUrl)
    let exp = expectation(description: "Callback")
    context.get(key: "stored", callback: { (stored: Data?) in
      XCTAssertNotNil(stored)
      XCTAssertEqual(data, stored)
      exp.fulfill()
    })
    waitForExpectations(timeout: 2, handler: nil)
  }
  
  func testGetAsyncWithLoader() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let data = "Some String".data(using: .utf8)
    let exp = expectation(description: "Callback")
    context.get(key: "stored", loader: { done in
      done(data)
    }, callback: { (stored: Data?) in
      XCTAssertNotNil(stored)
      XCTAssertEqual(data, stored)
      exp.fulfill()
    })
    waitForExpectations(timeout: 2, handler: nil)
  }
  
  func testRemove() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let data = "Some String".data(using: .utf8)
    let fileUrl = directoryUrl!.appendingPathComponent("stored")
    try! data?.write(to: fileUrl)
    XCTAssertTrue(fileManager.fileExists(atPath: "\(directoryUrl!.path)/stored"))
    context.remove(key: "stored")
    XCTAssertFalse(fileManager.fileExists(atPath: "\(directoryUrl!.path)/stored"))
  }
      
  func testClear() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let data = "Some String".data(using: .utf8)
    let fileUrl = directoryUrl!.appendingPathComponent("file1")
    try! data?.write(to: fileUrl)
    let fileUrl2 = directoryUrl!.appendingPathComponent("file2")
    try! data?.write(to: fileUrl2)
    XCTAssertTrue(fileManager.fileExists(atPath: "\(directoryUrl!.path)/file1"))
    XCTAssertTrue(fileManager.fileExists(atPath: "\(directoryUrl!.path)/file2"))
    context.clear()
    XCTAssertFalse(fileManager.fileExists(atPath: "\(directoryUrl!.path)/file2"))
    XCTAssertFalse(fileManager.fileExists(atPath: "\(directoryUrl!.path)/file2"))
  }
  
  
  func testClean() {
    let context = DiskContext(dirUrl: directoryUrl!)
    context.expiry = -1
    let key = SimpleKey(key: "key")
    let data = "Some String".data(using: .utf8)
    context.put(key: key, value: data)
    context.clean()
    XCTAssertNil(context.get(key: "key"))
  }
  
  func testCleanNested() {
    let context = DiskContext(dirUrl: directoryUrl!)
    let nested = DiskContext(dirUrl: directoryUrl!.appendingPathComponent("complex"))
    nested.expiry = -1
    context.put(key: "complex", value: nested)
    let key = ComplexKey(segments: ["complex", "key"])
    let data = "Some String".data(using: .utf8)
    context.put(key: key, value: data)
    context.clean()
    XCTAssertNil(nested.get(key: "key"))
  }

  func testCleanChild() {
    let context = DiskContext(dirUrl: directoryUrl!)
    context.expiry = -1
    let key = ComplexKey(segments: ["complex", "key"])
    let data = "Some String".data(using: .utf8)
    context.put(key: SimpleKey(key: "rootvalue"), value: data)
    context.put(key: key, value: data)
    (context.get(key: "complex") as Context?)?.clean(deep: false)
    let rootVal: Data? = context.get(key: "rootvalue")
    XCTAssertNotNil(rootVal)
    let nestedVal: Data? = (context.childContexts["complex"] as! DiskContext).get(key: "key")
    XCTAssertNil(nestedVal)
  }
}
