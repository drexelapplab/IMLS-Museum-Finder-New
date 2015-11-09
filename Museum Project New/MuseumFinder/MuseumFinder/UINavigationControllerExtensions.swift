//
//  UINavigationControllerExtensions.swift
//  MuseumFinder
//
//  Created by AJ Beckner on 11/9/15.
//  Copyright © 2015 IMLS. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return visibleViewController!.supportedInterfaceOrientations()
    }
}