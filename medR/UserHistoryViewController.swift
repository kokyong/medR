//
//  UserHistoryViewController.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit

class UserHistoryViewController: UIViewController {
    
    let reuseIdentifier : String = "HistoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
        historyCollectionView.register(HistoryCollectionViewCell.cellNib, forCellWithReuseIdentifier: HistoryCollectionViewCell.cellIdentifier)
        
        historyCollectionView.reloadData()
        
    }
    
    
    
    
    
    @IBOutlet weak var historyCollectionView: UICollectionView!
}

extension UserHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 100
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HistoryCollectionViewCell else {return UICollectionViewCell()}
        
        cell.dateLabel.text = "Sec \(indexPath.section)/Item \(indexPath.item)"
        
        return cell
    }
    
}
