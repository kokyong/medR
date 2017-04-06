//
//  DoctorDetailsViewController.swift
//  medR
//
//  Created by Rui Ong on 09/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DoctorDetailsViewController: UIViewController  {
    
    var dbRef : FIRDatabaseReference!
    var datatask : URLSessionDataTask?
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var displayDocWithUID : String = ""
    var displayDoc : DoctorDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QRcode.loadGif(name: "medRgif")

        
        dbRef = FIRDatabase.database().reference()
        
        fetchDoctorInfo()
        
    }
    
    func fetchDoctorInfo() {
        var displayDoctor = DoctorDetail()
        
        dbRef?.child("users").child(displayDocWithUID).child("docAcc").observe(.value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String : Any] else {return}
            displayDoctor = DoctorDetail(withDictionary: value)
            displayDoctor.docUid = self.displayDocWithUID
            self.displayDoc = displayDoctor
            
        })
        
        dbRef?.child("users").child(displayDocWithUID).child("fullName").observe(.value, with: { (snapshot) in
            displayDoctor.docName = snapshot.value as? String
            self.displayInfo()
        })
        
        dbRef?.child("users").child(displayDocWithUID).child("profileURL").observe(.value, with: { (snapshot) in
            let validUrl = URL(string: snapshot.value as? String ?? "" )
            displayDoctor.profilePicUrl = validUrl
            
            let validStringUrl = displayDoctor.profilePicUrl?.absoluteString ?? ""
            if let url = NSURL(string: validStringUrl) {
                
                if let data = NSData(contentsOf: url as URL) {
                    self.docPicImageView.image = UIImage(data: data as Data)
                    self.displayInfo()
                }
            }
            
        })
        
        
    }
    
    func displayInfo(){
        
        docNameLabel.text = displayDoc?.docName
        licenseIDLabel.text = displayDoc?.lisenceID
        clinicAddLabel.text = displayDoc?.clinicAddress
        specialtyLabel.text = displayDoc?.specialty
        infoLabel.text = displayDoc?.info
        
        if let url = displayDoc?.qrCodeUrl {
            datatask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let validData = data else {return}
                guard let image = UIImage(data: validData) else { return }
                
                self.QRcode.image = image
               
            })
            
            datatask?.resume()
        }
    }
    

    
                   
                   
                   
                   
    @IBOutlet weak var QRcode: UIImageView!
    @IBOutlet weak var docPicImageView: UIImageView!{
        didSet{
            docPicImageView.layer.cornerRadius = docPicImageView.frame.size.height/2
            docPicImageView.clipsToBounds = true
        }
    }

    @IBOutlet weak var docNameLabel: UILabel!
    @IBOutlet weak var licenseIDLabel: UILabel!
    @IBOutlet weak var clinicAddLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var editProfile: UIButton!{
        
        
        didSet{
            
            editProfile.addTarget(self, action: #selector(edit), for: .touchUpInside)
        }
    }
    
    
    
    func edit() {
        
        //push to doc VC
        let storyboard = UIStoryboard(name: "KYStoryboard", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "SignUpDoctorProfileViewController") as? SignUpDoctorProfileViewController else {return}

        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var dismissBtn: UIButton!{
        
        didSet{
            
            dismissBtn.addTarget(self, action: #selector(dismissBtnFunc), for: .touchUpInside)
        }
    }
    
    func dismissBtnFunc() {
        
        dismiss(animated: true, completion: nil)
    }
    
    // KY
    
    
}




