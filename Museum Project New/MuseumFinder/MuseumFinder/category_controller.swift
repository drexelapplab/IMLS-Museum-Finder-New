//
//  category_controller.swift
//  musuem_app
//
//  Created by Dagmawi on 8/23/15.
//  Copyright (c) 2015 Dagmawi. All rights reserved.
//

import UIKit
public var catString = ""
public var musCatArray: Array<String> = []
public var fromCat = false

class category_controller: UIViewController {
    
    
    
   
    
    
    @IBOutlet var nav: UINavigationItem!
    
    @IBOutlet var art: UISwitch!
    @IBOutlet var bot: UISwitch!
    @IBOutlet var cmu: UISwitch!
    @IBOutlet var gmu: UISwitch!
    @IBOutlet var hsc: UISwitch!
    @IBOutlet var hst: UISwitch!
    @IBOutlet var nat: UISwitch!
    @IBOutlet var sci: UISwitch!
    @IBOutlet var zaw: UISwitch!
    
    @IBOutlet var dsAll: UIButton!
    @IBOutlet var selAll: UIButton!
    
    var buttonsExAll = [UISwitch]()
    var buttonnamesExAll = [String]()
    var isFirst = Bool()
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let backItem = UIBarButtonItem(title: "Custom", style: .Plain, target: nil, action: nil)
        nav.backBarButtonItem = backItem
        
        
            buttonsExAll.append(art)
            buttonsExAll.append(bot)
            buttonsExAll.append(cmu)
            buttonsExAll.append(gmu)
            buttonsExAll.append(hsc)
            buttonsExAll.append(hst)
            buttonsExAll.append(nat)
            buttonsExAll.append(sci)
            buttonsExAll.append(zaw)
            
            buttonnamesExAll.append("art")
            buttonnamesExAll.append("bot")
            buttonnamesExAll.append("cmu")
            buttonnamesExAll.append("gmu")
            buttonnamesExAll.append("hsc")
            buttonnamesExAll.append("hst")
            buttonnamesExAll.append("nat")
            buttonnamesExAll.append("sci")
            buttonnamesExAll.append("zaw")
        
        
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
        
        selectAllPresses(self)
        }
        resizeSwitches()
    }
    
    

    
    
    func resizeSwitches(){
        
        let reducedBy : CGFloat = 0.65
    
        
        for switches in  0...buttonsExAll.count-1 {
            buttonsExAll[switches].transform = CGAffineTransformMakeScale(reducedBy, reducedBy)
        }
    
    
    }
    
    
    
    @IBAction func selectAllPresses(sender: AnyObject) {
        
        for index in 0...buttonsExAll.count-1
        {
            buttonsExAll[index].setOn(true, animated: true)
        }
    }
    
    
    
    @IBAction func deselectAllPressed(sender: AnyObject) {
        
        for index in 0...buttonsExAll.count-1
        {
            buttonsExAll[index].setOn(false, animated: true)
        }
    }
    
    
    
    
    
    
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
    @IBAction func donePressed(sender: AnyObject) {
       
        catString = ""
        musCatArray.removeAll(keepCapacity: false)
        isFirst = true
        
        
        
        
        for index in 0...buttonsExAll.count-1
        {
            if buttonsExAll[index].on == true
            {
                musCatArray.append(buttonnamesExAll[index])
                
                
                if !isFirst{
                    catString = catString + "OR "
                }
                
                catString = catString + "discipl='\(buttonnamesExAll[index].uppercaseString)'"
                isFirst = false
            }
            
        }
        
        
        
        if musCatArray.count != 0
            
        {
            catString = "AND(\(catString))"
        }
        
        
        
        print(catString)
        
        fromCat = true
        self.dismissViewControllerAnimated(true, completion: nil)  
    }
    
    
    
    
    
    
    
    
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
