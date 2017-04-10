//
//  Context.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

public class Context : NSObject {
  
  fileprivate var storage = [String:Any]()
  
  subscript(key: String) -> Any? {
    get {
      return storage[key]
    }
    set {
      storage[key] = newValue
    }
  }
  
  func contextFor(key: Key) -> Context? {
    if let complexKey = key as? ComplexKey {
      if self[complexKey.head] == nil {
        let next = Context()
        self[complexKey.head] = next
        return next.contextFor(key: complexKey.tail)
      }
      else if let next = self[complexKey.head] as? Context {
        return next.contextFor(key: complexKey.tail)
      }
      return nil
    } else {
      return self
    }
  }
  
  public func put(key: Key, value: Any) {
    guard let context = contextFor(key: key) else {  return }
    context[key.last.segment] = value
  }
  
  
  public func get<T>(key: Key, defaultValue: T? = nil, loader: (() -> T?)? = nil) -> T? {
    if let context =  contextFor(key: key), let value = context[key.last.segment] as? T {
      return value
    }
    if let loader = loader, let loaded = loader() {
      put(key: key, value: loaded)
      return loaded
    }
    return defaultValue
  }
  
  public func remove(key: Key) {
    guard let context = contextFor(key: key) else {  return }
    context.storage.removeValue(forKey: key.last.segment)
  }
  
}
