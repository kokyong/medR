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
    
    var isDoctorMode : Bool = false

    var patientDetails : [PatientDetail] = []
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        fetchPatientData()
        //fetchDocInfo()
        
        if isDoctorMode == true {
            switchToDocBtn.setTitle("Switch to User", for: .normal)
        }
        
    }
    //patient
    var displayPatientImage = String()
    var displayFullName = String()
    var displayPhoneNumber = String()
    var displayGender = String()
    var displayEmail = String()
    var displayAge = String()
    var displayAdress = String()
    
    //emergency
    var displayEmergencyName = String()
    var displayEmergencyRelationship = String()
    var displayContactEmergency = String()
    
    //Doctor
    var displayLisenceID = String()
    var displayClinicAddress = String()
    var displaySpecialty = String()
    var displayInfo = String()
    
    let uid = FIRAuth.auth()?.currentUser?.uid
    //let ref = FIRDatabase.database().reference()
    var ref : FIRDatabaseReference!
    
    
    //IBOutlet
    //profile image
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet{
            profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
            profileImageView.clipsToBounds = true
        }
    }
    
    
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
    
    //doc detail
    @IBOutlet weak var lisenceIDLabel: UILabel!
    @IBOutlet weak var clinicAddressLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    //Doc Btn
    @IBOutlet weak var switchToDocBtn: UIButton!{
        didSet{
            
            switchToDocBtn.addTarget(self, action: #selector(switchToDoc), for: .touchUpInside)
            
            
        }
    }
    
    func switchToDoc() {
        
        if isDoctorMode == false {
            
        
        //push to doc VC
        let storyboard = UIStoryboard(name: "KYStoryboard", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DoctorTabViewController") as? DoctorTabViewController else {return}
        
        self.present(controller, animated: false, completion: nil)
            
            
        } else {
            
            
            let storyboard = UIStoryboard(name: "RuiStoryboard", bundle: Bundle.main)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "UserTabViewController") as? UserTabViewController else {return}
            
            self.present(controller, animated: false, completion: nil)
            
            
        }
        
    }
    
    @IBOutlet weak var becomeDoctorBtn: UIButton!{
        
        didSet{
            
            becomeDoctorBtn.addTarget(self, action: #selector(becomeADoctor), for: .touchUpInside)
            
        }
    }
    
    func becomeADoctor() {
        
        //push to doc VC
        let storyboard = UIStoryboard(name: "RuiStoryboard", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DoctorDetailsViewController") as? DoctorDetailsViewController else {return}
        controller.displayDocWithUID = PatientDetail.current.uid
        
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
    
    @IBOutlet weak var logOutBtn: UIButton!{
        
        didSet{
            
            logOutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        }
    }
    
    func logOut() {
        
        let storyboard = UIStoryboard(name: "GeogStoryboard", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
        
        self.present(controller, animated: true, completion: nil)

    }
    
    func fetchPatientData() {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            //patient
            let patientImage = value?["profileURL"] as? String
            let fullName = value?["fullName"] as? String
            let contactNumber = value?["contactNumber"] as? String
            let gender = value?["gender"] as? String
            let email = value?["email"] as? String
            let age = value?["age"] as? String
            let address = value?["address"] as? String
            
            //emergency
            let emergencyName = value?["emergencyName"] as? String
            let emergencyRelationship = value?["emergencyRelationship"] as? String
            let emergencyContact = value?["emergencyContact"] as? String
            
            //patient
            self.displayPatientImage = patientImage ?? ""
            self.displayFullName = fullName ?? ""
            self.displayPhoneNumber = contactNumber ?? ""
            self.displayGender = gender ?? ""
            self.displayEmail = email ?? ""
            self.displayAge = age ?? ""
            self.displayAdress = address ?? ""
            
            //emergency
            self.displayEmergencyName = emergencyName!
            self.displayContactEmergency = emergencyContact!
            self.displayEmergencyRelationship = emergencyRelationship!
            
            //patient detail
            self.nameLabel.text = "\(self.displayFullName) (\(self.displayAge))" ?? ""
            self.phoneNumberLabel.text = self.displayPhoneNumber ?? ""
            self.genderLabel.text = self.displayGender ?? ""
            self.emailLabel.text = self.displayEmail ?? ""
            self.addressLabel.text = self.displayAdress ?? ""
            
            
            //emergency
            self.nameEmergencyLabel.text = self.displayEmergencyName ?? ""
            self.contactEmergencyLabel.text = self.displayContactEmergency  ?? ""
            self.relationshipEmergencyLabel.text = self.displayEmergencyRelationship ?? ""
            
            //patient profile pic
            if let url = NSURL(string: self.displayPatientImage) {
                
                if let data = NSData(contentsOf: url as URL) {
                    self.profileImageView.image = UIImage(data: data as Data)
                    
                }
            }
            
            
        })
        
    }
    
    
    func fetchDocInfo() {
        
        ref.child("users").child(PatientDetail.current.uid).child("docAcc").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            
            //Doctor
            let lisenceID = value?["licenceID"] as? String
            let clinicAddress = value?["clinicAddress"] as? String
            let specialty = value?["specialty"] as? String
            let info = value?["info"] as? String
            
            //Doctor
            self.displayLisenceID = lisenceID!
            self.displayClinicAddress = clinicAddress!
            self.displaySpecialty = specialty!
            self.displayInfo = info!
            
            //Doctor
            self.lisenceIDLabel.text = self.displayLisenceID ?? ""
            self.clinicAddressLabel.text = self.displayClinicAddress ?? ""
            self.specialtyLabel.text = self.displaySpecialty ?? ""
            self.infoLabel.text = self.displayInfo ?? ""
        })
    }
    
    
    
    
    
}
