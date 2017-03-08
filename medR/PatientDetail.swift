//
//  PatientDetail.swift
//  medR
//
//  Created by Kok Yong on 03/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import Foundation



class PatientDetail {
    
    static var patientDetails : [PatientDetail] = []
    
    //patient
    var patientImage : URL?
    var fullName : String?
    var contactNumeber : String?
    var gender : String?
    var email : String?
    var age : String?
    var address : String?
    //var ifDoctor : [DoctorDetail] need to rearrange
    
    var uid : String?

    init(){}
    
    init(withDictionary dictionary: [String: Any]) {
        fullName = dictionary["fullName"] as? String
        contactNumeber = dictionary["contactNumeber"] as? String
        gender = dictionary["gender"] as? String
        email = dictionary["email"] as? String
        age = dictionary["age"] as? String
        address = dictionary["address"] as? String
        
        if let displayPicture = dictionary["profileURL"] as? String{
            
            patientImage = URL(string: displayPicture)
        }


    }
}
