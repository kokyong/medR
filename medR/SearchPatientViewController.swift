//
//  SearchPatientViewController.swift
//  medR
//
//  Created by Kok Yong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import Firebase

class Patient {
    var name : String = ""
    var id : String = ""
}

class SearchPatientViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
//    var patientName = [String]()
//    var patientUID = [String]()
//    
    var patients = [Patient]()
    
    var searchActive : Bool = false
    
//    var filteredPatient = [String]()
    var filteredPatient = [Patient]()
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
        
        ref = FIRDatabase.database().reference()
        fetchPatientData()
        
       searchTableView.register(DoctorSharingTableViewCell.cellNib, forCellReuseIdentifier: DoctorSharingTableViewCell.cellIdentifier)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        searchTableView.reloadData()
    }
    
    
        func fetchPatientData() {
    
            ref.child("users").child(PatientDetail.current.uid).child("sharedBy").observe(.value, with: { (snapshot) in
                print(snapshot)
    
    
                for user in snapshot.children {
    
                    let newPatient = Patient()
                    newPatient.name = (user as AnyObject).value
                    newPatient.id = (user as AnyObject).key
                    self.patients.append(newPatient)


                    
                }

//                self.filteredPatient = self.patientName
                self.filteredPatient = self.patients
                self.searchTableView.reloadData()
                
                
            })
        }

    func addPatient(indexPath: IndexPath){
        let patient = filteredPatient[indexPath.row]
        
        ref.child("users").child(PatientDetail.current.uid).child("queue").child(patient.id).setValue(patient.name)
        
        
    }
 
    
    
}
