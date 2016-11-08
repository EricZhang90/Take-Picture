//
//  ViewController.swift
//  Take Picture
//
//  Created by Eric on 2016-10-28.
//  Copyright © 2016 Eric. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import MessageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,MFMailComposeViewControllerDelegate  {
    @IBOutlet weak var sImage: UIImageView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    let manager = CoreDataManager.manager
    
    var recipe: Recipe!
    
    var photos = [Photo]()
    
    lazy var photo: Photo = {
        if let tmp = self.manager.fetchPhoto(byID: 999) {
            return tmp
        }
        else {
            let tmp = self.manager.createPhotoEntity()
            tmp.id = 999
            self.manager.saveContext()
            return tmp
        }
    }()
    
    var sourceType: SourceType = .camera

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if photo.photo != nil {
            let image = UIImage(data: photo.photo!)
            imageView.image = image!
        }

        
        let text = NSLocalizedString("Add Pic", comment: "a")
        addBtn.setTitle(text, for: .normal)
    
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOpenURL),
            name: NSNotification.Name(rawValue: "importURL"),
            object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func savePic() {
        guard  imageView.image != nil else {
            return
        }
        
        if let imageData = UIImagePNGRepresentation(imageView.image!){
            manager.addImageData(imageData, toPhotoEntity: photo)
        }
        
        
    }
    
    
    @IBAction func takePic(_ sender: AnyObject) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) == true else
        {
            return
        }
        
        let alertController = UIAlertController(title: "Add Pic", message: "Choose source", preferredStyle: .alert)
        
        let text = NSLocalizedString("Pick from photo library", comment: "a")
        
        let chooseFromPL = UIAlertAction(title: text, style: .default) { (UIAlertAction) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
            self.sourceType = .photoLibrary
        }
        
        alertController.addAction(chooseFromPL)
        
        let textTwo = NSLocalizedString("Take Pic", comment: "a")
        let takePic = UIAlertAction(title: textTwo, style: .default) { (UIAlertAction) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
            self.sourceType = .camera
        }
        
        alertController.addAction(takePic)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        let originalImage: UIImage?
        
        let editedImage: UIImage?
        
        let imageToSave: UIImage?
        
        if CFStringCompare(mediaType as CFString, kUTTypeImage, .compareCaseInsensitive) == CFComparisonResult.compareEqualTo {
            
            editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            
            originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            if editedImage != nil {
                imageToSave = editedImage
            }
            else {
                imageToSave = originalImage
            }
            
            if sourceType == .camera {
                UIImageWriteToSavedPhotosAlbum(imageToSave!, nil, nil, nil)
            }
            
            imageView.image = imageToSave
            
            savePic()
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: AnyObject) {
        let mailViewController = MFMailComposeViewController()
        mailViewController.setSubject("Take Pic")
        mailViewController.setMessageBody("There is my app data", isHTML: false)
        
        let photoObj = PhotoObj(photoEntity: photo)
        
        if photoObj.photo == nil {
            print("zip photo fail")
        }

        
        photoObj.createdDate = Date(timeIntervalSince1970: 0)
        
        let photoData = NSKeyedArchiver.archivedData(withRootObject: photoObj)
        
        
        DispatchQueue.main.async {
            let pO: PhotoObj = NSKeyedUnarchiver.unarchiveObject(with: photoData) as! PhotoObj
            self.sImage.image = pO.photo
            if pO.photo == nil {
                print("pO 's photo is nil")
            }
        }
        
        mailViewController.addAttachmentData(photoData, mimeType: "application/takePicture", fileName: "pic.abc")
        mailViewController.mailComposeDelegate = self
        
        present(mailViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print(error?.localizedDescription)
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    func handleOpenURL() {
        guard let url = UserDefaults.standard.url(forKey: "importURL") else {
            return
        }

        guard let photoObj = PhotoObj.importFrom(url)  else {
            return
        }
        
        photo.id = photoObj.id
        photo.createdDate = photoObj.createdDate
        
        if photoObj.photo != nil {
            photo.photo = UIImagePNGRepresentation(photoObj.photo!)
        }
        
        
        print("id: \(photo.id)")
        manager.saveContext()
        
        DispatchQueue.main.async {
            if let photo = self.manager.fetchPhoto(byID: 999) {
                print("id: \(photo.id)")
                if photo.photo != nil {
                    let image = UIImage(data: photo.photo!)
                     print("created date: \(photo.createdDate)")
                    self.imageView.image = image!
                    self.sImage.image = photoObj.photo
                }
                
                if photo.photo == nil {
                    print("photo is nil")
                    print("created date: \(photo.createdDate)")
                }
            }
        }
        
        UserDefaults.standard.removeObject(forKey: "importURL")
    }
}

















