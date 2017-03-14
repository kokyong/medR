//
//  SearchPatientViewController.swift
//  medR
//
//  Created by Kok Yong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import Firebase


class SearchPatientViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
//    var patientName = [String]()
//    var patientUID = [String]()
//    
    var patients = [PatientDetail]()
    
    var searchActive : Bool = false
    
//    var filteredPatient = [String]()
    var filteredPatient = [PatientDetail]()
    var ref : FIRDatabaseReference!

    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            
            searchBar.delegate = self
            
        }
    }
    
    
    //IBOutlet
    @IBOutlet weak var searchTableView: UITableView!{
        
        didSet{
            
            searchTableView.dataSource = self
            searchTableView.delegate = self

            
        }
    }    
    
    
    //viewDidLaod
    override func viewDidLoad() {
        super.viewDidLoad()
        
          self.searchTableView.backgroundColor = UIColor(red: 62.0 / 256 , green: 62.0 / 256 , blue: 62.0 / 256, alpha: 1.0)
        
        ref = FIRDatabase.database().reference()
        
        
       searchTableView.register(DoctorSharingTableViewCell.cellNib, forCellReuseIdentifier: DoctorSharingTableViewCell.cellIdentifier)
        searchTableView.estimatedRowHeight = 80
        searchTableView.rowHeight = UITableViewAutomaticDimension
        
        fetchPatientData()
        //searchTableView.reloadData()
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        searchTableView.reloadData()
//    }
    
    
        func fetchPatientData() {
    
            ref.child("users").child(PatientDetail.current.uid).child("sharedBy").observe(.value, with: { (snapshot) in
                print(snapshot)
    
    
                for user in snapshot.children {
    
                    let newPatient = PatientDetail()
                    newPatient.fullName = (user as AnyObject).value
                    newPatient.uid = (user as AnyObject).key
                    self.fetchProfilePic(key: newPatient.uid, patient: newPatient)
                    self.patients.append(newPatient)


                    self.filteredPatient = self.patients
                    self.searchTableView.reloadData()
                }
            })
        }
    
    func fetchProfilePic(key : String, patient : PatientDetail){
        ref.child("users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            let patientImage = value?["profileURL"] as? String ?? ""
            patient.patientImage = URL(string: patientImage)
            self.searchTableView.reloadData()
        })
    }


    func addPatient(indexPath: IndexPath){
        let patient = filteredPatient[indexPath.row]
        
        ref.child("users").child(PatientDetail.current.uid).child("queue").child(patient.uid).setValue(patient.fullName)
        
        
    }
 
    
    
}
