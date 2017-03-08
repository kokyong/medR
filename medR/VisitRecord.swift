//
//  VisitRecord.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import Foundation

class VisitRecord {
    
    var historyID : String?
    var doctorID : String?
    var timeStamp : TimeInterval?
    var patientID : String?
    var symptoms : String?
    var diagnosis : String?
    var majorIllness : String?
    var treatment : String?
    var surgery : String?
    var residualProblem : String?
    var medicines : [Medicine]?
    var nextAppointment : String = ""
   
    
    
    init(){}
    
    init(withDictionary dictionary: [String: Any]) {
        doctorID = dictionary["doctorID"] as? String
        patientID = dictionary["patientID"] as? String
        symptoms = dictionary["symptoms"] as? String
        diagnosis = dictionary["diagnosis"] as? String
        majorIllness = dictionary["majorIllness"] as? String
        treatment = dictionary["treatment"] as? String
        surgery = dictionary["surgery"] as? String
        residualProblem = dictionary["residualProblem"] as? String
        nextAppointment = dictionary["nextAppointment"] as? String ?? ""
            
        if let timeStampString = dictionary["dateTime"] as? String {
            timeStamp = TimeInterval(timeStampString)
        }
        
        if let allMedicines = dictionary["medicine"] as? [Any] {
            medicines = []
            for medicine in allMedicines {
                if let medValue = medicine as? [String: String]{
                    let newMed = Medicine(withDictionary: medValue)
                    medicines?.append(newMed)
                }
            }
        }
    }
}
