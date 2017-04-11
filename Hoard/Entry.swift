//
//  Entry.swift
//  Hoard
//
//  Created by John Bailey on 4/10/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

class Entry<T> {
  
  let value : T
  
  fileprivate let validFor : Double
  
  fileprivate var accessed = Date()
  
  var isValid : Bool {
    return Date().timeIntervalSince(accessed) < validFor
  }
  
  init(value: T, validFor: Double) {
    self.value = value
    self.validFor = validFor
  }
  
  func access() {
    accessed = Date()
  }

}
		
