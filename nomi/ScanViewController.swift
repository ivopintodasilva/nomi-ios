//
//  ScanViewController.swift
//  nomi
//
//  Created by Ivo Silva on 24/12/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var selected_user_profile: Int?
    
    var scanned = false
    var contact_id: Int?
    
    @IBOutlet weak var profile_picker: UIPickerView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserProfilesModel.sharedInstance.user_profiles.count > 0{
            self.selected_user_profile = UserProfilesModel.sharedInstance.user_profiles[0].id
        }
        
        profile_picker.delegate = self
        profile_picker.dataSource = self
        
        let ps = profile_picker.sizeThatFits(CGSize.zero)
        profile_picker.frame = CGRectMake(0.0, 0.0, ps.width, 216.0)
        //profile_picker.backgroundColor = UIColor (red: 0, green: 0, blue: 0, alpha: 0.2)
        
        scanned = false
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
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
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            view.bringSubviewToFront(profile_picker)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Move the message label to the top view
            //view.bringSubviewToFront(messageLabel)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }

        // Do any additional setup after loading the view.
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            //messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) && scanned == false{
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            
            
            
            if metadataObj.stringValue != nil{
                scanned = true
                
                // DO THE PROFILE LINKAGE HERE!
                //print(metadataObj.stringValue)
                
                
                
                let json = JSON(data: metadataObj.stringValue.dataUsingEncoding(NSUTF8StringEncoding)!)
                
                if(json["id"] != nil){
                    print(json["id"])
                    self.contact_id = json["id"].intValue
                    self.performSegueWithIdentifier("scanned", sender: self)
                }
                else{
                    
                    let alert = UIAlertView()
                    alert.delegate = self
                    alert.title = "Invalid code"
                    alert.message = "Come on, don't fool us!"
                    alert.addButtonWithTitle("Ok, I'm sorry")
                    alert.show()
                }
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "scanned") {
            let svc = segue.destinationViewController as! ScannedViewController;
            svc.contact_id = self.contact_id
            svc.user_profile = self.selected_user_profile
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print ("button pressed")
        scanned = false
    }
    
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return UserProfilesModel.sharedInstance.user_profiles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UserProfilesModel.sharedInstance.user_profiles[row].name
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        
        if UserProfilesModel.sharedInstance.user_profiles[row].color == "BLACK" {
            pickerLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[row].color == "BLUE" {
            pickerLabel.backgroundColor = UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[row].color == "GREEN" {
            pickerLabel.backgroundColor = UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[row].color == "RED" {
            pickerLabel.backgroundColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)

        }
        else if UserProfilesModel.sharedInstance.user_profiles[row].color == "WHITE" {
            pickerLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        pickerLabel.textColor = UIColor.whiteColor()
        pickerLabel.text = UserProfilesModel.sharedInstance.user_profiles[row].name
        pickerLabel.font = UIFont(name: "Avenir", size: 20) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if UserProfilesModel.sharedInstance.user_profiles.count > 0{
            self.selected_user_profile = UserProfilesModel.sharedInstance.user_profiles[row].id
            print (UserProfilesModel.sharedInstance.user_profiles[row].id)
        }
    }
    

}
