//
//  Key.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

public class Key : NSObject, Keyable {
  
  public static let Invalid = Key()
      
  var last : Key {
    return self
  }
  
  public class func from(_ segments: String...) -> Key {
    return self.from(segments: segments)
  }
  
  public class func from(segments: [String]) -> Key {
    switch segments.count {
      case 0: return Invalid
      case 1: return SimpleKey(key: segments[0])
      default: return ComplexKey(segments: segments)
    }
  }
  
  public func asKey() -> Key {
    return self
  }

}


extension String : Keyable {

  public func asKey() -> Key {
    return Key.from(segments: components(separatedBy: "/"))
  }

}

extension NSURL : Keyable {
  
  public func asKey() -> Key {
    var segments = [String]()
    if let host = self.host {
      segments.append(host)
    }
    if let path = self.path {
      segments.append(contentsOf: path.components(separatedBy: "/").filter({!$0.isEmpty}))
    }
    return Key.from(segments: segments)
  }
  
}

extension URL : Keyable {
  
  public func asKey() -> Key {
    var segments = [String]()
    if let host = self.host {
      segments.append(host)
    }
    segments.append(contentsOf: path.components(separatedBy: "/").filter({!$0.isEmpty}))
    return Key.from(segments: segments)
  }
  
}
