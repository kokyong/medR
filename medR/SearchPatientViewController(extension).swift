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
        
        return displaySharedBy.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchPatientDetailCell") else {return UITableViewCell()}
        
        
        
//        cell.textLabel?.text = self.displaySharedBy as? String
//        cell.detailTextLabel?.text = self.displaySymptom as? String
        
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
