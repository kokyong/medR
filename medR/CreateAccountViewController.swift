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

class CreateAccountViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate ,UITextViewDelegate {
    
    var dbRef : FIRDatabaseReference!
    var selectedImage : UIImage?

    
    //Outlet
    @IBOutlet weak var userImage: UIImageView!
    
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
    @IBAction func userLogOut(_ sender: UIButton) {
        
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
            
            
            navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBOutlet weak var userSelectPicture: UIButton!{
        didSet{
            
            userSelectPicture.addTarget(self, action: #selector(displayImagePicker), for: .touchUpInside)
        }
        
    }

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
            ref.child("users").child(uid!).updateChildValues(value, withCompletionBlock: { (err, ref) in
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
        
        
        uploadImage(image: userImage.image!)
        
        guard let controller = UIStoryboard(name: "GeogStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as?  LoginViewController
            else { return }
        navigationController? .pushViewController(controller, animated: true)
    }

       var userStorage: FIRStorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.navigationItem.setHidesBackButton(true, animated:true);
        
        let mycolor : UIColor = UIColor.lightGray
        //userNameField
        userNameField.layer.borderColor = mycolor.cgColor
        userNameField.layer.borderWidth = 2
        userNameField.layer.cornerRadius = 8
        
        //userEmailField
        userEmailField.layer.borderColor = mycolor.cgColor
        userEmailField.layer.borderWidth = 2
        userEmailField.layer.cornerRadius = 8
        
        //userPasswordField
        userPasswordField.layer.borderColor = mycolor.cgColor
        userPasswordField.layer.borderWidth = 2
        userPasswordField.layer.cornerRadius = 8

        //userComfirmPasswordField
        userComfirmPasswordField.layer.borderColor = mycolor.cgColor
        userComfirmPasswordField.layer.borderWidth = 2
        userComfirmPasswordField.layer.cornerRadius = 8
        
        //userAge
        userAge.layer.borderColor = mycolor.cgColor
        userAge.layer.borderWidth = 2
        userAge.layer.cornerRadius = 8
        
        
        //userGender
        userGender.layer.borderColor = mycolor.cgColor
        userGender.layer.borderWidth = 2
        userGender.layer.cornerRadius = 8
        
        //userContactNumber
        userContactNumber.layer.borderColor = mycolor.cgColor
        userContactNumber.layer.borderWidth = 2
        userContactNumber.layer.cornerRadius = 8
        
        //userAddress
        userAddress.layer.borderColor = mycolor.cgColor
        userAddress.layer.borderWidth = 2
        userAddress.layer.cornerRadius = 8
        
        //userEmergencyName
        userEmergencyName.layer.borderColor = mycolor.cgColor
        userEmergencyName.layer.borderWidth = 2
        userEmergencyName.layer.cornerRadius = 8
        
        //userEmergencyContact
        userEmergencyContact.layer.borderColor = mycolor.cgColor
        userEmergencyContact.layer.borderWidth = 2
        userEmergencyContact.layer.cornerRadius = 8
        
        //user
        userEmergencyRelationship.layer.borderColor = mycolor.cgColor
        userEmergencyRelationship.layer.borderWidth = 2
        userEmergencyRelationship.layer.cornerRadius = 8
        
        
        
        
        dbRef = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://medr-4c91c.appspot.com")
        userStorage = storage.child("users")
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func displayImagePicker(){
        
        let pickerViewController = UIImagePickerController ()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            pickerViewController.sourceType = .photoLibrary
            
        }
        
        pickerViewController.delegate = self
        
        present(pickerViewController, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setProfileImage(image : image)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setProfileImage(image : UIImage) {
        userImage.image = image
    }
    
    func uploadImage(image: UIImage){
        
        // create the Data from UIImage
        guard let imageData = UIImageJPEGRepresentation(image, 0.0) else { return }
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        let uid = FIRAuth.auth()?.currentUser?.uid
        let storageRef = FIRStorage.storage().reference()
        storageRef.child("folder").child("\(uid!).jpeg").put(imageData, metadata: metadata) { (meta, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                
                if let downloadURL = meta?.downloadURL() {
                    //got image url
                    self.dbRef.child("users").child(uid!).updateChildValues(["profileURL":downloadURL.absoluteString])
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

    
    

    func showErrorAlert(errorMessage: String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle:  .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated:true, completion: nil)
        
    }
    
}




