//
//  UserHistoryViewController.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class UserHistoryViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference!
    
    var history : [VisitRecord] = []
    var lastContentOffSet : CGFloat = 0.0
    var scrollDirection : String = "default"
    
    
    
    
    //KY

    var selectedUID = String()
    
    //patient
    var displayPatientImage = String()
    var displayFullName = String()
    var displayPhoneNumber = String()
    var displayGender = String()
    var displayEmail = String()
    var displayAge = String()
    var displayAdress = String()
    
    //emergency
    var displayEmergencyName = String()
    var displayEmergencyRelationship = String()
    var displayContactEmergency = String()
    
    //Doctor
    var displayLisenceID = String()
    var displayClinicAddress = String()
    var displaySpecialty = String()
    var displayInfo = String()
    
    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuGender: UILabel!
    @IBOutlet weak var menuEmail: UILabel!
    @IBOutlet weak var menuNumber: UILabel!
    @IBOutlet weak var manuEmergencyName: UILabel!
    @IBOutlet weak var menuEmergencyRelationship: UILabel!
    @IBOutlet weak var menuEmergencyNumber: UILabel!
    
    
    func fetchMenuData() {
        
        dbRef.child("users").child(PatientDetail.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            let patientImage = value?["profileURL"] as? String
            let fullName = value?["fullName"] as? String
            let contactNumeber = value?["contactNumber"] as? String
            let gender = value?["gender"] as? String
            let email = value?["email"] as? String
            let age = value?["age"] as? String
            let address = value?["address"] as? String
            
            //emergency
            let emergencyName = value?["emergencyName"] as? String
            let emergencyRelationship = value?["emergencyRelationship"] as? String
            let emergencyContact = value?["emergencyContact"] as? String
            
            
            
            //patient
            self.displayPatientImage = patientImage ?? ""
            self.displayFullName = fullName ?? ""
            self.displayPhoneNumber = contactNumeber ?? ""
            self.displayGender = gender ?? ""
            self.displayEmail = email ?? ""
            self.displayAge = age ?? ""
            self.displayAdress = address ?? ""
            
            //emergency
            self.displayEmergencyName = emergencyName!
            self.displayContactEmergency = emergencyContact!
            self.displayEmergencyRelationship = emergencyRelationship!
            
            
            
            //patinet
            self.menuName.text = "\(self.displayFullName) (\(self.displayAge))"
            self.menuNumber.text = self.displayPhoneNumber
            self.menuGender.text = self.displayGender
            self.menuEmail.text = self.displayEmail
           
            
            //emergency
            self.manuEmergencyName.text = self.displayEmergencyName
            self.menuEmergencyNumber.text = self.displayContactEmergency
            self.menuEmergencyRelationship.text = self.displayEmergencyRelationship
            
            
            if let url = NSURL(string: self.displayPatientImage) {
                if let data = NSData(contentsOf: url as URL) {
                    self.menuImage.image = UIImage(data: data as Data)
                }
            }
            
            
            
        })
        
        
        
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func fetchName() {
        
        dbRef.child("users").child(PatientDetail.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            
            let fullName = value?["fullName"] as? String
            let age = value?["age"] as? String
            
            self.displayFullName = fullName!
            self.displayAge = age!
            
            self.nameLabel.text = "\(self.displayFullName) (\(self.displayAge))"
            
            
        })
        
    }
    
    @IBOutlet weak var detailBtn: UIButton!{
        
        didSet{
            
            detailBtn.addTarget(self, action: #selector(detailBtnFunc), for: .touchUpInside)
            
        }
        
    }
    
    @IBOutlet weak var constraintMenu: NSLayoutConstraint!
    
    var menuShowing = false
    
    func detailBtnFunc() {
        
        if menuShowing {
            
            constraintMenu.constant = -475
        }else{
            
            constraintMenu.constant = 120
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        menuShowing = !menuShowing
    }
    
    
    @IBOutlet weak var menuDetail: UIView!
    
    func menuDetailFunc() {
        
        menuDetail.layer.cornerRadius = 1
        menuDetail.layer.shadowOpacity = 0.8
        
    }
    
    @IBOutlet weak var backBtn: UIButton!{
        
        didSet{
            
            backBtn.addTarget(self, action: #selector(backBtnFunc), for: .touchUpInside)
        }
    }
    
    func backBtnFunc() {
        
        let storyboard = UIStoryboard(name: "KYStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchPatientViewController") as! SearchPatientViewController
        
        //configure VC
        
        // controller.selectedUID = self.patientUID
        
        
        //show
        self.present(controller, animated: true, completion: nil)

    }
    
    
    
    //KY
    
    
    //    @IBOutlet weak var userTabBar: UITabBar!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    lazy var dateFormater : DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "d MMM yyyy"
        return _dateFormatter
    }()
    
    let reuseIdentifier : String = "HistoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        observeHistory()
        
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
        historyCollectionView.isPagingEnabled = true
        
        historyCollectionView.register(HistoryCollectionViewCell.cellNib, forCellWithReuseIdentifier: HistoryCollectionViewCell.cellIdentifier)
        
        historyCollectionView.reloadData()
        
        //KY
        fetchName()
        menuDetailFunc()
        fetchMenuData()
        
        
    }
    
    
    func observeHistory(){
        
        dbRef?.child("history").observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {return}
            let newHistory = VisitRecord(withDictionary: value)
            newHistory.historyID = snapshot.key
            self.history.insert(newHistory, at: 0)
            self.historyCollectionView.reloadData()
            
            
            
            dump(self.history)
        })
    }
    
    
    
    
}

