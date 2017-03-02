//
//  CreateAccountViewController.swift
//  medR
//
//  Created by george chin fu hou on 02/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class CreateAccountViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    var dbRef : FIRDatabaseReference!
    

    
    //Outlet
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var userEmailField: UITextField!
    
    @IBOutlet weak var userPasswordField: UITextField!
    
    @IBOutlet weak var userComfirmPasswordField: UITextField!
    
    @IBOutlet weak var userAge: UITextField!
    @IBOutlet weak var userGender: UITextField!
    @IBOutlet weak var userContactNumber: UITextField!
    @IBOutlet weak var userAddress: UITextField!
    @IBOutlet weak var userEmergencyContact: UITextField!
    
    @IBOutlet weak var userEmergencyName: UITextField!
    
    @IBOutlet weak var userEmergencyRelationship: UITextField!
    
    
    //Action
    @IBAction func userVerifyField(_ sender: UIButton) {
        
        createAccount()
    }
    
    func createAccount() {
        
        guard let name = userNameField.text,
            let email = userEmailField.text,
            let password = userPasswordField.text,
            let comfirmPassword = userComfirmPasswordField.text,
            let age = userAge.text,
            let gender = userGender.text,
            let contactNumber = userContactNumber.text,
            let address = userAddress.text,
            let emergencyContact = userEmergencyContact.text,
            let emergencyName = userEmergencyName.text,
            let emergencyRelationship = userEmergencyRelationship.text else{
                return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user,error) in
            
            if error != nil{
                
                self.showErrorAlert(errorMessage: " Email/Password Format Invalid")
                print (error! as NSError)
                return
            }
            
            
            //send infromation to database
            let ref = FIRDatabase.database().reference()
            let value = ["fullName": name, "email": email, "age": age, "gender": gender, "contactNumber": contactNumber, "address": address, "emergencyContact": emergencyContact, "emergencyName": emergencyName, "emergencyRelationship": emergencyRelationship] as [String : Any]
            let uid = FIRAuth.auth()?.currentUser?.uid
            ref.child("users").child("specialUID").updateChildValues(value, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print("err")
                    return
                }
                self.handleUser(user: user!)
            })
            
            
            
        })
    }
    
    func handleUser(user: FIRUser) {
        print("User found: \(user.uid)")
        
        
        guard let controller = UIStoryboard(name: "GeogStoryBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as?  LoginViewController else { return }
        navigationController? .pushViewController(controller, animated: true)
    }

       

    func showErrorAlert(errorMessage: String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle:  .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated:true, completion: nil)
        
    }
    
}




