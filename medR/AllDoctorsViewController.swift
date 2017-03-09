//
//  AllDoctorsViewController.swift
//  medR
//
//  Created by Rui Ong on 09/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AllDoctorsViewController: UIViewController, UISearchBarDelegate {
    
    var dbRef : FIRDatabaseReference!
    var allDoctors : [DoctorDetail] = []
    var filteredDoctors : [DoctorDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        fetchAllDoctors()

        searchBar.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        searchTableView.register(DoctorSharingTableViewCell.cellNib, forCellReuseIdentifier: DoctorSharingTableViewCell.cellIdentifier)
        searchTableView.estimatedRowHeight = 80
        searchTableView.rowHeight = UITableViewAutomaticDimension
        
    }

    func fetchAllDoctors(){
        dbRef?.child("doctors").observe(.childAdded, with: { (snapshot) in
            let newDoctor = DoctorDetail()
            newDoctor.docUid = snapshot.key
            newDoctor.docName = snapshot.value as! String?
            
            self.allDoctors.append(newDoctor)
            self.filteredDoctors = self.allDoctors
            self.searchTableView.reloadData()
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
            
            searchTableView.reloadData()
            
        }
    }
    
    func resetSearch(){
        filteredDoctors = allDoctors
        searchTableView.reloadData()
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
}

extension AllDoctorsViewController: UITableViewDelegate, UITableViewDataSource, ButtonDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredDoctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "DocListCell", for: indexPath) as? DoctorSharingTableViewCell else {return UITableViewCell()}
        
        let doctor = filteredDoctors[indexPath.row]
        
        cell.doctorNameLabel.text = doctor.docName
        cell.sharedSwitch.isHidden = true
        cell.currentCellPath = indexPath
        cell.delegateBtn = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func addDoctor(indexPath: IndexPath){
        let doctor = filteredDoctors[indexPath.row]
        
        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedBy").child(doctor.docUid!).setValue(doctor.docName)
            searchBar.text = ""
        
}

}
