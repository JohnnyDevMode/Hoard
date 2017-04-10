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
      if let value = newValue {
        storage[key] = value
      } else {
        storage.removeValue(forKey: key)
      }
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
  
  public func put<T>(key: Key, value: T) {
    guard let context = contextFor(key: key) else {  return }
    context[key.last.segment] = Entry<T>(value: value)
  }
  
  public func get<T>(key: Key, defaultValue: T? = nil, loader: (() -> T?)? = nil) -> T? {
    if let context =  contextFor(key: key), let entry = context[key.last.segment] as? Entry<T> {
      return entry.value
    }
    if let loader = loader, let loaded = loader() {
      put(key: key, value: loaded)
      return loaded
    }
    return defaultValue
  }
  
  public func getAsync<T>(key: Key, loader: (((T?) -> Void) -> Void)? = nil, callback: (T?) -> Void) {
    if let current : T = get(key: key) {
      return callback(current)
    }
    if let loader = loader {
      loader { loaded in
        if let loaded = loaded {
          put(key: key, value: loaded)
        }
        callback(loaded)
      }
      return
    }
    callback(nil)
  }
  
  public func remove(key: Key) {
    guard let context = contextFor(key: key) else {  return }
    context.storage.removeValue(forKey: key.last.segment)
  }
  
  public func children<T>(key: Key) -> Set<T> {
    var results = Set<T>()
    guard let parent = contextFor(key: key), let context = parent[key.last.segment] as? Context else {  return results }
    for item in context.storage.values {
      if let cast = item as? Entry<T> {
        results.insert(cast.value)
      }
    }
    return results
  }
  
}
