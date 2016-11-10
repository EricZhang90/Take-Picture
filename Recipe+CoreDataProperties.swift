//
//  Recipe+CoreDataProperties.swift
//  Take Picture
//
//  Created by Eric on 2016-11-09.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe");
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var recipeID: Double
    @NSManaged public var pictures: NSSet?
    @NSManaged public var steps: NSSet?
}

// MARK: Generated accessors for pictures
extension Recipe {

    @objc(addPicturesObject:)
    @NSManaged public func addToPictures(_ value: Picture)

    @objc(removePicturesObject:)
    @NSManaged public func removeFromPictures(_ value: Picture)

    @objc(addPictures:)
    @NSManaged public func addToPictures(_ values: NSSet)

    @objc(removePictures:)
    @NSManaged public func removeFromPictures(_ values: NSSet)

}

// MARK: Generated accessors for steps
extension Recipe {

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: Step)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: Step)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSSet)

}
