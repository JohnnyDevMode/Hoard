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
  
  fileprivate let validFor : Double
  
  fileprivate let created = Date()
  
  var accessed = Date()
  
  var isValid : Bool {
    return Date().timeIntervalSince(created) < validFor
  }
  
  var drift : Double {
    return Date().timeIntervalSince(accessed)
  }
  
  var rot : Double {
    guard validFor > 0 else { return 1 }
    return drift / validFor
  }
  
  var isRotten : Bool {
    return rot > ROT_THRESHOLD
  }
  
  init(value: Any, validFor: Double) {
    self.value = value
    self.validFor = validFor
  }
  
  func access() {
    accessed = Date()
  }

}
		
