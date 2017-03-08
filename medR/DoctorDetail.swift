//
//  DoctorDetail.swift
//  medR
//
//  Created by Kok Yong on 03/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import Foundation

class DoctorDetail {
    
    static var doctorDetails : [DoctorDetail] = []
    
    var docUid : String? //KY plz save UID
    var docName : String? //KY plz save name
    var lisenceID : String?
    var clinicAddress : String?
    var specialty : String?
    var info : String?
    
    //Visited Patient
    var patientID : String?
    var patientName : String?
    
    var sharedBy : [PatientDetail]?

    
    init(){}
    
    init(withDictionary dictionary: [String: Any]) {
        lisenceID = dictionary["licenceID"] as? String
        clinicAddress = dictionary["clinicAddress"] as? String
        specialty = dictionary["specialty"] as? String
        info = dictionary["info"] as? String
        
        //Visited Patient
        patientID = dictionary["patientID"] as? String
        patientName = dictionary["patientName"] as? String
        
    }
}
