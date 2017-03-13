//
//  SearchPatientViewController(extension).swift
//  medR
//
//  Created by Kok Yong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import Foundation
import UIKit

extension SearchPatientViewController: UITableViewDataSource, AddPatientDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredPatient.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "DocListCell", for: indexPath) as? DoctorSharingTableViewCell else {return UITableViewCell()}
        
        let currentPatient = filteredPatient[indexPath.row]
//        guard let index = patientName.index(where: { (str) -> Bool in
//            return str == currentName
//        })
//            else {
//                return cell
//        }
        
//        let patientIndex = patientName[index]
//        let patientID = patientUID[index]
        
        cell.addPatientDelegate = self
        cell.doctorNameLabel.text = currentPatient.fullName
        cell.sharedSwitch.isHidden = true
        cell.addDoctorBtn.isHidden = true
        cell.entryBtn.isHidden = true
        cell.currentCellPath = indexPath
        cell.addPatientBtn.titleLabel?.text = "Add"
        
        if let url = currentPatient.patientImage {
            if let data = NSData(contentsOf: url as URL) {
                cell.profilePic.image = UIImage(data: data as Data)
            }
        }
        
        return cell
    }
    
}

extension SearchPatientViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "RuiStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserHistoryViewController") as! UserHistoryViewController
        
        //configure VC
        
       // controller.selectedUID = self.patientUID
        let selectedPatient = filteredPatient[indexPath.row]
        controller.selectedUID = selectedPatient.uid
        controller.isDoctorMode = true
        
        //show
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
 
    
    
}

extension SearchPatientViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchActive = true
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = false
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count == 0 {
            resetSearch()
        } else {
//            filteredPatient = patientName.filter({( text ) -> Bool in
//                return text.lowercased().range(of: searchText.lowercased()) != nil
//            })
            filteredPatient = patients.filter({ (patient) -> Bool in
                patient.fullName?.lowercased().range(of: searchText.lowercased()) != nil
            })
            
            self.searchTableView.reloadData()
        }
    }
    
    func resetSearch(){
        
//        filteredPatient = patientName
        filteredPatient = patients
        searchTableView.reloadData()
        
    }
    
}



