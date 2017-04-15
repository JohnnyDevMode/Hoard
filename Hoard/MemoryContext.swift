//
//  MemoryContext.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation


public class MemoryContext : TraversableContext {

  fileprivate var storage = [String:Any]()
  
  subscript(key: String) -> Any? {
    get {
      return storage[key]
    }
    set {
      if let value = newValue {
        storage[key] = value
      } else {
        storage.removeValue(forKey: key)
      }
    }
  }
  
  override func putLocal<T>(key: String, value: T) {
    storage[key] = Entry(value: value, validFor: 3600)
  }
  
  override func getLocal<T>(key: String) -> T? {
    let stored = storage[key]
    if let entry = stored as? Entry {
      if entry.isValid, let value = entry.value as? T {
        return value
      }
    } else if let value = stored as? T {
      return value
    }
    return nil
  }
  
  override func removeLocal(key: String) {
    storage.removeValue(forKey: key)
  }
  
  override func createChild(key: String) -> TraversableContext {
    return MemoryContext()
  }

//  public func clean() {
//    clean(deep: false)
//  }
  
//  public func clean(deep: Bool) {
//    for (key, value) in storage {
//      if let entry = value as? Entry {
//        if !entry.isValid {
//          storage.removeValue(forKey: key)
//        } else if deep && entry.isRotten {
//          storage.removeValue(forKey: key)
//        }
//      } else if let context = value as? MemoryContext {
//        context.clean(deep: deep)
//      }
//    }
//  }
//  
  public override func clear() {
    super.clear()
    storage.removeAll()
  }
  
}
