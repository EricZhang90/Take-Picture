
//
//  CoreData.swift
//  Take Picture
//
//  Created by Eric on 2016-10-28.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let manager = CoreDataManager()
    var moc:NSManagedObjectContext { return self.persistentContainer.viewContext }
    
    func createRecipeEntity() -> Recipe {
        let recipe: Recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: persistentContainer.viewContext) as! Recipe
        
        recipe.createdDate = Date()
        
        saveContext()
        
        return recipe
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Take_Picture")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: CRUD
extension CoreDataManager {
    func create(entity: String) -> NSManagedObject {
        let mo = NSEntityDescription.insertNewObject(forEntityName: entity, into: self.moc)
        saveContext()
        return mo
    }
    
    func fetchRecipe(by id: Double) -> Recipe? {
        let request = NSFetchRequest<Recipe>()
        request.entity = NSEntityDescription.entity(forEntityName: "Recipe", in: moc)
        request.predicate = NSPredicate(format: "recipeID = %lf", id)
        
        do {
            let results = try moc.fetch(request)
            
            return results.first
        }catch {
            fatalError("Failed to fetch Recipe: \(error)")
        }
    }
    
// not use update so far
    
    func deleteAll(){
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        request.predicate = NSPredicate(value: true)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    func save(_ recipeObj: RecipeObj) {
        let recipeEntity = create(entity: "Recipe") as! Recipe
        
        recipeEntity.name = recipeObj.name
        recipeEntity.createdDate = Date()
        recipeEntity.recipeID = recipeObj.recipeID
        
        for i in 0..<recipeObj.steps.count {
            let step: Step = create(entity: "Step") as! Step
            step.idx = Int16(i)
            step.desc = recipeObj.steps[i]
            recipeEntity.addToSteps(step)
            saveContext()
        }
        
        guard recipeObj.photos.count > 0 else {
            return
        }
        
        for i in 0..<recipeObj.photos.count {
            let pic: Picture = create(entity: "Picture") as! Picture
            pic.idx = Int16(i)
            pic.pictureData = recipeObj.photos[i]
            recipeEntity.addToPictures(pic)
            saveContext()
        }
    }
}
