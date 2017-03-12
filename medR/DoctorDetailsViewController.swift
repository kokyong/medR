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
    var displayDocWithUID : String = ""
    var displayDoc : DoctorDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    func displayInfo(){
        
        docNameLabel.text = displayDoc?.docName
        licenseIDLabel.text = displayDoc?.lisenceID
        clinicAddLabel.text = displayDoc?.clinicAddress
        specialtyLabel.text = displayDoc?.specialty
        infoLabel.text = displayDoc?.info
    }
    extension DoctorDetailsViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.cellIdentifier, for: indexPath) as? PostTableCell else {return UITableViewCell()}
            
            cell.delegate = self
            cell.indexPath = indexPath
            let post = posts[indexPath.row]
            
            if let timestamp = post.dateTime {
                cell.timestampLabel.text = dateFormater.string(from: Date(timeIntervalSinceReferenceDate: timestamp))
            } else {
                cell.timestampLabel.text = ""
            }
            
            if post.image == nil {
                if let url = post.imageURL {
                    datatask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
                        guard let validData = data else {return}
                        guard let image = UIImage(data: validData) else { return }
                        
                        post.image = image
                        DispatchQueue.main.async {
                            self.newsFeedTableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    })
                    datatask?.resume()
                }
            } else {
                cell.postImage.image = post.image
            }

    
                   
                   
                   
                   
    @IBOutlet weak var QRcode: UIImageView!
    @IBOutlet weak var docPicImageView: UIImageView!
    @IBOutlet weak var docNameLabel: UILabel!
    @IBOutlet weak var licenseIDLabel: UILabel!
    @IBOutlet weak var clinicAddLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
}



}
}
