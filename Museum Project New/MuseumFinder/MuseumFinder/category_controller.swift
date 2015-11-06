//
//  category_controller.swift
//  musuem_app
//
//  Created by Dagmawi on 8/23/15.
//  Copyright (c) 2015 Dagmawi. All rights reserved.
//

import UIKit

// MARK: Globals
public var catString = ""
public var musCatArray: Array<String> = []
public var fromCat = false

class category_controller: UIViewController {
    
    // MARK: Properties
    
    //cretaes an array for the switches
    var buttonsExAll = [UISwitch]()
    
    //creates an array for the switch names
    var buttonnamesExAll = [String]()
    
    //bool for use later on
    var isFirst = Bool()
    
    // MARK: IBOutlets
    
    // links up all the switches
    @IBOutlet var art: UISwitch!
    @IBOutlet var bot: UISwitch!
    @IBOutlet var cmu: UISwitch!
    @IBOutlet var gmu: UISwitch!
    @IBOutlet var hsc: UISwitch!
    @IBOutlet var hst: UISwitch!
    @IBOutlet var nat: UISwitch!
    @IBOutlet var sci: UISwitch!
    @IBOutlet var zaw: UISwitch!
    
    //links the buttons
    @IBOutlet var dsAll: UIButton!
    @IBOutlet var selAll: UIButton!
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //add the switches to the array
        buttonsExAll.append(art)
        buttonsExAll.append(bot)
        buttonsExAll.append(cmu)
        buttonsExAll.append(gmu)
        buttonsExAll.append(hsc)
        buttonsExAll.append(hst)
        buttonsExAll.append(nat)
        buttonsExAll.append(sci)
        buttonsExAll.append(zaw)
        
        //add the names to the name array
        buttonnamesExAll.append("art")
        buttonnamesExAll.append("bot")
        buttonnamesExAll.append("cmu")
        buttonnamesExAll.append("gmu")
        buttonnamesExAll.append("hsc")
        buttonnamesExAll.append("hst")
        buttonnamesExAll.append("nat")
        buttonnamesExAll.append("sci")
        buttonnamesExAll.append("zaw")
        
        
        // if this isnot the first time loading or if there has been a categories filter before then check all the preferred switches
        if musCatArray.count != 0 {
            
            for b in 0...buttonnamesExAll.count-1
            {
                buttonsExAll[b].on = false
                
                
                for a in 0...musCatArray.count-1
                {
                    
                    if musCatArray[a] == buttonnamesExAll[b]
                    {
                        buttonsExAll[b].on = true
                    }
                }
            }
        }else{
            //if not then check all the switches
            selectAllPresses(self)
        }
        
        //resize all the switches
        //find a way to do this non-progrmatically
        resizeSwitches()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions
    
    //method that resizes all the switches
    func resizeSwitches(){
        
        let reducedBy : CGFloat = 0.65
        
        for switches in  0...buttonsExAll.count-1 {
            buttonsExAll[switches].transform = CGAffineTransformMakeScale(reducedBy, reducedBy)
        }
    }
    
    
    // MARK: IBActions
    
    //checks all the switches
    @IBAction func selectAllPresses(sender: AnyObject) {
        
        for index in 0...buttonsExAll.count-1
        {
            buttonsExAll[index].setOn(true, animated: true)
        }
    }
    
    //unchecks all the switches
    @IBAction func deselectAllPressed(sender: AnyObject) {
        
        for index in 0...buttonsExAll.count-1
        {
            buttonsExAll[index].setOn(false, animated: true)
        }
    }
    
    //back button pressed
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //if done pressed
    @IBAction func donePressed(sender: AnyObject) {
        
        //set up an emty string, remove all the old stuff from the array and set the first bool to true
        catString = ""
        musCatArray.removeAll(keepCapacity: false)
        isFirst = true
        
        
        
        // for every switch check if it is checked, if it is add the name of the discipl to the string
        for index in 0...buttonsExAll.count-1
        {
            if buttonsExAll[index].on == true
            {
                musCatArray.append(buttonnamesExAll[index])
                
                //if it is tje first  switch the dont add the OR extension
                if !isFirst{
                    catString = catString + "OR "
                }
                
                catString = catString + "discipl='\(buttonnamesExAll[index].uppercaseString)'"
                isFirst = false
            }
            
        }
        
        //put the string inside  parentheses
        if musCatArray.count != 0
            
        {
            catString = "AND(\(catString))"
        }
        
        print(catString)
        
        //sets the from categories bool to true and dismisses the view controller
        fromCat = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Protocols

}
