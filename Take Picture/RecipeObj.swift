//
//  RecipeObj.swift
//  Take Picture
//
//  Created by Eric on 2016-11-09.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import UIKit

class RecipeObj: NSObject, NSCoding {
    var name: String!
    var createdDate: Date!
    var recipeID: Double!
    var photos = [Data]()
    var steps = [String]()
    
    init(recipeID: Double) {
        let CDmanager = CoreDataManager.manager
        if let recipe = CDmanager.fetchRecipe(by: recipeID) {
            name = recipe.name
            createdDate = recipe.createdDate
            self.recipeID = recipeID
            
            
            // TODO: add order!
            if let pictures = recipe.pictures {
                for pic in pictures {
                    let picEntity = pic as! Picture
                    self.photos.append(picEntity.pictureDate!)
                }
            }
            
            for step in recipe.steps! {
                let stepEntity: Step = step as! Step
                self.steps.append(stepEntity.desc!)
            }
            
        }
    }
    
    static func importFrom(_ url:URL) -> RecipeObj? {
        let data: Data?
        do {
            data = try Data(contentsOf: url)
            let recipe: RecipeObj = NSKeyedUnarchiver.unarchiveObject(with: data!) as! RecipeObj
            return recipe
        } catch {
            print(error)
            return nil
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(createdDate, forKey: "createdDate")
        aCoder.encode(recipeID, forKey: "recipeID")
        aCoder.encode(photos, forKey: "photos")
        aCoder.encode(steps, forKey: "steps")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        createdDate = aDecoder.decodeObject(forKey: "createdDate") as! Date
        recipeID = aDecoder.decodeObject(forKey: "recipeID") as! Double
        photos = aDecoder.decodeObject(forKey: "photos") as! Array<Data>
        steps = aDecoder.decodeObject(forKey: "steps") as! Array<String>
    }
}





