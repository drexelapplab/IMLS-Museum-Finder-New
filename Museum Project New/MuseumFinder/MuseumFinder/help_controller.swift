//
//  help_controller.swift
//  musuem_app
//
//  Created by Dagmawi on 8/9/15.
//  Copyright (c) 2015 Dagmawi. All rights reserved.
//

import UIKit

class help_controller: UIViewController {
    
    // MARK: Properties
    // MARK: IBOutlets
    @IBOutlet var nav: UINavigationItem! //TODO: Removeable?

    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Add helptext here in textview
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: IBActions
    
    
    /**
    
    Dimisses the controller if the back button is pressed
    
    - Parameter sender: the object that sent the message, a UIButton
    
    */
    @IBAction func backPressed(sender: AnyObject) { //TODO: Removeable?
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Functions
    
    // put other functions here
    
    
    // MARK: - Protocols
    
    // put any protocol methods here and mark each
    // different set of protocols before it's methods

}
