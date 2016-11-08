
//
//  CoreData.swift
//  Take Picture
//
//  Created by Eric on 2016-10-28.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let manager = CoreDataManager()
    var moc:NSManagedObjectContext { return self.persistentContainer.viewContext }
    
    func createRecipeEntity() -> Recipe {
        let recipe: Recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: persistentContainer.viewContext) as! Recipe
        
        recipe.createdDate = Date()
        
        saveContext()
        
        return recipe
    }
    
    func update(entity entityClass: AnyClass, with data:Dictionary<String, Any>, by predicate:NSPredicate) {
        let entityName = NSStringFromClass(entityClass)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = NSEntityDescription.entity(forEntityName: entityName, in: moc)
        request.predicate = predicate
        
        do{
            let fetchedEntity = try moc.execute(request)
            fetchedEntity.setValuesForKeys(data)
        }catch {
            fatalError("Failed to fetch \(entityName): \(error)")
        }
    }
    

    
    
    func createPhotoEntity() -> Photo {
        let photo: Photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: persistentContainer.viewContext) as! Photo
        
        photo.createdDate = Date()
        
        saveContext()
        
        return photo
    }
    
    func addImageData(_ imageData: Data, toPhotoEntity: Photo!) {
        toPhotoEntity.photo = imageData
        saveContext()
    }
    
    func fetchPhoto(byID id: Int) -> Photo? {
        let request = NSFetchRequest<Photo>()
        request.entity = NSEntityDescription.entity(forEntityName: "Photo", in: moc)
        
        do {
            let result = try  moc.fetch(request)
            if result.count > 0 {
                return result[0]
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
     return nil
    }
    
    func deleteAll(){
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        request.predicate = NSPredicate(value: true)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func createEntity(by photoObj: PhotoObj) {
        let photoEntity = createPhotoEntity()
        photoEntity.createdDate = photoObj.createdDate
        photoEntity.id = photoObj.id
        photoEntity.photo = Data()
        saveContext()
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

extension CoreDataManager {
    
}
