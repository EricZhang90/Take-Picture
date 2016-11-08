//
//  Picture+CoreDataProperties.swift
//  Take Picture
//
//  Created by Eric on 2016-11-08.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture");
    }

    @NSManaged public var picture: NSData?
    @NSManaged public var recipe: Recipe?

}
