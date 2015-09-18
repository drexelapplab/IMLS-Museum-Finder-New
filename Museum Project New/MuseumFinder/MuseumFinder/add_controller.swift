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





class add_controller: UIViewController{

    @IBOutlet var locationField: UITextField!
    @IBOutlet var upperNav: UINavigationItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    //when the user clicks on the done button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    
    //if the user clicks on the back button
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    //if done is clicked
    @IBAction func donePressed(sender: AnyObject) {
    
        //check whether the location field is empty
        if locationField.text != ""
        {
            //set the from add screen bool to true
            fromAdd = true
            
            //sets the string to the value from the text field
            enteredLoc = locationField.text!
            
            //dismiss the view controller
            self.dismissViewControllerAnimated(true, completion: nil)
       
            
        }else{
            
            // if the field is empty
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
