//
//  Key.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

public class Key : NSObject {
  
  public static let Invalid = Key(segment: "INVALID")
  
  public let segment : String
  
  var last : Key {
    return self
  }
  
  init(segment: String) {
    self.segment = segment
  }
  
  public class func from(_ segments: String...) -> Key {
    return self.from(segments: segments)
  }
  
  public class func from(segments: [String]) -> Key {
    switch segments.count {
      case 0: return Invalid
      case 1: return SimpleKey(segment: segments[0])
      default: return ComplexKey(segments: segments)
    }
  }
}
