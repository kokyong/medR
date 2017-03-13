//
//  UserTabViewController.swift
//  medR
//
//  Created by Rui Ong on 08/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit

class UserTabViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let storyboard = UIStoryboard(name: "RuiStoryboard", bundle: Bundle.main)
        
        guard let tabOne = storyboard.instantiateViewController(withIdentifier: "UserHistoryViewController") as?  UserHistoryViewController else { return }
        let tabOneBarItem = UITabBarItem(title: "My History", image: UIImage(named: "patientlistBlack.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
    
        guard let tabTwo = storyboard.instantiateViewController(withIdentifier: "SharingNavigationController") as?  UINavigationController else { return }
        let tabTwoBarItem2 = UITabBarItem(title: "My Doctors", image: UIImage(named: "doctors.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        let storyboardTwo = UIStoryboard(name: "KYStoryboard", bundle: Bundle.main)
        
        guard let tabThree = storyboardTwo.instantiateViewController(withIdentifier: "PatientProfileViewController") as?  PatientProfileViewController else { return }
        let tabThreeBarItem3 = UITabBarItem(title: "Profile"
        , image: UIImage(named: "profileBlack.png"), selectedImage: UIImage(named: "profileRed.png"))
        
        tabThree.isDoctorMode = false
        
        tabThree.tabBarItem = tabThreeBarItem3

        
        self.viewControllers = [tabOne, tabTwo, tabThree]
    }
    

    
}
