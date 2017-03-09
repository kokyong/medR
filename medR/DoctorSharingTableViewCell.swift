//
//  DoctorSharingTableViewCell.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol SwitchDelegate : class {
    func switchOff(indexPath: IndexPath)
    func switchOn(indexPath: IndexPath)
    func addDoctor(indexPath: IndexPath)
}

class DoctorSharingTableViewCell: UITableViewCell {
    
    var dbRef : FIRDatabaseReference!
    var currentCellPath : IndexPath!
    weak var delegate : SwitchDelegate?
    
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
            delegate?.switchOff(indexPath: currentCellPath)
        } else {
            //delegate?.switchOn(indexPath: currentCellPath)
        }
    }
    
    func handleAdd(){
        delegate?.addDoctor(indexPath: currentCellPath)
    }
    
    @IBOutlet weak var addDoctorBtn: UIButton!{
        didSet{
            addDoctorBtn.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        }
    }
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorDetailLabel: UILabel!
    @IBOutlet weak var sharedSwitch: UISwitch!{
        didSet{
            sharedSwitch.addTarget(self, action: #selector(switchChanged), for: .touchUpInside)
        }
    }
}
