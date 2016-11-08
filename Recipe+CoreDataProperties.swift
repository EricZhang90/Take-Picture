//
//  Recipe+CoreDataProperties.swift
//  Take Picture
//
//  Created by Eric on 2016-11-08.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe");
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var recipeID: Double
    @NSManaged public var name: String?
    @NSManaged public var steps: Step?
    @NSManaged public var pictures: Picture?

}
