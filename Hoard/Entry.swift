//
//  Entry.swift
//  Hoard
//
//  Created by John Bailey on 4/10/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

let ROT_THRESHOLD = 0.5

class Entry {
  
  let value : Any
  
  
  fileprivate let created = Date()
  
  var accessed = Date()
  
  func isValid(expiry: Double) -> Bool {
    return Date().timeIntervalSince(created) < expiry
  }
  
  var drift : Double {
    return Date().timeIntervalSince(accessed)
  }
  
  func rot(expiry: Double) -> Double {
    guard expiry > 0 else { return 1 }
    return drift / expiry
  }
  
  func isRotten(expiry: Double) -> Bool {
    return rot(expiry: expiry) > ROT_THRESHOLD
  }
  
  init(value: Any) {
    self.value = value
  }
  
  func access() {
    accessed = Date()
  }

}
		
