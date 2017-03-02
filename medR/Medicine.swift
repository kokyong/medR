//
//  Medicine.swift
//  medR
//
//  Created by Rui Ong on 02/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import Foundation

class Medicine {
    
    var medName : String?
    var timesPerDay : String?
    var amPm : String?
    var befAft : String?
    
    init(){}
    
    init(withDictionary dictionary: [String: Any]) {
        medName = dictionary["medName"] as? String
        timesPerDay = dictionary["timesPerDay"] as? String
        amPm = dictionary["amPm"] as? String
        befAft = dictionary["befAft"] as? String
    }
}


//class Person {
//    var name : String = ""
//    var age : Int = 0
//    
//    init(){
//        name = "default"
//        age = 10
//    }
//    
//    init(name : String, age : Int) {
//        self.name = name
//        self.age = age
//    }
//    
//    init(dict : [String:Any]){
//        self.name = dict["name"] as? String ?? "default"
//        self.age = 10
//        
//    }
//}
//
//let ppl = Person()
//ppl.name = "name2"
//// naem = default
//
//let ppl2 = Person(name: "asd", age: 123)
//
//let dict = ["name" : "jjj"]
//let ppl3 = Person(dict: dict)
