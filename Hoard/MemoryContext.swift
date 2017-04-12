//
//  Context.swift
//  Hoard
//
//  Created by John Bailey on 4/9/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation


public class MemoryContext : NSObject, TraversableContext {
  
  
  fileprivate static let loadQueue = DispatchQueue(label: "com.devmodestudios.hoard")
  
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
        let next = MemoryContext()
        self[complexKey.head] = next
        return next.contextFor(key: complexKey.tail)
      }
      else if let next = self[complexKey.head] as? TraversableContext {
        return next.contextFor(key: complexKey.tail)
      }
      return nil
    } else {
      return self
    }
  }
  
  public func put<T>(key: Keyable, value: T) {
    put(key: key, value: value, validFor: 3600)
  }
  
  public func put<T>(key: Keyable, value: T, validFor: Double) {
    let key = key.asKey()
    if let simple = key as? SimpleKey {
      storage[simple.key] = Entry(value: value, validFor: validFor)
    } else if let complex = key as? ComplexKey, let context = contextFor(key: complex) {
      if let memory = context as? MemoryContext {
        memory.put(key: key.last, value: value, validFor: validFor)
      } else {
        context.put(key: key, value: value)
      }
    }
  }
  
  public func get<T>(key: Keyable) -> T? {
    let key = key.asKey()
    if let simple = key as? SimpleKey {
      let stored = storage[simple.key]
      if let entry = stored as? Entry {
        if entry.isValid, let value = entry.value as? T {
          return value
        }
      } else if let value = stored as? T {
        return value
      }
    } else if let complex = key as? ComplexKey, let context = contextFor(key: complex) {
      return context.get(key: complex.last)
    }
    return nil
  }

  public func get<T>(key: Keyable, callback: @escaping (T?) -> Void) {
    return get(key: key, loader: { done in done(nil) },  callback: callback)
  }
  
  public func get<T>(key: Keyable, loader: @escaping ((T?) -> Void) -> Void, callback: @escaping (T?) -> Void) {
    let key = key.asKey()
    if let current : T = get(key: key) {
      return callback(current)
    }
    MemoryContext.loadQueue.async {
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
      storage.removeValue(forKey: simple.key)
    } else if let complex = key as? ComplexKey, let context = contextFor(key: complex) {
      context.remove(key: complex.last)
    }
  }
  
  public func children<T>() -> Set<T> {
    var results = Set<T>()
    for item in storage.values {
      if let entry = item as? Entry, entry.isValid, let value = entry.value as? T {
        results.insert(value)
      }
    }
    return results
  }
  
  public func clean() {
    clean(deep: false)
  }
  
  public func clean(deep: Bool) {
    for (key, value) in storage {
      if let entry = value as? Entry {
        if !entry.isValid {
          storage.removeValue(forKey: key)
        } else if deep && entry.isRotten {
          storage.removeValue(forKey: key)
        }
      } else if let context = value as? MemoryContext {
        context.clean(deep: deep)
      }
    }
  }
  
  public func clear() {
    storage.removeAll()
  }
  
}
