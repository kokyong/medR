//
//  HistoryCollectionViewCell.swift
//  medR
//
//  Created by Rui Ong on 02/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit


class HistoryCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "HistoryCell"
    static let cellNib = UINib(nibName: "HistoryCollectionViewCell", bundle: Bundle.main)

    override func awakeFromNib() {
        super.awakeFromNib()
        //setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setUp()
    }
    
    
    func setUp(){
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        
    }
    
    

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var nextAppLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
