//
//  TraversableContext.swift
//  Hoard
//
//  Created by John Bailey on 4/11/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

protocol TraversableContext : Context {
  
  func contextFor(key: Key) -> Context?

}
