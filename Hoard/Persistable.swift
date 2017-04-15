//
//  Persistable.swift
//  Hoard
//
//  Created by John Bailey on 4/13/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

protocol Persistable {
  
  init?(data: Data)
  
  func asData() -> Data?

}

extension String : Persistable {
  
  init?(data: Data) {
    self.init(data: data, encoding: .utf8)
  }
  
  func asData() -> Data? {
    return data(using: .utf8)
  }
  
}

extension Data : Persistable {
  
  init?(data: Data) {
    self.init()
    self.append(data)
  }
  
  func asData() -> Data? {
    return self
  }

}
