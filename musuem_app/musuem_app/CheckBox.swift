//
//  CheckBox.swift
//  musuem_app
//
//  Created by Dagmawi on 8/24/15.
//  Copyright (c) 2015 Dagmawi. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    

    //images
    let checkedImage = UIImage(named: "checked_checkbox.png") as UIImage?
    let unCheckedImage = UIImage(named: "unChecked_checkbox.png") as UIImage?
    
    
    //bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            }
            else{
                self.setImage(unCheckedImage, forState: .Normal)
            }
        }
    }
    
    
    override func awakeFromNib(){
    self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    self.isChecked = false
    }
    
    
    func buttonClicked(sender : UIButton){
        if sender == self{
            if isChecked {
                isChecked = false
            }else{
                isChecked = true
            }
        }
    }
}
