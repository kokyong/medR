//
//  LoginViewController.swift
//  medR
//
//  Created by george chin fu hou on 02/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userLogin: UIButton!{
        didSet {
            userLogin.addTarget(self, action: #selector(login), for: .touchUpInside)
        }
    }
    
    
    @IBAction func userSignup(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as? CreateAccountViewController else { return }
        
    
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);

        
        
        let mycolor : UIColor = UIColor.lightGray
        
        //userEmail
        userEmail.layer.borderColor = mycolor.cgColor
        userEmail.layer.borderWidth = 2
        userEmail.layer.cornerRadius = 8
        
        //userPassword
        userPassword.layer.borderColor = mycolor.cgColor
        userPassword.layer.borderWidth = 2
        userPassword.layer.cornerRadius = 8
    
       
        
        
        }
    // Login Function
    func login () {
        FIRAuth.auth()?.signIn(withEmail: userEmail.text!, password: userPassword.text!, completion: {(user,error) in
            
            if error != nil {
                
                print(error! as NSError)
                self.showErrorAlert(errorMessage: "Email/Password Incorrect")
                return
                
            }
            //                guard let controller = UIStoryboard(name: "", bundle: Bundle.main).instantiateViewController(withIdentifier: "") as?  UserHistoryViewController else { return }
            //                self.navigationController? .pushViewController(controller, animated: true)
            //
        })
    }
    
    func showErrorAlert(errorMessage: String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle:  .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated:true, completion: nil)
    }

    
    }





