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
import MessageUI

class UserHistoryViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference!
    
    var history : [String] = []
    var completeRecord : [VisitRecord] = []
    var lastContentOffSet : CGFloat = 0.0
    var scrollDirection : String = "default"
    
    var isDoctorMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        
        
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
        historyCollectionView.isPagingEnabled = true
        
        historyCollectionView.register(HistoryCollectionViewCell.cellNib, forCellWithReuseIdentifier: HistoryCollectionViewCell.cellIdentifier)
        
        historyCollectionView.reloadData()
        
        //PATIENT DETAIL POP UP FUNC
        fetchName()
        menuDetailFunc()
        fetchMenuData()
        observeHistoryList()
        
        if isDoctorMode == false {
            self.backBtn.isHidden = true
            
            self.detailBtn.isHidden = true
        }
    }
    
    //MARK: PATIENT DETAIL POP UP
    
    var selectedUID : String = PatientDetail.current.uid
    
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
    
    
    @IBOutlet weak var menuImage: UIImageView!{
        didSet{
            menuImage.layer.cornerRadius = menuImage.frame.size.height/2
            menuImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuGender: UILabel!
    @IBOutlet weak var menuEmail: UILabel!
  
    @IBOutlet weak var menuTel: UIButton!{
        
        didSet{
            
            menuTel.addTarget(self, action: #selector(menuTelbtn), for: .touchUpInside)
            
        }
    }
    
    func menuTelbtn() {
        
        let url : NSURL = URL(string: "tel://\(displayPhoneNumber)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
   // @IBOutlet weak var menuNumber: UILabel!
    @IBOutlet weak var manuEmergencyName: UILabel!
    @IBOutlet weak var menuEmergencyRelationship: UILabel!
    @IBOutlet weak var menuEmergencyNumber: UILabel!
    
    
    func fetchMenuData() {
        
        dbRef.child("users").child(selectedUID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let value = snapshot.value as? NSDictionary
            
            let patientImage = value?["profileURL"] as? String
            let fullName = value?["fullName"] as? String
            let contactNumber = value?["contactNumber"] as? String
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
            self.displayPhoneNumber = contactNumber ?? ""
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
            //self.menuTel.titleLabel?.text = self.displayPhoneNumber
            self.menuTel.setTitle(self.displayPhoneNumber, for: .normal)
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
        
        dbRef.child("users").child(selectedUID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            
            let fullName = value?["fullName"] as? String ?? ""
            let age = value?["age"] as? String ?? ""
            
            self.displayFullName = fullName
            self.displayAge = age
            
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
            detailBtn.setTitle("Detail", for: .normal)
            
        }else{
            
            constraintMenu.constant = 120
            detailBtn.setTitle("Dismiss", for: .normal)
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
        //self.present(controller, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //MARK: BODY
    
    
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    lazy var dateFormater : DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "d MMM yyyy"
        return _dateFormatter
    }()
    
    let reuseIdentifier : String = "HistoryCell"
    
    
    func observeHistoryList(){
        //TODO : change back to selected id
        print(selectedUID)
        
        let ref = dbRef.child("users").child(selectedUID).child("history")
        ref.observe(.childAdded, with: { (snapshot) in
            
            //let newHistory = VisitRecord()
            //newHistory.historyID = snapshot.key
            let newHistoryID = snapshot.key
            self.history.append(newHistoryID)
            self.observeHistoryDetails()
            
        })
        print(ref)
    }
    
    func observeHistoryDetails() {
        
        for each in history {
            
            dbRef.child("history").child(each).observe(.value, with: { (snapshot) in
                guard let value = snapshot.value as? [String : Any] else {return}
                
                let history = VisitRecord(withDictionary: value)
                history.historyID = snapshot.key
                self.completeRecord.insert(history, at: 0)
                self.historyCollectionView.reloadData()
                
            })
            
        }
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
        
        return completeRecord.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HistoryCollectionViewCell else {return UICollectionViewCell()}
        
        let record = completeRecord[indexPath.section]
        
        if indexPath.item == 0 {
            
            let historyCellPath = indexPath
            
            if let timestamp = record.timeStamp {
                cell.dateLabel.text = dateFormater.string(from: Date(timeIntervalSinceReferenceDate: timestamp))
            } else {
                cell.dateLabel.text = ""
            }
            
            let symptoms = attributedString(title: "Symptoms", content: record.symptoms ?? "")
            let diagnosis = attributedString(title: "Diagnosis", content: record.diagnosis ?? "")
            let majorIllness = attributedString(title: "Major illness", content: record.majorIllness ?? "")
            let treatment = attributedString(title: "Treatment", content: record.treatment ?? "")
            let surgery = attributedString(title: "Surgery", content: record.surgery ?? "")
            let residualProblem = attributedString(title: "Residual problem", content: record.residualProblem ?? "")
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
}

//hide label if ""
//adjust cell height accordingly (based on the larger of either cell)
//2nd cell blank before scroll?
//snap to next cell
