//
//  EntryViewController.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EntryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var currentPatient : PatientDetail?
    
    var dbRef : FIRDatabaseReference?
    var numberOfMed : Int = 3
    var cellAtIndexPath : MedicineTableViewCell?
    var medList : [Medicine] = []
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.isScrollEnabled = true
            scrollView.contentSize = scrollView.frame.size
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        
        medicationTableView.dataSource = self
        medicationTableView.register(MedicineTableViewCell.cellNib, forCellReuseIdentifier: MedicineTableViewCell.cellIdentifier)
        medicationTableView.estimatedRowHeight = 80
        medicationTableView.rowHeight = UITableViewAutomaticDimension
        
        if currentPatient != nil {
            fetchPatientInfo(uid: (currentPatient?.uid)!)
        }
        
    }
    
    func fetchPatientInfo(uid : String){
        
        dbRef?.child("users").child(uid).observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let contactNumeber = value?["contactNumber"] as? String
            let gender = value?["gender"] as? String
            let age = value?["age"] as? String
            
            self.currentPatient?.gender = gender
            self.currentPatient?.contactNumeber = contactNumeber
            self.currentPatient?.age = age
            
            self.nameTF.text = self.currentPatient?.fullName
            self.genderTF.text = self.currentPatient?.gender
            self.ageTF.text = self.currentPatient?.age
            self.phoneTF.text = self.currentPatient?.contactNumeber
        })
    }
    
    func submit() {
        //let timestamp = String(Date.timeIntervalSinceReferenceDate)
        //patientID
        getMedicines()
        
        var medArray : [[String : Any]] = []
        let timestamp = String(Date.timeIntervalSinceReferenceDate)
        
        for eachMed in medList {
            var newMed = [String : String]()
            
            newMed = ["medName" : eachMed.medName!, "timesPerDay" : eachMed.timesPerDay, "amPm" : eachMed.amPm, "befAft" : eachMed.befAft]
            
            medArray.append(newMed)
        }
        
        let validPatientID = currentPatient?.uid ?? "no ID"
        
        var historyDictionary : [String: Any] = ["doctorID" : PatientDetail.current.uid, "dateTime" : timestamp,
                                                 "patientID" : validPatientID,            "patFullName" : nameTF.text, "gender": genderTF.text, "age" : ageTF.text, "phone" : phoneTF.text, "medicine" : medArray]
        
        if let symptom = symptomTV.text{
            historyDictionary["symptoms"] = symptom
        } else {
            historyDictionary["symptoms"] = ""
        }
        
        if let diagnosis = diagnosisTV.text{
            historyDictionary["diagnosis"] = diagnosis
        } else {
            historyDictionary["diagnosis"] = ""
        }
        
        if let majorIllness = majorIllnessTV.text{
            historyDictionary["majorIllness"] = majorIllness
        } else {
            historyDictionary["majorIllness"] = ""
        }
        
        if let treatment = treatmentTV.text{
            historyDictionary["treatment"] = treatment
        } else {
            historyDictionary["treatment"] = ""
        }
        
        if let surgery = surgeryTV.text{
            historyDictionary["surgery"] = surgery
        } else {
            historyDictionary["surgery"] = ""
        }
        
        if let residualProblem = residualProTV.text{
            historyDictionary["residualProblem"] = residualProblem
        } else {
            historyDictionary["residualProblem"] = ""
        }
        
        if let nextAppointment = nextAppTV.text{
            historyDictionary["nextAppointment"] = nextAppointment
        } else {
            historyDictionary["nextAppointment"] = ""
        }
        
        let autoIDRef = dbRef?.child("history").childByAutoId()
        
        autoIDRef?.setValue(historyDictionary)
        
        //SAVE THE HISTORY UNDER USER ID
        dbRef?.child("users").child(validPatientID).child("history").child((autoIDRef?.key)!).setValue(timestamp)
        
    }
    
    //MARK: Picker View
    var medDetail = [["1 time", "2 times", "3 times"],["AM","PM","Any"],["Before meal","After meal", "Any"]]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return medDetail.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return medDetail[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        var width : CGFloat = 100
        if component == 0 {
            width = 100
        }
        
        if component == 1 {
            width = 50
        }
        
        if component == 2 {
            width = 150
        }
        
        return width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func addMed() {
        numberOfMed += 1
        medicationTableView.reloadData()
    }
    
    
    @IBOutlet weak var submitBtn: UIButton!{
        didSet{
            submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var nextAppTV: UITextView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var symptomTV: UITextView!
    @IBOutlet weak var diagnosisTV: UITextView!
    @IBOutlet weak var majorIllnessTV: UITextView!
    @IBOutlet weak var treatmentTV: UITextView!
    @IBOutlet weak var surgeryTV: UITextView!
    @IBOutlet weak var residualProTV: UITextView!
    @IBOutlet weak var medicationTableView: UITableView!
    @IBOutlet weak var addMedBtn: UIButton!{
        didSet{
            addMedBtn.addTarget(self, action: #selector(addMed), for: .touchUpInside)
        }
    }
}

extension EntryViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfMed
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MedCell", for: indexPath) as? MedicineTableViewCell else {return UITableViewCell()}
        
        cellAtIndexPath = cell
        cell.medDetailPV.delegate = self
        cell.medDetailPV.dataSource = self
        
        return cell
    }
    
    func getMedicines(){
        for i in 0..<numberOfMed{
            var newMed = Medicine()
            
            if let cell = medicationTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? MedicineTableViewCell {
                if cell.medTF.text != "" {
                    
                    newMed.medName = cell.medTF.text
                    let picker = cell.medDetailPV
                    
                    if let timesPerDay = picker?.selectedRow(inComponent: 0){
                        if timesPerDay == 0 {
                            newMed.timesPerDay = "1 time per day"
                        }
                        else if timesPerDay == 1 {
                            newMed.timesPerDay = "2 times per day"
                        }
                        else {
                            newMed.timesPerDay = "3 times per day"
                        }
                    }
                    
                    if let amPm = picker?.selectedRow(inComponent: 1){
                        if amPm == 0 {
                            newMed.amPm = "AM"
                        }
                        else if amPm == 1 {
                            newMed.amPm = "PM"
                        }
                        else {
                            newMed.amPm = "anytime"
                        }
                    }
                    
                    if let befAft = picker?.selectedRow(inComponent: 2){
                        if befAft == 0 {
                            newMed.befAft = "before meal"
                        }
                        else if befAft == 1 {
                            newMed.befAft = "after meal"
                        }
                        else {
                            newMed.befAft = "either before or after meal"
                        }
                    }
                } else {
                    return
                }
            }
            medList.append(newMed)
        }
    }
}
