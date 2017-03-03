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
    
    var displaySharedBy = [String]()
    
    var displaySymptom = [String]()
    var historyArray = [String]()
    var visitRecords : [VisitRecord] = []
    
    var ref : FIRDatabaseReference!
    
    
    //IBOutlet
    @IBOutlet weak var searchTableView: UITableView!{
        
        didSet{
            
            searchTableView.dataSource = self
            searchTableView.delegate = self
            
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    //viewDidLaod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
//        fetchFullName()
//        fetchSymtoms()
        
    }
    
//    func fetchFullName() {
//        
//        ref.child("users").child("specialUID").child("sharedBy").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            
//            let value = snapshot.value as? NSDictionary
//            
//            let sharedBy = value?["sharedBy"] as? String
//            
//            self.displaySharedBy = [sharedBy!]
//            
//            
//        })
//        
//    }
    
    //array of history
//    func fetchHistory() {
//        
//        ref.child("users").child("specialUID").child("history").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            
//            let value = snapshot.value as? NSDictionary
//            
//            let history = value?["history"] as? String
//            
//            self.historyArray = [history!]
//            
//        })
//        
//
//        
//    }
    
//    func fetchSymtoms() {
//        
//        //call 2nd child
//        
//        ref.child("history").child("specialUID").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            
//            let value = snapshot.value as? NSDictionary
//            
//            let symptoms = value?["symptoms"] as? String
//            
//            self.displaySymptom = [symptoms!]
//            
//            
//        })
//        
//        
//    }
    
    
    
}
