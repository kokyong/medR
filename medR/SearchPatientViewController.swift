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
    
    var patientName = [String]()
    var patientUID = [String]()
    
    var searchActive : Bool = false
    
    var filteredPatient = [String]()
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
        
    }
//    
//    func fetchPatientData() {
//        
//        ref.child("users").child("specialUID").child("sharedBy").observe(.value, with: { (snapshot) in
//            print(snapshot)
//            
//            
//            for user in snapshot.children {
//                
//                self.patientUID.append((user as AnyObject).key)
//                self.patientName.append((user as AnyObject).value)
//                
//                
//                
//            }
//            
//            self.filteredPatient = self.patientName
//            self.searchTableView.reloadData()
//            
//            
//        })
//    }
    
    
        func fetchPatientData() {
    
            ref.child("users").child("specialUID").child("sharedBy").observe(.value, with: { (snapshot) in
                print(snapshot)
    
    
                for user in snapshot.children {
    
                    self.patientUID.append((user as AnyObject).key)
                    self.patientName.append((user as AnyObject).value)
                    
                }
    
                self.filteredPatient = self.patientName
                self.searchTableView.reloadData()
                
                
            })
        }

    
 
    
    
}
