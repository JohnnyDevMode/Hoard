//
//  CacheTests.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

import XCTest
@testable import Hoard


class CacheTests : XCTestCase {
  
  func testShared() {
    let cache = Cache.shared
    let cacheTwo = Cache.shared
    XCTAssertEqual(cache, cacheTwo)
  }

}
