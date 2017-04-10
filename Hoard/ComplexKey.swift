//
//  ComplexKey.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

public class ComplexKey : Key {
  
  public var head : String {
    return super.segment
  }
  
  public let tail : Key
  
  override var last: Key {
    return tail.last
  }
  
  public override var description: String {
    return head + "." + tail.description
  }
  
  init(segments: [String]) {
    tail = segments.count > 1 ? Key.from(segments: Array(segments.suffix(from: 1))) : Key.Invalid
    super.init(segment: segments.first ?? Key.Invalid.segment)
  }
  
}
