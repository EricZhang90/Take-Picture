//
//  Step+CoreDataProperties.swift
//  Take Picture
//
//  Created by Eric on 2016-11-08.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import CoreData


extension Step {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Step> {
        return NSFetchRequest<Step>(entityName: "Step");
    }

    @NSManaged public var desc: String?
    @NSManaged public var idx: Int16
    @NSManaged public var recipe: Recipe?

}
