//
//  SearchPatientViewController(extension).swift
//  medR
//
//  Created by Kok Yong on 01/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import Foundation
import UIKit

extension SearchPatientViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredPatient.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchPatientDetailCell") else {return UITableViewCell()}
        
        let currentName = filteredPatient[indexPath.row]
        guard let index = patientName.index(where: { (str) -> Bool in
            return str == currentName
        })
            else {
                return cell
        }
        
        let patientIndex = patientName[index]
        let patientID = patientUID[index]
        
        cell.textLabel?.text = patientIndex
        cell.detailTextLabel?.text = patientID
        
        return cell
    }
    
}

extension SearchPatientViewController: UITableViewDelegate{
    
    
    /*
     let storyboard = UIStoryboard(name: "RuiStoryboard", bundle: nil)
     let controller = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
     
     //configure VC
     
     
     //show
     self.present(controller, animated: true, completion: nil)
     */
    
    
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
    
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //
    //
    //        if searchText != "" {
    //            filteredPatient = patientName.filter({ (text) -> Bool in
    //                let tmp: NSString = text as NSString
    //                let range = tmp.range(of: searchText.lowercased(), options: NSString.CompareOptions.caseInsensitive)
    //                return range.location != NSNotFound
    //            })
    //            if filteredPatient.count == 0{
    //                searchActive = false;
    //            } else {
    //                searchActive = true;
    //            }
    //        }else{
    //            filteredPatient = patientName
    //        }
    //
    //        self.searchTableView.reloadData()
    //
    //    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count == 0 {
            resetSearch()
        } else {
            filteredPatient = patientName.filter({( text ) -> Bool in
                return text.lowercased().range(of: searchText.lowercased()) != nil
            })
            
            self.searchTableView.reloadData()
        }
    }
    
    func resetSearch(){
        filteredPatient = patientName
        //sortStationsByDistance()
        searchTableView.reloadData()
    }
    
}



