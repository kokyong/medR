//
//  SharingViewController.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SharingViewController: UIViewController, UISearchBarDelegate {
    
    var dbRef : FIRDatabaseReference!
    var doctorsShared : [DoctorDetail] = []
    var allDoctors : [DoctorDetail] = []
    var filteredDoctors : [DoctorDetail] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        fetchDoctorsShared()
        fetchAllDoctors()
        
        
        searchBar.delegate = self
        
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        
        doctorTableView.register(DoctorSharingTableViewCell.cellNib, forCellReuseIdentifier: DoctorSharingTableViewCell.cellIdentifier)
        doctorTableView.estimatedRowHeight = 80
        doctorTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func fetchDoctorsShared(){
        
        
        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedBy").observe(.value, with: { (snapshot) in
            
            self.filteredDoctors = []
            self.doctorsShared = []
            guard let value = snapshot.value as? [String : String] else {
                self.doctorTableView.reloadData()
                return
            }
            
            for (key, realValue) in value {
                let newDoctor = DoctorDetail()
                newDoctor.docUid = key
                newDoctor.docName = realValue
                self.doctorsShared.append(newDoctor)
            }
            
            self.filteredDoctors = self.doctorsShared
            self.doctorTableView.reloadData()
        })
        
//        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedBy").observe(.childRemoved, with: { (snapshot) in
//            let newDoctor = DoctorDetail()
//            newDoctor.docUid = snapshot.key
//            newDoctor.docName = snapshot.value as! String?
//            self.doctorsShared.append(newDoctor)
//            self.filteredDoctors = self.doctorsShared
//            self.doctorTableView.reloadData()
//        })
        
        
    }
    
    func fetchAllDoctors(){
        dbRef?.child("doctors").observe(.childAdded, with: { (snapshot) in
            //guard let value = snapshot.value as? [String] else {return}
            
            let newDoctor = DoctorDetail()
            newDoctor.docUid = snapshot.key
            newDoctor.docName = snapshot.value as! String?
            
            self.allDoctors.append(newDoctor)
        })
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            resetSearch()
        } else {
            filteredDoctors = allDoctors.filter({( doctor : DoctorDetail) -> Bool in
                // to start, let's just search by name
                return doctor.docName?.lowercased().range(of: searchText.lowercased()) != nil
            })
            
            doctorTableView.reloadData()
            
        }
    }
    
    func resetSearch(){
        filteredDoctors = doctorsShared
        doctorTableView.reloadData()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var doctorTableView: UITableView!
}

extension SharingViewController: UITableViewDelegate, UITableViewDataSource, SwitchDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredDoctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = doctorTableView.dequeueReusableCell(withIdentifier: "DocListCell", for: indexPath) as? DoctorSharingTableViewCell else {return UITableViewCell()}
        
        let doctor = filteredDoctors[indexPath.row]
        
        cell.doctorNameLabel.text = doctor.docName
        cell.sharedSwitch.isOn = true
        cell.delegate = self
        cell.currentCellPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            }
    
    func addDoctor(indexPath: IndexPath){
        let doctor = filteredDoctors[indexPath.row]
        
        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedBy").child(doctor.docUid!).setValue(doctor.docName)
        //fetchDoctorsShared()
        searchBar.text = ""

    }
    
    func switchOff(indexPath: IndexPath){
        
        let selectedDoctor = doctorsShared[indexPath.row]
        
        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedBy").child(selectedDoctor.docUid!).removeValue()
        
        //fetchDoctorsShared()
    }
    
    func switchOn(indexPath: IndexPath){
        
        let selectedDoctor = doctorsShared[indexPath.row]
        
        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedBy").child(selectedDoctor.docUid!).setValue(selectedDoctor.docName)
        
        //fetchDoctorsShared()
    }
}


