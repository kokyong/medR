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
import FBSDKLoginKit
import Firebase
import GoogleSignIn


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate  {
    
    
   
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
        
        setupFacebookButton()
        setupGoogleButton()
        
        
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
    
    fileprivate func setupFacebookButton() {
        //add facebook sign in button
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        // frame are obselete
        loginButton.frame = CGRect(x: 16, y: 430, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        
        loginButton.readPermissions = ["email", "public_profile"]
        

    }
    
    fileprivate func setupGoogleButton() {
        //add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 520, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
        
    }
    
        
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
            
        }
        showEmailAddress()
    }
    
    func showEmailAddress() {
        
        let accessToken = FBSDKAccessToken.current()
        guard let  accessTokenString = accessToken?.tokenString else {return}
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print ("Something went wrong with our FB user: ", error ?? "")
                return
            }
            print ("Successfully logged in with our user", user ?? "")
            
            })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
        (connection, result, err) in
        
            if err != nil {
                print("Failed to start graph request", err)
                return
            }
            
            print(result ?? "")
    }
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



