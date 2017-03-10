//
//  ScannerViewController.swift
//  medR
//
//  Created by Rui Ong on 10/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import MTBBarcodeScanner

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var scanner: MTBBarcodeScanner?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner = MTBBarcodeScanner(previewView: view)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            try scanner?.startScanning(resultBlock: { (codes) in
                for code in codes! {
                    let stringValue = code.stringValue!
                    print("Found code: \(stringValue)")
                }
            })
        } catch let error {
            print(error)
        }
        
        
    }
}