extension UserHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func attributedString(title: String, content: String) -> NSMutableAttributedString {
        
        if content != "" {
            let titleReturn = "\(title)\n"
            let contentReturn = "\(content)\n\n"
            let bold = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)]
            let boldTitle = NSMutableAttributedString(string: titleReturn, attributes: bold)
            let normalContent = NSMutableAttributedString(string: contentReturn)
            
            boldTitle.append(normalContent)
            return boldTitle
            
        } else {
            return NSMutableAttributedString()
        }
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return history.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HistoryCollectionViewCell else {return UICollectionViewCell()}
        
        let record = history[indexPath.section]
        
        if indexPath.item == 0 {
            
            let historyCellPath = indexPath
            
            if let timestamp = record.timeStamp {
                cell.dateLabel.text = dateFormater.string(from: Date(timeIntervalSinceReferenceDate: timestamp))
            } else {
                cell.dateLabel.text = ""
            }
            
            let symptoms = attributedString(title: "Symptoms", content: record.symptoms!)
            let diagnosis = attributedString(title: "Diagnosis", content: record.diagnosis!)
            let majorIllness = attributedString(title: "Major illness", content: record.majorIllness!)
            let treatment = attributedString(title: "Treatment", content: record.treatment!)
            let surgery = attributedString(title: "Surgery", content: record.surgery!)
            let residualProblem = attributedString(title: "Residual problem", content: record.residualProblem!)
            var displayString = NSMutableAttributedString()
            
            displayString.append(symptoms)
            displayString.append(diagnosis)
            displayString.append(majorIllness)
            displayString.append(treatment)
            displayString.append(surgery)
            displayString.append(residualProblem)
            
            cell.detailLabel.attributedText = displayString
            cell.titleLabel.text = "Visit Details"
            
        } else {
            
            var displayMed = NSMutableAttributedString()
            
            if let allMeds = record.medicines {
                for eachMed in allMeds {
                    
                    let medDetails = "\(eachMed.timesPerDay), taken at \(eachMed.amPm), \(eachMed.befAft)"
                    let med = attributedString(title: eachMed.medName!, content: medDetails)
                    displayMed.append(med)
                }
            }
            
            cell.detailLabel.attributedText = displayMed
            cell.titleLabel.text = "Prescription"
            
        }
        
        
        
        if let timestamp = record.timeStamp {
            cell.dateLabel.text = dateFormater.string(from: Date(timeIntervalSinceReferenceDate: timestamp))
        } else {
            cell.dateLabel.text = ""
        }
        
        cell.nextAppLabel.text = "Next appointment: \(record.nextAppointment)"
        
        
        
        return cell
    }
    
    
    //    func estimatecellHeight(indexPath : IndexPath) -> Double {
    //
    //        let cell = HistoryCollectionViewCell()[indexPath]
    //
    //                let detailLabelHeight = Double(cell.detailLabel.bounds.height)
    //                let historylayout = collectionView.collectionViewLayout as? HistoryCollectionViewLayout
    //
    //                let cellHeight = detailLabelHeight + 200.0
    //
    //                return cellHeight
    //            }
    
    
}

//hide label if ""
//adjust cell height accordingly (based on the larger of either cell)
//2nd cell blank before scroll?
//snap to next cell
