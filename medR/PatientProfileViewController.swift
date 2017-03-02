//
//  PatientProfileViewController.swift
//  medR
//
//  Created by Kok Yong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PatientProfileViewController: UIViewController {
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        fetchPatientData()
        
    }
    
    var displayFullName = String()
    var displayPhoneNumber = String()
    var displayGender = String()
    var displayEmail = String()
    var displayAge = String()
    var displayAdress = String()
    
    var displayEmergencyName = String()
    var displayEmergencyRelationship = String()
    var displayContactEmergency = String()
    
    let uid = FIRAuth.auth()?.currentUser?.uid
    //let ref = FIRDatabase.database().reference()
    var ref : FIRDatabaseReference!
 
    
    //IBOutlet
    //profile image
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    //Patient Info
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    //emergency contact
    @IBOutlet weak var nameEmergencyLabel: UILabel!
    @IBOutlet weak var relationshipEmergencyLabel: UILabel!
    @IBOutlet weak var contactEmergencyLabel: UILabel!
    
    //Doc Btn
    @IBOutlet weak var switchToDocBtn: UIButton!{
        
        didSet{
            
            switchToDocBtn.addTarget(self, action: #selector(switchToDoc), for: .touchUpInside)
        }
    }
    
    func switchToDoc() {
        
        //push to doc VC
        let storyboard = UIStoryboard(name: "KYStoryboard", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "SignUpDoctorProfileViewController") as? SignUpDoctorProfileViewController else {return}
        
        self.present(controller, animated: true, completion: nil)

        
    }
    
    //edit btn
    @IBOutlet weak var editBtn: UIButton!{
        
        didSet{
            
            editBtn.addTarget(self, action: #selector(edit), for: .touchUpInside)
            
            
        }
    }
    
    func edit() {
        
        let storyboard = UIStoryboard(name: "KYStoryboard", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "EditPatientProfileViewController") as? EditPatientProfileViewController else {return}
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func fetchPatientData() {
        
        ref.child("users").child("specialUID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            let fullName = value?["fullName"] as? String
            let contactNumeber = value?["contactNumeber"] as? String
            let gender = value?["gender"] as? String
            let email = value?["email"] as? String
            let age = value?["age"] as? String
            let address = value?["address"] as? String
            let emergencyName = value?["emergencyName"] as? String
            let emergencyRelationship = value?["emergencyRelationship"] as? String
            let emergencyContact = value?["emergencyContact"] as? String
            
            self.displayFullName = fullName!
            self.displayPhoneNumber = contactNumeber!
            self.displayGender = gender!
            self.displayEmail = email!
            self.displayAge = age!
            self.displayAdress = address!
            self.displayEmergencyName = emergencyName!
            self.displayContactEmergency = emergencyContact!
            self.displayEmergencyRelationship = emergencyRelationship!
            
            self.nameLabel.text = "\(self.displayFullName) (\(self.displayAge))"
            self.phoneNumberLabel.text = self.displayPhoneNumber
            self.genderLabel.text = self.displayGender
            self.emailLabel.text = self.displayEmail
            self.addressLabel.text = self.displayAdress
            self.nameEmergencyLabel.text = self.displayEmergencyName
            self.contactEmergencyLabel.text = self.displayContactEmergency
            self.relationshipEmergencyLabel.text = self.displayEmergencyRelationship
            
            //            if let url = NSURL(string: self.displayUserProfile) {
            //                if let data = NSData(contentsOf: url as URL) {
            //                    self.profilePicture.image = UIImage(data: data as Data)
            //                }
            //            }
            
            
        })
        
    }
    

}
