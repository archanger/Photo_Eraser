//
//  DBPhoto+CoreDataProperties.swift
//  Photo
//
//  Created by Kirill on 18.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import Foundation
import CoreData


extension DBPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBPhoto> {
        return NSFetchRequest<DBPhoto>(entityName: "DBPhoto")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var shown: Bool

}
