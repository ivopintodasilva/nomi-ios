//
//  ProfileCreateViewController.swift
//  nomi
//
//  Created by Silva on 1/3/16.
//  Copyright © 2016 Ivo Silva. All rights reserved.
//

import UIKit

class ProfileCreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var color_picker: UIPickerView!
    
    var pickerLabel = UILabel()
    
    let colors = [
        "BLACK",
        "BLUE",
        "GREEN",
        "RED",
        "WHITE"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        color_picker.dataSource = self
        color_picker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // items count
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return colors.count
    }
    
    // item name
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    // after select picker item
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){

    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = colors[row]
        pickerLabel.font = UIFont(name: "Avenir", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
