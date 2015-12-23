//
//  ShareViewController.swift
//  nomi
//
//  Created by Ivo Silva on 25/11/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var qr_code_view: UIImageView!
    
    let gradePickerValues = ["Swag", "Trabalho", "Swaggermore"]

    @IBOutlet weak var share_picker: UIPickerView!
    
    var login_info: NSString?
    var profile_info: NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        // Do any additional setup after loading the view.
        
        
        // generate QR code
        var data: NSData
        data = "{\"id\":3}".dataUsingEncoding(NSUTF8StringEncoding)!
        
        /// Foreground color of the output
        /// Defaults to black
        //let color = CIColor(red: 181, green: 59, blue: 54)
        let color = CIColor(red: 0.71, green: 0.23, blue: 0.21)
        
        /// Background color of the output
        /// Defaults to white
        //let backgroundColor = CIColor(red: 0.71, green: 0.23, blue: 0.21)
        let backgroundColor = CIColor(red: 1, green: 1, blue: 1)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter!.setDefaults()
        qrFilter!.setValue(data, forKey: "inputMessage")
        qrFilter!.setValue("H", forKey: "inputCorrectionLevel")
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter!.setDefaults()
        colorFilter!.setValue(qrFilter!.outputImage, forKey: "inputImage")
        colorFilter!.setValue(color, forKey: "inputColor0")
        colorFilter!.setValue(backgroundColor, forKey: "inputColor1")
        let transformedImage = createNonInterpolatedUIImageFromCIImage(colorFilter!.outputImage!, withScale: 8.0)
        qr_code_view.image = transformedImage
        
        
        
        
        //share_picker = UIPickerView()
        
        share_picker.dataSource = self
        share_picker.delegate = self
        
        
        //print(login_info)
        //print(profile_info)
        
        print(UserInfoModel.sharedInstance.getId())
        print(UserInfoModel.sharedInstance.getFirstName())
        print(UserInfoModel.sharedInstance.getLastName())
        
    }
    
    
    func createNonInterpolatedUIImageFromCIImage(image: CIImage, withScale scale: CGFloat) -> UIImage {
        let cgImage: CGImageRef = CIContext(options: nil).createCGImage(image, fromRect: image.extent)
        UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale))
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetInterpolationQuality(context, CGInterpolationQuality.None)
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage)
        let scaledImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return gradePickerValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradePickerValues[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.view.endEditing(true)
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = gradePickerValues[row]
        pickerLabel.font = UIFont(name: "Avenir", size: 17) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    

}
