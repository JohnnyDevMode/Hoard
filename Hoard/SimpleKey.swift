//
//  SimpleKey.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

public class SimpleKey : Key {
  
  public override var description: String {
    return segment
  }
  
  public override init(segment: String) {
    super.init(segment: segment)
  }
  
}
