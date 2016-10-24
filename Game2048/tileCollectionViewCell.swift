//
//  tileCollectionViewCell.swift
//  Game2048
//
//  Created by Hyperactive7 on 19/10/2016.
//  Copyright © 2016 TalPractice. All rights reserved.
//

import UIKit

class tileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    //@IBOutlet weak var board: UICollectionView!
    
    var tile: Tile? {
        didSet {
            reloadData()
        }
    }
    
    func reloadData() {
        if let number = tile?.number {
            numberLabel.text = number == 0 ? "" : "\(number)"
        }
        
//        //---------------------------------
//        // only for debug
//        if let index = tile?.index {
//            numberLabel.text = "\(index)"
//        }
//        //---------------------------------
        
        if let tc = tile?.textColor {
            numberLabel.textColor = tc
        }
        
        if let bc = tile?.backgroundColor {
            backgroundColor = bc
        }
        
        //board.reloadData()
    }
}
