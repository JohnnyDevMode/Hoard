//
//  TraversableContext.swift
//  Hoard
//
//  Created by John Bailey on 4/11/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

public class TraversableContext : NSObject, Context {
  
  var childContexts = [String:Context]()
    
  func contextFor(key: Key) -> Context? {
    if let complexKey = key as? ComplexKey {
      if childContexts[complexKey.head] == nil {
        let next = createChild(key: complexKey.head)
        childContexts[complexKey.head] = next
        return next.contextFor(key: complexKey.tail)
      }
      else if let next = childContexts[complexKey.head] as? TraversableContext {
        return next.contextFor(key: complexKey.tail)
      }
      return nil
    } else {
      return self
    }
  }
  
  public func put<T>(key: Keyable, value: T) {
    let key = key.asKey()
    if let simple = key as? SimpleKey {
      if let context = value as? Context {
        childContexts[simple.key] = context
      } else {
        putLocal(key: simple.key, value: value)
      }
    } else if let complex = key as? ComplexKey, let context = contextFor(key: complex) {
      context.put(key: key.last, value: value)
    }
  }
  
  func putLocal<T>(key: String, value: T) {
    
  }
  
  public func get<T>(key: Keyable) -> T? {
    let key = key.asKey()
    if let simple = key as? SimpleKey {
      if let context = childContexts[simple.key] as? T {
        return context
      } else {
        return getLocal(key: simple.key)
      }
    } else if let complex = key as? ComplexKey, let context = contextFor(key: complex) {
      return context.get(key: complex.last)
    }
    return nil
  }
  
  func getLocal<T>(key: String) -> T? {
    return nil
  }
  
  public func get<T>(key: Keyable, callback: @escaping (T?) -> Void) {
    return get(key: key, loader: { done in done(nil) },  callback: callback)
  }
  
  public func get<T>(key: Keyable, loader: @escaping (@escaping (T?) -> Void) -> Void, callback: @escaping (T?) -> Void) {
    let key = key.asKey()
    if let current : T = get(key: key) {
      return callback(current)
    }
    loadQueue.async {
      loader { loaded in
        if let loaded = loaded {
          self.put(key: key, value: loaded)
        }
        DispatchQueue.main.async {
          callback(loaded)
        }
      }
    }
  }
  
  public func remove(key: Keyable) {
    let key = key.asKey()
    if let simple = key as? SimpleKey {
      if childContexts[simple.key] != nil {
        childContexts.removeValue(forKey: simple.key)
      } else {
        removeLocal(key: simple.key)
      }
    } else if let complex = key as? ComplexKey, let context = contextFor(key: complex) {
      context.remove(key: complex.last)
    }
  }
  
  func removeLocal(key: String) {
    // Extension for removing from local context
  }
  
  public func clean() {
    clean(deep: false)
  }
  
  public func clean(deep: Bool) {
    for childContext in childContexts.values {
      childContext.clean(deep: deep)
    }
  }
  
  public func clear() {
    childContexts.removeAll()
  }

  func createChild(key: String) -> TraversableContext {
    return TraversableContext()
  } 
}
