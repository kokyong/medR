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
}

protocol AddDocDelegate : class {
    func addDoctor(indexPath: IndexPath)
}

protocol AddPatientDelegate : class {
    func addPatient(indexPath: IndexPath)
}

protocol EntryDelegate : class {
    func showEntry(indexPath : IndexPath)
}

class DoctorSharingTableViewCell: UITableViewCell {
    
    var currentCellPath : IndexPath!
    weak var delegate : SwitchDelegate?
    weak var addDocDelegate : AddDocDelegate?
    weak var addPatientDelegate : AddPatientDelegate?
    weak var entryDelegate : EntryDelegate?
    
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
    
    func handleAddDoctor(){
        addDocDelegate?.addDoctor(indexPath: currentCellPath)
        addDoctorBtn.setTitle("Added", for: .normal)
    }
    
    func handleAddPatient(){
        addPatientDelegate?.addPatient(indexPath: currentCellPath)
        addPatientBtn.setTitle("Added", for: .normal)
    }
    
    func handleShowEntry(){
        entryDelegate?.showEntry(indexPath: currentCellPath)
    }
    
    @IBOutlet weak var addDoctorBtn: UIButton!{
        didSet{
            addDoctorBtn.addTarget(self, action: #selector(handleAddDoctor), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var addPatientBtn: UIButton!{
        didSet{
            addPatientBtn.addTarget(self, action: #selector(handleAddPatient), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var entryBtn: UIButton!{
        didSet{
            entryBtn.addTarget(self, action: #selector(handleShowEntry), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var profilePic: UIImageView!{
        didSet{
            profilePic.layer.cornerRadius = profilePic.frame.size.height/2
            profilePic.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var sharedSwitch: UISwitch!{
        didSet{
            sharedSwitch.addTarget(self, action: #selector(switchChanged), for: .touchUpInside)
        }
    }
}
