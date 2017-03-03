//
//  EmergencyDetail.swift
//  medR
//
//  Created by Kok Yong on 03/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import Foundation


class EmergencyDetail {
    
    //emergency
    var emergencyName : String?
    var emergencyRelationship : String?
    var emergencyContact : String?

    
    init(){}
    
    init(withDictionary dictionary: [String: Any]) {
        emergencyName = dictionary["emergencyName"] as? String
        emergencyRelationship = dictionary["emergencyRelationship"] as? String
        emergencyContact = dictionary["emergencyContact"] as? String

    }
}
