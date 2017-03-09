//
//  DoctorDetailsViewController.swift
//  medR
//
//  Created by Rui Ong on 09/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DoctorDetailsViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference!
    var displayDocWithUID : String = ""
    var displayDoc : DoctorDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        
        fetchDoctorInfo()
        
    }
    
    func fetchDoctorInfo() {
        
        dbRef?.child("users").child(displayDocWithUID).child("docAcc").observe(.value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String : Any] else {return}
            let displayDoctor = DoctorDetail(withDictionary: value)
            displayDoctor.docUid = self.displayDocWithUID
            self.displayDoc = displayDoctor
            self.displayInfo()
        })
    }
    
    func displayInfo(){
        
        docNameLabel.text = displayDoc?.docName
        licenseIDLabel.text = displayDoc?.lisenceID
        clinicAddLabel.text = displayDoc?.clinicAddress
        specialtyLabel.text = displayDoc?.specialty
        infoLabel.text = displayDoc?.info
    }
    
    @IBOutlet weak var docPicImageView: UIImageView!
    @IBOutlet weak var docNameLabel: UILabel!
    @IBOutlet weak var licenseIDLabel: UILabel!
    @IBOutlet weak var clinicAddLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
}
