//
//  DoctorTabViewController.swift
//  medR
//
//  Created by Rui Ong on 08/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit

class DoctorTabViewController: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.delegate = self
        //super.viewWillAppear(animated)
        
        let storyboard = UIStoryboard(name: "KYStoryboard", bundle: Bundle.main)
        let storyboardTwo = UIStoryboard(name: "RuiStoryboard", bundle: Bundle.main)
        
        guard let tabOne = storyboard.instantiateViewController(withIdentifier: "SearchPatientViewController") as?  SearchPatientViewController else { return }
        let tabOneBarItem = UITabBarItem(title: "Patient List", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        
        guard let tabTwo = storyboardTwo.instantiateViewController(withIdentifier: "EntryViewController") as?  EntryViewController else { return }
        let tabTwoBarItem2 = UITabBarItem(title: "New Entry", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        
        
        guard let tabThree = storyboard.instantiateViewController(withIdentifier: "PatientProfileViewController") as?  PatientProfileViewController else { return }
        let tabThreeBarItem3 = UITabBarItem(title: "Profile", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        
        tabThree.tabBarItem = tabThreeBarItem3
        
        self.viewControllers = [tabOne, tabTwo, tabThree]
        
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        
//    }


}
