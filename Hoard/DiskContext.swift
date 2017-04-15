//
//  DiskContext.swift
//  Hoard
//
//  Created by John Bailey on 4/13/17.
//  Copyright © 2017 DevMode Studios. All rights reserved.
//

import Foundation

public class DiskContext : TraversableContext {
  
  private let filemanger = FileManager.default
  
  private let dirUrl : URL
  
  public init(dirUrl: URL) {
    self.dirUrl = dirUrl
    if !filemanger.fileExists(atPath: dirUrl.path) {
      do {
        try filemanger.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: [:])
      } catch let error as NSError {
        print("Error creating directoroy: \(error)")
      }
    }    
  }
  
  public override func putLocal<T>(key: String, value: T) {
    if let persistable = value as? Persistable, let data = persistable.asData() {
      writeData(path: key, data: data)
    }
  }
  
  public override func getLocal<T>(key: String) -> T? {
    if let data = readData(path: key), T.self is Persistable.Type {
      return (T.self as? Persistable.Type)?.init(data: data) as? T
    }
    return nil
  }
  
  public override func removeLocal(key: String) {
    let childUrl = self.childUrl(childName: key)
    if filemanger.fileExists(atPath: childUrl.path) {
      do {
        try filemanger.removeItem(at: childUrl)
      } catch let error as NSError {
        print("Remove error: \(error)")
      }
    }
  }
  
  public override func clear() {
    do {
      for file in try filemanger.contentsOfDirectory(atPath: dirUrl.path) {
        try filemanger.removeItem(atPath: "\(dirUrl.path)/\(file)")
      }
    } catch let error as NSError {
      print("Clear Error: \(error)")
    }
  }
  
  private func childUrl(childName: String) -> URL {
    return dirUrl.appendingPathComponent(childName)
  }
  
  private func writeData(path: String, data: Data) {
    do {
      try data.write(to: childUrl(childName: path))
    }  catch let error as NSError {
      print("Write Error: \(error)")
    }
  }
  
  private func readData(path: String) -> Data? {
    do {
      return try Data(contentsOf: childUrl(childName: path))
    }  catch let error as NSError {
      print("Read Error: \(error)")
    }
    return nil
  }
  
  override func createChild(key: String) -> TraversableContext {
    return DiskContext(dirUrl: childUrl(childName: key))
  }
}
