//
//  ViewController.swift
//  QRCodeAcaner
//
//  Created by MacbookPro on 8/18/2559 BE.
//  Copyright © 2558 MagicSpring. All rights reserved.
//

import UIKit
import AVFoundation

class QRcodeController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //@IBOutlet weak var messageLabel:UILabel!
    var cancelButton = UIButton()

    let isGetQRCode = UserDefaults.standard
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var scanType = ""

    // Added to support different barcodes
    //let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeDataMatrixCode, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeCode39Mod43Code]
    
    let supportedBarCodes = [AVMetadataObjectTypeQRCode]

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)

            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes

            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)

            // Start video capture
            captureSession?.startRunning()

            // Move the message label to the top view
            //view.bringSubviewToFront(messageLabel)

            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()

            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }

        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print("got error")
            print(error)
            return
        }
        
        self.cancelButton.frame = CGRect(x: 0, y: self.screenHeight-40, width: self.screenWidth, height: 40)
        self.cancelButton.setTitle("Cancel", for: UIControlState())
        self.cancelButton.backgroundColor = UIColor.black
        self.cancelButton.tintColor = UIColor.white
        self.cancelButton.addTarget(self, action: #selector(QRcodeController.cancelScan(_:)), for: .touchUpInside)
        self.view.addSubview(self.cancelButton)
        view.bringSubview(toFront: cancelButton)

    }

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {

        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //messageLabel.text = "No barcode/QR code is detected"
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            if metadataObj.stringValue != nil {
                isScan = true
                QRCode = metadataObj.stringValue!
                print("Got a QRCode need to show video now >> \(metadataObj.stringValue)")
                
                //if QR code right format this will show up input deposit data
                if utilityFuncs().isValidQRCode(code: QRCode) {
                    let splitQRcode = QRCode.components(separatedBy: "-")
                    print("Place Name: \(splitQRcode[0])")
                    print("Table No: \(splitQRcode[1])")
                    
                    self.dismiss(animated: true, completion: {}) //Dismiss view when scan successful
                } else {
                    print("wrong format")
                    isScan = false
                    QRCode = ""
                }
            } else {
                print("???")
            }
        }
    }
    
    func cancelScan(_ sender: UIButton) {
        //reset grobal data
        isScan = false
        QRCode = ""
        //Dismiss view
        self.dismiss(animated: true, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


/* This is how to use
 func scanAction(_ sender: UIButton) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let secondViewController = storyboard.instantiateViewController(withIdentifier: "barcodeWindow") as! QRcodeController
    secondViewController.scanType = "login"
    self.present(secondViewController, animated: true, completion: nil)
 }
*/









