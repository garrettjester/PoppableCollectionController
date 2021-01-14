//
//  UIViewController+StatusBarHeight.swift
//  PoppableCollectionController
//
//  Created by Garrett Jester on 1/14/21.
//

import UIKit

public extension UIViewController {
    
    public var statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            statusBarHeight = self.view.safeAreaInsets.top
            let hardwareInset = self.view.safeAreaInsets.bottom > CGFloat.ulpOfOne && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
            if statusBarHidden && !hardwareInset {
                statusBarHeight = 0.0
            }
        } else {
            if statusBarHidden { statusBarHeight = 0.0 }
            else { statusBarHeight = self.topLayoutGuide.length }
        }
        return statusBarHeight
    }
    
    
    private var statusBarHidden: Bool {
        // Defer behaviour to the hosting navigation controller
        if ((self.navigationController) != nil) {
            return self.navigationController!.prefersStatusBarHidden
        }
        
        //If our presenting controller has already hidden the status bar,
        //hide the status bar by default
        if self.presentingViewController!.prefersStatusBarHidden {
            return true
        }
        
        // Our default behaviour is to always hide the status bar
        return true
    }
}

