//
//  VisitRecord.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import Foundation

class VisitRecord {
    
    var doctorID : String?
    var timeStamp : TimeInterval?
    var patientID : String?
    var symptoms : String?
    var examResult : String?
    
    init(withDictionary dictionary: [String: Any]) {
        doctorID = dictionary["doctorID"] as? String
        patientID = dictionary["patientID"] as? String
        symptoms = dictionary["symptoms"] as? String
        examResult = dictionary["examResult"] as? String
        
        if let timeStampString = dictionary["timeStamp"] as? String {
            timeStamp = TimeInterval(timeStampString)
        }
    }
}
