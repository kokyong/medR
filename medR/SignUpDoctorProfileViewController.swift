//
//  DoctorProfileViewController.swift
//  medR
//
//  Created by Kok Yong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import Firebase
import QRCode

class SignUpDoctorProfileViewController: UIViewController {
    
    //viewDidLaod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        //fetchDocInfo()
        
    }
    
    var displayPatientImage = String()
    var displayDocName = String()
    var ref : FIRDatabaseReference!
    
    //fetch image
    @IBOutlet weak var docProfileImageView: UIImageView!
    
    //fetch name
    @IBOutlet weak var docFullName: UILabel!
    
    //sign up doc acc
    @IBOutlet weak var licenceIDTF: UITextField!
    @IBOutlet weak var clinicAddressTF: UITextField!
    @IBOutlet weak var specialtyTF: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    //done cr8 btn
    @IBOutlet weak var doneCreatingBtn: UIButton!{
        
        didSet{
            
            doneCreatingBtn.addTarget(self, action: #selector(creatDocAcc), for: .touchUpInside)
            doneCreatingBtn.addTarget(self, action: #selector(createQRCode), for: .touchUpInside)
        }
    }
    
    
    
    
    func creatDocAcc(){
        
        guard let licenceID = licenceIDTF.text, let clinicAddress = clinicAddressTF.text, let specialty = specialtyTF.text, let info = infoTextView.text else {return}
        
        let value = ["licenceID": licenceID, "clinicAddress": clinicAddress, "specialty": specialty, "info": info] as [String : Any]
        
        ref.child("doctors").child(PatientDetail.current.uid).setValue(PatientDetail.current.fullName)
        
        ref.child("users").child(PatientDetail.current.uid).child("docAcc").updateChildValues(value, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                
                print("err")
                
                return
                
                
            }
        })
        
        //push VC
        let storyboard = UIStoryboard(name: "KYStoryboard", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PatientProfileViewController") as? PatientProfileViewController else {return}
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //QR code
    
    func createQRCode(){
        let qrCode = QRCode(PatientDetail.current.uid)
        let codeImage = qrCode?.image
       
        uploadImage(image: codeImage!)
    }
    
    func uploadImage (image: UIImage){
        let storageRef = FIRStorage.storage().reference()
        var metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
    
        let imageName = ("image \(PatientDetail.current.uid).jpeg")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
        storageRef.child(imageName).put(imageData, metadata: metadata) { (meta, error) in
            
            if let downloadUrl = meta?.downloadURL() {
                let stringUrl = downloadUrl.absoluteString
                self.ref.child("users").child(PatientDetail.current.uid).child("docAcc").child("QRcode").setValue(stringUrl)
                
            } else {
                //error
            }
        }
    }
    
    
    func fetchDocInfo() {
        
        ref.child("users").child(PatientDetail.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            
            let docFullName = value?["fullName"] as? String
            self.displayDocName = docFullName!
            self.docFullName.text = self.displayDocName
            
            let patientImage = value?["profileURL"] as? String
            self.displayPatientImage = patientImage!
            
            
            
            if let url = NSURL(string: self.displayPatientImage) {
                if let data = NSData(contentsOf: url as URL) {
                    self.docProfileImageView.image = UIImage(data: data as Data)
                }
            }
        })
        
        
    }
    
    
}
