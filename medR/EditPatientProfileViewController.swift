//
//  EditPatientProfileViewController.swift
//  medR
//
//  Created by Kok Yong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import Firebase

class EditPatientProfileViewController: UIViewController {
    
    
    
    //image
    @IBOutlet weak var editProfileImageView: UIImageView!
    @IBOutlet weak var editAddImageBtn: UIButton!{
        
        didSet{
            
            editAddImageBtn.addTarget(self, action: #selector(addImage), for: .touchUpInside)
            
        }
    }
    
    func addImage() {
        
        let pickerImageController = UIImagePickerController()
        
        //to check does the device have the source type
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            pickerImageController.sourceType = .photoLibrary
            
            
        }
        
        pickerImageController.delegate = self
        pickerImageController.allowsEditing = true
        
        present(pickerImageController, animated: true, completion: nil)
        
    }
    
    
    //Patient Info
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var contactNumberTF: UITextField!
    @IBOutlet weak var GenderTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    //emergency contact
    @IBOutlet weak var emergencyNameTF: UITextField!
    @IBOutlet weak var emergencyRelationshipTF: UITextField!
    @IBOutlet weak var emergencyContactTF: UITextField!
    
    //done edit
    @IBOutlet weak var doneEditingBtn: UIButton!{
        
        didSet{
            
            doneEditingBtn.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        }
    }
    
    func editProfile() {
        
        guard let fullName = fullNameTF.text, let contactNumeber = contactNumberTF.text, let gender = GenderTF.text, let email = emailTF.text, let age = ageTF.text, let address = addressTF.text, let emergencyName = emergencyNameTF.text, let emergencyRelationship = emergencyRelationshipTF.text, let emergencyContact = emergencyContactTF.text else {return}
        
        //let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        let value = ["fullName": fullName, "contactNumeber": contactNumeber, "gender": gender, "email": email, "age": age , "address": address, "emergencyName": emergencyName, "emergencyRelationship": emergencyRelationship, "emergencyContact": emergencyContact] as [String : Any]
        
        ref.child("users").child("specialUID").updateChildValues(value, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                
                print("err")
                
                return
                
                
            }
        })
        
        
        let storyboard = UIStoryboard(name: "KYStoryboard", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PatientProfileViewController") as? PatientProfileViewController else {return}
        
        self.present(controller, animated: true, completion: nil)
    }
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}
