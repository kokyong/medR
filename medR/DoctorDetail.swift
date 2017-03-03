//
//  DoctorDetail.swift
//  medR
//
//  Created by Kok Yong on 03/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import Foundation

class DoctorDetail {
    
    var lisenceID : String?
    var clinicAddress : String?
    var specialty : String?
    var info : String?
    
    
    init(){}
    
    init(withDictionary dictionary: [String: Any]) {
        lisenceID = dictionary["licenceID"] as? String
        clinicAddress = dictionary["clinicAddress"] as? String
        specialty = dictionary["specialty"] as? String
        info = dictionary["info"] as? String
        
    }
}
