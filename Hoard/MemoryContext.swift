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
    storage[key] = Entry(value: value)
  }
  
  override func getLocal<T>(key: String) -> T? {
    let stored = storage[key]
    if let entry = stored as? Entry {
      if entry.isValid(expiry: expiry), let value = entry.value as? T {
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
  
  public override func clean(deep: Bool) {
    super.clean(deep: deep)
    for (key, value) in storage {
      if let entry = value as? Entry {
        if !entry.isValid(expiry: expiry) {
          storage.removeValue(forKey: key)
        } else if deep && entry.isRotten(expiry: expiry) {
          storage.removeValue(forKey: key)
        }
      }
    }
  }

  public override func clear() {
    super.clear()
    storage.removeAll()
  }
  
}
