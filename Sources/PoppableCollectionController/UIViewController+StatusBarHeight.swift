//
//  UIViewController+StatusBarHeight.swift
//  PoppableCollectionController
//
//  Created by Garrett Jester on 1/14/21.
//

import UIKit

public extension UIViewController {
    
    var topBarHeight: CGFloat {
        if #available(iOS 13, *) {
           return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
               (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
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

