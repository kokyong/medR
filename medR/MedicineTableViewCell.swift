//
//  MedicineTableViewCell.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "MedCell"
    static let cellNib = UINib(nibName: "MedicineTableViewCell", bundle: Bundle.main)

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var medTF: UITextField!
    @IBOutlet weak var medDetailPV: UIPickerView!
    
}
