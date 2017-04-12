//
//  SimpleKey.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

public class SimpleKey : Key {
  
  public let key : String
  
  public override var description: String {
    return key
  }
  
  public init(key: String) {
    self.key = key
  }
  
}
