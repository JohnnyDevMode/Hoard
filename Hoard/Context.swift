//
//  Context.swift
//  Hoard
//
//  Created by John Bailey on 4/11/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

protocol Context {
  
  func put<T>(key: Keyable, value: T)
  
  func get<T>(key: Keyable) -> T?
  
  func get<T>(key: Keyable, callback: @escaping (T?) -> Void)
  
  func get<T>(key: Keyable, loader: @escaping (@escaping (T?) -> Void) -> Void, callback: @escaping (T?) -> Void)
  
  func remove(key: Keyable)
  
  func clean()
  
  func clean(deep: Bool)
  
  func clear()

}
