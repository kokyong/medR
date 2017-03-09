//
//  SharingViewController.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SharingViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference!
    var doctorsShared : [DoctorDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        fetchDoctorsShared()
        
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        
        doctorTableView.register(DoctorSharingTableViewCell.cellNib, forCellReuseIdentifier: DoctorSharingTableViewCell.cellIdentifier)
        doctorTableView.estimatedRowHeight = 80
        doctorTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func fetchDoctorsShared(){
        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedBy").observe(.childAdded, with: { (snapshot) in
            let newDoctor = DoctorDetail()
            newDoctor.docUid = snapshot.key
            newDoctor.docName = snapshot.value as! String?
            self.doctorsShared.append(newDoctor)
            self.doctorTableView.reloadData()
            
            dump(self.doctorsShared)
        })
        
    }
    
    func fetchAllDoctors(){
        dbRef?.child("users").observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {return}
            
            let newUser = PatientDetail(withDictionary: value)
            
            
        })
        
        
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var doctorTableView: UITableView!
}

extension SharingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return doctorsShared.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = doctorTableView.dequeueReusableCell(withIdentifier: "DocListCell", for: indexPath) as? DoctorSharingTableViewCell else {return UITableViewCell()}
        
        let doctor = doctorsShared[indexPath.row]
        
        cell.doctorNameLabel.text = doctor.docName
        cell.sharedSwitch.isOn = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
    }
}
