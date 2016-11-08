//
//  Photo+CoreDataProperties.swift
//  Take Picture
//
//  Created by Eric on 2016-10-28.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photo: Data?
    @NSManaged public var createdDate: Date
    @NSManaged public var id: Double

}

