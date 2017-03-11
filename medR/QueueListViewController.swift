//
//  QueueListViewController.swift
//  medR
//
//  Created by Rui Ong on 10/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import Firebase


class QueueListViewController: UIViewController{
    
    var dbRef : FIRDatabaseReference!
    var queueList : [PatientDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        
        QueueListTableView.delegate = self
        QueueListTableView.dataSource = self
        
        QueueListTableView.register(DoctorSharingTableViewCell.cellNib, forCellReuseIdentifier: DoctorSharingTableViewCell.cellIdentifier)
        
        fetchQueueList()
    }
    
    func fetchQueueList(){
        dbRef?.child("users").child(PatientDetail.current.uid).child("queue").observe(.value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String : String] else {
                self.QueueListTableView.reloadData()
                return
            }
            
            for (key, realValue) in value {
                let newPatient = PatientDetail()
                newPatient.uid = key
                newPatient.fullName = realValue
                self.fetchProfilePic(key: key, patient: newPatient)
                self.queueList.append(newPatient)
            }

            self.QueueListTableView.reloadData()
        })
}
    
    func fetchProfilePic(key : String, patient : PatientDetail){
        dbRef.child("users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            let patientImage = value?["profileURL"] as? String ?? ""
            patient.patientImage = URL(string: patientImage)
            
        })
    }
    
    @IBOutlet weak var QueueListTableView: UITableView!
    
}

extension QueueListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
     return queueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocListCell", for: indexPath) as? DoctorSharingTableViewCell else {return UITableViewCell()}
        
        let patient = queueList[indexPath.row]
        
        cell.doctorNameLabel.text = patient.fullName
        
        //display profile pic at cells
    
        if let url = patient.patientImage {
            if let data = NSData(contentsOf: url as URL) {
                cell.profilePic.image = UIImage(data: data as Data)
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            queueList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let deletedPatient = queueList[indexPath.row]
            dbRef?.child("users").child(PatientDetail.current.uid).child("queue").child(deletedPatient.uid).removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var itemToMove = queueList[sourceIndexPath.row]
        queueList.remove(at: sourceIndexPath.row)
        queueList.insert(itemToMove, at: destinationIndexPath.row)
        
        dbRef?.child("users").child(PatientDetail.current.uid).child("queue").removeValue()
        
        for each in queueList {
            dbRef?.child("users").child(PatientDetail.current.uid).child("queue").child(each.uid).setValue(each.fullName)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "RuiStoryboard", bundle: Bundle.main)
        guard let patientDetail = storyboard.instantiateViewController(withIdentifier: "UserHistoryViewController") as? UserHistoryViewController else {return}
        
        navigationController?.pushViewController(patientDetail, animated: true)
        
        // pass patient UID
        
    }
}
