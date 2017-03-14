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
    
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        fetchData()
        
    }
    
    var selectedUID : String = PatientDetail.current.uid
    let uid = FIRAuth.auth()?.currentUser?.uid
    var ref : FIRDatabaseReference!
    var displayPatientImage = String()
    var displayFullName = String()
    var displayPhoneNumber = String()
    var displayGender = String()
    var displayEmail = String()
    var displayAge = String()
    var displayAdress = String()
    
    var displayEmergencyName = String()
    var displayEmergencyRelationship = String()
    var displayContactEmergency = String()
    
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
        
        let ref = FIRDatabase.database().reference()
        let value = ["fullName": fullName, "contactNumeber": contactNumeber, "gender": gender, "email": email, "age": age , "address": address, "emergencyName": emergencyName, "emergencyRelationship": emergencyRelationship, "emergencyContact": emergencyContact] as [String : Any]
        
        ref.child("users").child(PatientDetail.current.uid).updateChildValues(value, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                
                print("err")
                
                return
                
                
            }
        })
        
        
        let storyboard = UIStoryboard(name: "KYStoryboard", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PatientProfileViewController") as? PatientProfileViewController else {return}
        
        dismiss(animated: true, completion: nil)
    }
    
    func fetchData() {
        
        
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            let patientImage = value?["profileURL"] as? String
            let fullName = value?["fullName"] as? String
            let contactNumeber = value?["contactNumeber"] as? String
            let gender = value?["gender"] as? String
            let email = value?["email"] as? String
            let age = value?["age"] as? String
            let address = value?["address"] as? String
            let emergencyName = value?["emergencyName"] as? String
            let emergencyRelationship = value?["emergencyRelationship"] as? String
            let emergencyContact = value?["emergencyContact"] as? String
            
            self.displayPatientImage = patientImage!
            self.displayFullName = fullName!
            self.displayPhoneNumber = contactNumeber!
            self.displayGender = gender!
            self.displayEmail = email!
            self.displayAge = age!
            self.displayAdress = address!
            self.displayEmergencyName = emergencyName!
            self.displayContactEmergency = emergencyContact!
            self.displayEmergencyRelationship = emergencyRelationship!
            
            self.fullNameTF.text = self.displayFullName
            self.contactNumberTF.text = self.displayPhoneNumber
            self.GenderTF.text = self.displayGender
            self.emailTF.text = self.displayEmail
            self.addressTF.text = self.displayAdress
            self.ageTF.text = self.displayAge
            self.emergencyNameTF.text = self.displayEmergencyName
            self.emergencyContactTF.text = self.displayContactEmergency
            self.emergencyRelationshipTF.text = self.displayEmergencyRelationship
            
            if let url = NSURL(string: self.displayPatientImage) {
                if let data = NSData(contentsOf: url as URL) {
                    self.editProfileImageView.image = UIImage(data: data as Data)
                }
            }
            
            
        })
        
        
    }
    
    
    
}
