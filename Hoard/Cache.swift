//
//  Hoard.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

public class Cache : MemoryContext {
  
  public static var shared : Cache = {
    return Cache()
  }()

}
