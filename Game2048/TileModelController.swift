//
//  TileModelController.swift
//  Game2048
//
//  Created by Hyperactive7 on 19/10/2016.
//  Copyright © 2016 TalPractice. All rights reserved.
//

import Foundation

struct TileModelController {
//    var tiles: [Tile]? = tilesInitial()
    
    func tilesInitial() -> [Tile] {
        var tempTiles = [Tile]()
        for i in 0..<16 {
            let tile = Tile(index: i, isUnionCell: false, number: 0)
            tempTiles.append(tile)
        }
        return tempTiles
    }
}