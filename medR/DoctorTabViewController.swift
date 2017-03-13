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
        let storyboardThree = UIStoryboard(name: "QRStoryboard", bundle: Bundle.main)
        
        //tab zero
        guard let tabZero = storyboardThree.instantiateViewController(withIdentifier: "QueueListViewController") as?  QueueListViewController else { return }
        let tabZeroBarItem = UITabBarItem(title: "Queue List", image: UIImage(named: "quelistBlack.png"), selectedImage: UIImage(named: "quelistBlack.png"))
        
        tabZero.tabBarItem = tabZeroBarItem
        
        //tab one
        guard let tabOne = storyboard.instantiateViewController(withIdentifier: "SearchPatientViewController") as?  SearchPatientViewController else { return }
        let tabOneBarItem = UITabBarItem(title: "Patient List", image: UIImage(named: "patientlistBlack.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        //tab two
        guard let tabTwo = storyboardTwo.instantiateViewController(withIdentifier: "EntryViewController") as?  EntryViewController else { return }
        let tabTwoBarItem2 = UITabBarItem(title: "New Entry", image: UIImage(named: "newEntryBlack.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        
        //tab three
        guard let tabThree = storyboard.instantiateViewController(withIdentifier: "PatientProfileViewController") as?  PatientProfileViewController else { return }
        
        tabThree.isDoctorMode = true
        
                let tabThreeBarItem3 = UITabBarItem(title: "Profile", image: UIImage(named: "profileBlack.png"), selectedImage: UIImage(named: "profileRed.png"))
        
        tabThree.tabBarItem = tabThreeBarItem3
        
        // add tabs
        self.viewControllers = [tabZero, tabOne, tabTwo, tabThree]
        
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        
//    }


}
