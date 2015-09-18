//
//  help_controller.swift
//  musuem_app
//
//  Created by Dagmawi on 8/9/15.
//  Copyright (c) 2015 Dagmawi. All rights reserved.
//

import UIKit

class help_controller: UIViewController {
    
    @IBOutlet var nav: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    
    
    //dimisses the controller if the back button is pressed
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
