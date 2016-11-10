//
//  PictureLibraryViewController.swift
//  Take Picture
//
//  Created by Eric on 2016-11-07.
//  Copyright © 2016 Eric. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import MessageUI


 enum SourceType {
    case photoLibrary
    case camera
}


class PictureLibraryViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    fileprivate var photoCollectionView: UICollectionView!
    fileprivate let collectionLayout = UICollectionViewFlowLayout()
    
    fileprivate let thumbnailSize:CGFloat = 70.0
    fileprivate let sectionInsets = UIEdgeInsets(top: 10, left: 5.0, bottom: 10.0, right: 5.0)
    
    fileprivate var photos = [UIImage]()
    
    fileprivate var sourceType: SourceType = .camera
    
    fileprivate var inputTF: RoudedTextField!
    
    fileprivate var name: String!
    fileprivate var steps = [String]()
    
    fileprivate let CDManager = CoreDataManager.manager
    
    //fileprivate var
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: collection view
    func addCollectionView(in superView: UIView) {
        
        photoCollectionView = UICollectionView(frame: superView.frame, collectionViewLayout: collectionLayout)
        
        photoCollectionView.backgroundColor = UIColor.white
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        photoCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        
        superView.addSubview(photoCollectionView)
    }
    
    @IBAction func actions(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Actions", message: "Choose source", preferredStyle: .actionSheet)
        
        let save = UIAlertAction(title: "Save", style: .default) { (UIAlertAction) in
            self.saveRecipe()
        }
        
        alertController.addAction(save)
        
        let load = UIAlertAction(title: "Load", style: .default) { (UIAlertAction) in
            self.loadRecipe()
        }
        
        alertController.addAction(load)
        
        let share = UIAlertAction(title: "Share", style: .default) { (UIAlertAction) in
            self.shareRecipe()
        }
        
        alertController.addAction(share)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
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
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.add(photos[(indexPath as NSIndexPath).row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let fullScreenPhotoVC = storyboard?.instantiateViewController(withIdentifier: "FullScreenPhotoViewController") as! FullScreenPhotoViewController
        
        fullScreenPhotoVC.photo = photos[(indexPath as NSIndexPath).row]
        
        navigationController?.pushViewController(fullScreenPhotoVC, animated: true)
    }
    
    // MARK:UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: thumbnailSize, height: thumbnailSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

// MARK: Table View Delegate and Data Source
extension PictureLibraryViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 3
        }
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        if indexPath.section != 2 {
            var frame = cell.contentView.frame
            frame.origin.y += 5.0
            frame.size.height -= 10.0
            frame.origin.x += 50.0
            frame.size.width -= 100.0
            
            inputTF = RoudedTextField(frame: frame, superView: cell.contentView)
            inputTF.delegate = self
            inputTF.tag = indexPath.section * 10 + indexPath.row
        }
        else {
            addCollectionView(in: cell.contentView)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 2 {
            return UITableViewAutomaticDimension
        }
        else {
            return (thumbnailSize + 10 * 2) * CGFloat((photos.count / 4 + 1))
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Name: "
        }
        else if section == 1 {
            return "Steps: "
        }
        else {
            return "Photos: "
        }
    }
}

// MARK: Get Picture
extension PictureLibraryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            
            photos.append(imageToSave!)
            
            tableView.reloadData()
            photoCollectionView.reloadData()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PictureLibraryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.tag == 0 {
            name = textField.text
        }
        else if textField.tag == 10 {
            steps[0] = textField.text!
        }
        else if textField.tag == 11 {
            steps[1] = textField.text!
        }
        else if textField.tag == 12 {
            steps[2] = textField.text!
        }

        return true
    }
}

// MARK: Right Button Actions
extension PictureLibraryViewController {
    func saveRecipe() {
        guard name != nil, steps.count == 3 else {
            return
        }
        
        CDManager.deleteAll()
        
        let recipe = CDManager.create(entity: "Recipe") as! Recipe
        
        let predicate = NSPredicate(format: "objectID = %@", recipe.recipeID)
        
        let update: [String : Any] = ["name": name,
                                      "createdDate": Date(),
                                      "recipeID": 999]
        
        CDManager.update(entity: "Recipe", with: update, by: predicate)
        
        for i in 0..<steps.count {
            let step: Step = CDManager.create(entity: "Step") as! Step
            recipe.addToSteps(step)
            let predicate = NSPredicate(format: "recipe.objectID = %", recipe.objectID)
            CDManager.update(entity: "Step", with: ["desc": steps[i], "idx": Int16(i)], by:predicate)
        }
        
        guard photos.count > 0 else {
            return
        }
        
        for i in 0..<photos.count {
            let pic: Picture = CDManager.create(entity: "Picture") as! Picture
            recipe.addToPictures(pic)
            let predicate = NSPredicate(format: "recipe.objectID = %", recipe.objectID)
            let picDate: Data = UIImagePNGRepresentation(photos[i])!
            CDManager.update(entity: "Picture", with: ["desc": picDate, "idx": Int16(i)], by:predicate)
        }
        
    }
    
    func shareRecipe() {
        
    }
    
    func loadRecipe() {
        
    }
}

