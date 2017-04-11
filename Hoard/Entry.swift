//
//  Entry.swift
//  Hoard
//
//  Created by John Bailey on 4/10/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

class Entry {
  
  let value : Any
  
  fileprivate let validFor : Double
  
  fileprivate var accessed = Date()
  
  var isValid : Bool {
    return Date().timeIntervalSince(accessed) < validFor
  }
  
  init(value: Any, validFor: Double) {
    self.value = value
    self.validFor = validFor
  }
  
  func access() {
    accessed = Date()
  }

}
		
