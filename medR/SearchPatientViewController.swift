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
    
    let uid = FIRAuth.auth()?.currentUser?.uid

    
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
        
    }
    
    
        func fetchPatientData() {
    
            ref.child("users").child(uid!).child("sharedBy").observe(.value, with: { (snapshot) in
                print(snapshot)
    
    
                for user in snapshot.children {
    
                    let newPatient = Patient()
                    newPatient.name = (user as AnyObject).key
                    newPatient.id = (user as AnyObject).value
                    self.patients.append(newPatient)

//                    self.patientUID.append((user as AnyObject).key)
//                    self.patientName.append((user as AnyObject).value)
                    
                }

//                self.filteredPatient = self.patientName
                self.filteredPatient = self.patients
                self.searchTableView.reloadData()
                
                
            })
        }

    
 
    
    
}
