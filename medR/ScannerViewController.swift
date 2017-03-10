//
//  ScannerViewController.swift
//  medR
//
//  Created by Rui Ong on 10/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import FirebaseDatabase
import AVFoundation
import QRCodeReader
import MTBBarcodeScanner

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var dbRef : FIRDatabaseReference!
    var scanner: MTBBarcodeScanner?
    var successfulScannedDoc : DoctorDetail?
    var scannedID : String = "default"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        
        scanner = MTBBarcodeScanner(previewView: view)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startScanning()
        
        //dismiss(animated: true, completion: nil)
    }
    
    func startScanning(){
        do {
            try scanner?.startScanning(resultBlock: { (codes) in
                for code in codes! {
                    let stringValue = code.stringValue!
                    print("Found code: \(stringValue)")
                    
                    self.scanner?.stopScanning()
                    self.alert()
                    
                    self.scannedID = stringValue
                    if self.scannedID != "default" {
                        let scannedDoctor = self.fetchDoctorInfo(uid: self.scannedID)
                        
                    } else {
                        print("no doctor found")
                    }
                }
            })
        } catch let error {
            print(error)
        }
        
    }
    
    func alert(){
        let alert = UIAlertController(title: "Found doctor", message: "Added doctor to your list.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let scan = UIAlertAction(title: "Scan again", style: .default) { (action) in
            self.startScanning()
        }
        
        alert.addAction(ok)
        alert.addAction(scan)
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchDoctorInfo(uid : String) -> DoctorDetail {
        var scannedDoctor = DoctorDetail()
        
        dbRef?.child("users").child(uid).child("docAcc").observe(.value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String : Any] else {return}
            scannedDoctor = DoctorDetail(withDictionary: value)
            scannedDoctor.docUid = uid
            
            self.fetchDoctorDetail(uid: self.scannedID, doctor: scannedDoctor)
            
        })
        
        return scannedDoctor
    }
    
    func fetchDoctorDetail(uid: String, doctor : DoctorDetail){
        dbRef?.child("users").child(uid).child("fullName").observe(.value, with: { (snapshot) in
            doctor.docName = snapshot.value as? String
            
            if doctor != nil {
            self.successfulScannedDoc = doctor
            self.addDoctor(uid: self.scannedID)
            }
        })
    }
    
    func addDoctor(uid : String){
        
        dbRef?.child("users").child(PatientDetail.current.uid).child("sharedWith").child(uid).setValue(successfulScannedDoc?.docName)
        
        dbRef?.child("users").child(uid).child("sharedBy").child(PatientDetail.current.uid).setValue(successfulScannedDoc?.docName)
        
    }
    
    
}

