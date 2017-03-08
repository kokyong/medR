//
//  UserHistoryViewController.swift
//  medR
//
//  Created by Rui Ong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserHistoryViewController: UIViewController {
    
    var dbRef : FIRDatabaseReference!
    
    var history : [VisitRecord] = []
    var lastContentOffSet : CGFloat = 0.0
    var scrollDirection : String = "default"
    
    lazy var dateFormater : DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "d MMM yyyy"
        return _dateFormatter
    }()
    
    let reuseIdentifier : String = "HistoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
        observeHistory()
        
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
        historyCollectionView.isPagingEnabled = true
        
        historyCollectionView.register(HistoryCollectionViewCell.cellNib, forCellWithReuseIdentifier: HistoryCollectionViewCell.cellIdentifier)

        
        historyCollectionView.reloadData()
        
    }
    
    func observeHistory(){
        
        dbRef?.child("history").observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {return}
            let newHistory = VisitRecord(withDictionary: value)
            newHistory.historyID = snapshot.key
            self.history.insert(newHistory, at: 0)
            self.historyCollectionView.reloadData()
            
            
            
            dump(self.history)
        })
    }
    
    
    
    @IBOutlet weak var historyCollectionView: UICollectionView!
}

extension UserHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        
        func attributedString(title: String, content: String) -> NSMutableAttributedString {
            
            if content != "" {
                let titleReturn = "\(title)\n"
                let contentReturn = "\(content)\n\n"
                let bold = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)]
                let boldTitle = NSMutableAttributedString(string: titleReturn, attributes: bold)
                let normalContent = NSMutableAttributedString(string: contentReturn)
                
                boldTitle.append(normalContent)
                return boldTitle
                
            } else {
                return NSMutableAttributedString()
            }
            
        }
        
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            
            return history.count
        }
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return 2
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HistoryCollectionViewCell else {return UICollectionViewCell()}
            
            let record = history[indexPath.section]
            
            if indexPath.item == 0 {
                
                let historyCellPath = indexPath
                
                if let timestamp = record.timeStamp {
                    cell.dateLabel.text = dateFormater.string(from: Date(timeIntervalSinceReferenceDate: timestamp))
                } else {
                    cell.dateLabel.text = ""
                }
                
                let symptoms = attributedString(title: "Symptoms", content: record.symptoms!)
                let diagnosis = attributedString(title: "Diagnosis", content: record.diagnosis!)
                let majorIllness = attributedString(title: "Major illness", content: record.majorIllness!)
                let treatment = attributedString(title: "Treatment", content: record.treatment!)
                let surgery = attributedString(title: "Surgery", content: record.surgery!)
                let residualProblem = attributedString(title: "Residual problem", content: record.residualProblem!)
                var displayString = NSMutableAttributedString()
                
                displayString.append(symptoms)
                displayString.append(diagnosis)
                displayString.append(majorIllness)
                displayString.append(treatment)
                displayString.append(surgery)
                displayString.append(residualProblem)
                
                cell.detailLabel.attributedText = displayString
                cell.titleLabel.text = "Visit Details"
                
            } else {
                
                var displayMed = NSMutableAttributedString()
                
                if let allMeds = record.medicines {
                    for eachMed in allMeds {
                        
                        let medDetails = "\(eachMed.timesPerDay), taken at \(eachMed.amPm), \(eachMed.befAft)"
                        let med = attributedString(title: eachMed.medName!, content: medDetails)
                        displayMed.append(med)
                    }
                }
                
                cell.detailLabel.attributedText = displayMed
                cell.titleLabel.text = "Prescription"
                
            }
            
            
            
            if let timestamp = record.timeStamp {
                cell.dateLabel.text = dateFormater.string(from: Date(timeIntervalSinceReferenceDate: timestamp))
            } else {
                cell.dateLabel.text = ""
            }
            
            cell.nextAppLabel.text = "Next appointment: \(record.nextAppointment)"
            
            
            
            return cell
        }
        
        
        //    func estimatecellHeight(indexPath : IndexPath) -> Double {
        //
        //        let cell = HistoryCollectionViewCell()[indexPath]
        //
        //                let detailLabelHeight = Double(cell.detailLabel.bounds.height)
        //                let historylayout = collectionView.collectionViewLayout as? HistoryCollectionViewLayout
        //
        //                let cellHeight = detailLabelHeight + 200.0
        //
        //                return cellHeight
        //            }

    
}

//hide label if ""
//adjust cell height accordingly (based on the larger of either cell)
//2nd cell blank before scroll?
//snap to next cell
