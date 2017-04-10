//
//  Hoard.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

public class Cache : Context {
  
  public static var shared : Cache = {
    return Cache()
  }()
  
//  public func get<T>(key: Key, loader: () -> T?) -> T? {
//    if let current : T = get(key: key) {
//      return current
//    }
//    if let loaded = loader() {
//      put(key: key, value: loaded)
//      return loaded
//    }
//    return nil
//  }
  
}
