//
//  CDQL.swift
//  Photo
//
//  Created by Kirill on 18.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
  static var mappedEntityName: String {
    return ""
  }
}

protocol Querable: NSFetchRequestResult {
//  static func all() -> NSFetchRequest<Self>
  static func create(in context: NSManagedObjectContext) -> Self
}

extension Querable where Self: NSManagedObject {
  static func create(in context: NSManagedObjectContext) -> Self {
    return NSEntityDescription.insertNewObject(forEntityName: String(describing: self), into: context) as! Self
  }
}

extension DBPhoto: Querable {}
