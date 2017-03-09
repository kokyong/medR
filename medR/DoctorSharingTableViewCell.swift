//
//  DoctorSharingTableViewCell.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DoctorSharingTableViewCell: UITableViewCell {
    
    var dbRef : FIRDatabaseReference!
    
    static let cellIdentifier = "DocListCell"
    static let cellNib = UINib(nibName: "DoctorSharingTableViewCell", bundle: Bundle.main)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchChanged(){
        if sharedSwitch.isOn == false {
            dbRef = FIRDatabase.database().reference()
            
            
        }
    }
    
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorDetailLabel: UILabel!
    @IBOutlet weak var sharedSwitch: UISwitch!
    
    
}
