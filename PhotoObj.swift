//
//  PhotoObj.swift
//  Take Picture
//
//  Created by Eric on 2016-10-29.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import UIKit


class PhotoObj: NSObject, NSCoding {
    var photo: UIImage?
    var createdDate: Date
    var id: Double
    
    init(photoEntity: Photo) {
        if photoEntity.photo != nil {
            self.photo = UIImage(data: photoEntity.photo!)
        }
        
        self.createdDate = photoEntity.createdDate
        self.id = photoEntity.id
    }
    
    required init(photo: UIImage, createdDate: Date, id: Double) {
        self.photo = photo
        self.createdDate = createdDate
        self.id = id
    }
    
    static public func importFrom(_ url:URL) -> PhotoObj? {
        
        let data: Data?
        do {
            data = try Data(contentsOf: url)
            let photo: PhotoObj = NSKeyedUnarchiver.unarchiveObject(with: data!) as! PhotoObj
            return photo
        } catch {
            print(error)
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if self.photo == nil {
            print("Encode: photo is nil")
        }
        else {
            aCoder.encode(UIImagePNGRepresentation(self.photo!), forKey: "photo")
        }
        
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.createdDate, forKey: "date")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        if let pData = aDecoder.decodeObject(forKey: "photo")  {
            self.photo = UIImage(data:pData as! Data)
        }
        else {
            print("Decode: photo is nil")
        }
       
        
        self.createdDate = aDecoder.decodeObject(forKey: "date") as! Date
        self.id = aDecoder.decodeDouble(forKey: "id") 
    }
}
