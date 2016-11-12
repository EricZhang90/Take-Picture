//
//  Picture+CoreDataProperties.swift
//  Take Picture
//
//  Created by Eric on 2016-11-09.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import CoreData
 

extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture");
    }

    @NSManaged public var pictureData: Data?
    @NSManaged public var idx: Int16
    @NSManaged public var recipe: Recipe?

}
