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
    var filteredDoctors : [DoctorDetail] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doctorTableView.backgroundColor = UIColor(red: 62.0 / 256 , green: 62.0 / 256 , blue: 62.0 / 256, alpha: 1.0)
        
        dbRef = FIRDatabase.database().reference()
        fetchDoctorsShared()
        
        searchBar.tintColor = UIColor.blue
        searchBar.delegate = self
        
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        
        doctorTableView.register(DoctorSharingTableViewCell.cellNib, forCellReuseIdentifier: DoctorSharingTableViewCell.cellIdentifier)
        doctorTableView.estimatedRowHeight = 80
        doctorTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    func fetchDoctorsShared(){
        
        
        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedWith").observe(.value, with: { (snapshot) in
            
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
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            resetSearch()
        } else {
            filteredDoctors = doctorsShared.filter({( doctor : DoctorDetail) -> Bool in
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
    
    @IBAction func moreDocBtn(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AllDoctorsViewController") as? AllDoctorsViewController else {return}
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //QR code
    
    func handleQRSuccessScan(uid: String){
        
    }
    
    
    @IBAction func scanQR(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "QRStoryboard", bundle: Bundle.main)
        guard let scanner = storyboard.instantiateViewController(withIdentifier: "ScannerViewController") as?  ScannerViewController else { return }
        navigationController?.pushViewController(scanner, animated: true)
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
        cell.addDoctorBtn.isHidden = true
        cell.addPatientBtn.isHidden = true
        cell.entryBtn.isHidden = true
        cell.delegate = self
        cell.currentCellPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailPage = storyboard?.instantiateViewController(withIdentifier: "DoctorDetailsViewController") as? DoctorDetailsViewController else {return}
        
        navigationController?.pushViewController(detailPage, animated: true)
        
        let doctorToDisplay = filteredDoctors[indexPath.row]
        
        detailPage.displayDocWithUID = doctorToDisplay.docUid!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    func switchOff(indexPath: IndexPath){
        
        let selectedDoctor = doctorsShared[indexPath.row]
        
        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedWith").child(selectedDoctor.docUid!).removeValue()
        
        dbRef?.child("users").child(selectedDoctor.docUid!).child("sharedBy").child(PatientDetail.current.uid).removeValue()
    }
    
    func switchOn(indexPath: IndexPath){
        
        let selectedDoctor = doctorsShared[indexPath.row]
        
        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedBy").child(selectedDoctor.docUid!).setValue(selectedDoctor.docName)
        
        //fetchDoctorsShared()
    }
}

