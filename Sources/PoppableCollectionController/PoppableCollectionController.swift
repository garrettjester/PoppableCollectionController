//
//  File.swift
//  
//
//  Created by Garrett Jester on 1/12/21.
//

import UIKit

public protocol PoppableCollectionController {
    // The cell where the animation should originate.
    var sourceCell: UICollectionViewCell? {get}
    
    // The specific transition image to animate.
    var sourceImage: UIImage? {get}
    
    // The collectionView containing the cell.
    var collectionView: UICollectionView? {get}
    
    // The controller's view.
    var view: UIView! {get}
}

