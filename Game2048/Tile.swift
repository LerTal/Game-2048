//
//  Tile.swift
//  Game2048
//
//  Created by Hyperactive7 on 19/10/2016.
//  Copyright © 2016 TalPractice. All rights reserved.
//

import UIKit

struct Tile {
    var index: Int  //change only in initial
    var isUnionCell: Bool
    var number: Int
    var backgroundColor: UIColor {
        get {
            return pGetBackgroundColor() //getBackgroundColor(tileColor)
        }
    }
    var textColor: UIColor {
        get {
            return pGgetTextColor() //getTextColor(tileColor)
        }
    }
    
    func pGetBackgroundColor() -> UIColor {
        var result: UIColor!
        
        if number == 0 { result = UIColor(netHex: 0xccc0b4) }
        else if number == 2 { result = UIColor(netHex: 0xede4da) }
        else if number == 4 { result = UIColor(netHex: 0xebdec7) }
        else if number == 8 { result = UIColor(netHex: 0xf0ae78) }
        else if number == 16 { result = UIColor(netHex: 0xf59564) }
        else if number == 32 { result = UIColor(netHex: 0xf57b5f) }
        else if number == 64 { result = UIColor(netHex: 0xf55d3b) }
        else if number == 128 { result = UIColor(netHex: 0xebcd73) }
        else if number == 256 { result = UIColor(netHex: 0xebc860) }
        else if number == 512 { result = UIColor(netHex: 0xffffff) }
        else if number == 1024 { result = UIColor(netHex: 0xffffff) }
        else if number == 2048 { result = UIColor(netHex: 0xffffff) }
        else if number == 4096 { result = UIColor(netHex: 0xffffff) }
        else if number == 8192 { result = UIColor(netHex: 0xffffff) }
        
        return result
    }
    
    func pGgetTextColor() -> UIColor {
        var result: UIColor!
        
        if number == 0 { result = UIColor(netHex: 0x776e65) }
        else if number == 2 { result = UIColor(netHex: 0x756d64) }
        else if number == 4 { result = UIColor(netHex: 0x756d64) }
        else if number == 8 { result = UIColor(netHex: 0xf7f5f2) }
        else if number == 16 { result = UIColor(netHex: 0xf7f5f2) }
        else if number == 32 { result = UIColor(netHex: 0xf7f5f2) }
        else if number == 64 { result = UIColor(netHex: 0xf7f5f2) }
        else if number == 128 { result = UIColor(netHex: 0xf7f5f2) }
        else if number == 256 { result = UIColor(netHex: 0xf7f5f2) }
        else if number == 512 { result = UIColor(netHex: 0xffffff) }
        else if number == 1024 { result = UIColor(netHex: 0xffffff) }
        else if number == 2048 { result = UIColor(netHex: 0xffffff) }
        else if number == 4096 { result = UIColor(netHex: 0xffffff) }
        else if number == 8192 { result = UIColor(netHex: 0xffffff) }
        
        return result
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


/*
 
            text    backround   text        backround
 
 empty              ccc0b4      0x          0xccc0b4
 2          756d64  ede4da      0x756d64	0xede4da
 4          756d64  ebdec7      0x756d64	0xebdec7
 8          f7f5f2  f0ae78      0xf7f5f2	0xf0ae78
 16         f7f5f2  f59564      0xf7f5f2	0xf59564
 32         f7f5f2  f57b5f      0xf7f5f2	0xf57b5f
 64         f7f5f2  f55d3b      0xf7f5f2	0xf55d3b
 128        f7f5f2  ebcd73      0xf7f5f2	0xebcd73
 256        f7f5f2  ebc860      0xf7f5f2	0xebc860
 512                            0x          0x
 1024                           0x          0x
 2048                           0x          0x
 
 
 board          baaca0	0xbaaca0
 background     faf8f0	0xfaf8f0
 
*/
