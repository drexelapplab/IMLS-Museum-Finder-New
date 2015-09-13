//
//  add_controller.swift
//  musuem_app
//
//  Created by Dagmawi on 8/9/15.
//  Copyright (c) 2015 Dagmawi. All rights reserved.
//

import UIKit
import CoreLocation


public var enteredLoc = ""
public var fromAdd = false





class add_controller: UIViewController,UIPickerViewDataSource , UIPickerViewDelegate{
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var locationField: UITextField!
    
    var numbers = [String]()
    var myInt = Int(10)
    
    
    
    @IBOutlet var upperNav: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inc : Double = 0.1
        var num : Double = 0
        
       
        while num < 9.9
        {
            num = num + inc
            numbers.append(String(stringInterpolationSegment: round(num*10)/10))
        }
        
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        self.pickerView.selectRow(9, inComponent: 0, animated: true)
        let reducedBy : CGFloat = 0.8
        
        self.pickerView.transform = CGAffineTransformMakeScale(reducedBy + 0.1, reducedBy)
        
//        let backItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
//        upperNav.leftBarButtonItem = backItem
    }
    
    
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count;
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return numbers[row]
    }
    
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        var myDouble = numberFormatter.numberFromString(numbers[row])!.doubleValue
         myInt = Int(myDouble * 10)
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    @IBAction func donePressed(sender: AnyObject) {
    
        
        if locationField.text != ""
        {
            fromAdd = true
            enteredLoc = locationField.text
            radius = myInt * 161
            
            self.dismissViewControllerAnimated(true, completion: nil)
       
        }else{
            
            myerror.title = "Error"
            myerror.message = "Please enter a valid location"
            myerror.addButtonWithTitle("OK")
            myerror.show()
        
        }
    }


    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
