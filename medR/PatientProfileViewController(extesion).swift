//
//  PatientProfileViewController(extesion).swift
//  medR
//
//  Created by Kok Yong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension EditPatientProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //cancel picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            print(editedImage)
            uploadImage(image: editedImage)
            self.editProfileImageView.image = editedImage
            
            
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            print(originalImage)
            uploadImage(image: originalImage)
            self.editProfileImageView.image = originalImage
            
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //upload to storage
    func uploadImage(image: UIImage) {
        
        // to store an transfer image
        // let pngData = UIImagePNGRepresentation(image)
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
        
        let storageRef = FIRStorage.storage().reference()
        
        // metaData to confirm the image type
        let metadata = FIRStorageMetadata()
        metadata.contentType = "jpeg"
        
        let timeStamp = Date.timeIntervalSinceReferenceDate
        let storageNaming = (" \(timeStamp)")
        
        storageRef.child("ProfilePicture").child("\(storageNaming).jpeg").put(imageData, metadata: nil) { (meta,error) in
            
            // error message
            if error != nil {
                
                // display error alernt
                return
                
            }
            
            //downlaodURL to database
            if  let downloadURL = meta?.downloadURL() {
                
                print(downloadURL)
                
                //let uid = FIRAuth.auth()?.currentUser?.uid
                //                ref.child("users").child("specialUID").updateChildValues(["profileURL":downloadURL.absoluteString])
                let ref = FIRDatabase.database().reference()
                let value = ["profileURL":downloadURL.absoluteString] as [String : Any]
                
                ref.child("users").child("specialUID").updateChildValues(value, withCompletionBlock: { (err, ref) in
                    
                    if err != nil {
                        
                        print("err")
                        
                        return
                        
                        
                    }
                })
            }
            
        }
        
        
    }
    
    
}
