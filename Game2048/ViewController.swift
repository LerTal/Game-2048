//
//  ViewController.swift
//  Game2048
//
//  Created by Hyperactive7 on 19/10/2016.
//  Copyright © 2016 TalPractice. All rights reserved.
//

import UIKit

//private let boxHeight = 4
private let boxWidth = 4
private let cellsNumber = boxWidth * boxWidth
private let cellId = "CellId"

enum Direction {
    case right
    case left
    case up
    case down
}

class ViewController: UIViewController {

    @IBOutlet weak var board: UICollectionView!
    
    var tiles: [Tile]?
    
    var leftSwip: UISwipeGestureRecognizer?
    var rightSwip: UISwipeGestureRecognizer?
    var upSwip: UISwipeGestureRecognizer?
    var downSwip: UISwipeGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gesturesInitial()
        
        // create data, tiles list
        tiles = [Tile]()
        for i in 0..<cellsNumber {
            let tempTile = Tile(index: i, isUnionCell: false, number: 0)
            tiles?.append(tempTile)
        }
        
        // adding tow start tiles
        for _ in 0..<2 {
            self.addingNewNumberForEmptyTile(withAnimation: false)
        }
        
        // refresh view
        board.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Helpers
    
    func generateNewTileNumber() -> Int { // return 2 (98%) or 4 (2%)
        let random: Int = Int(arc4random_uniform(UInt32(100)))
        let result: Int = (random == 10 || random == 20) ? 4 : 2
        return result
    }
    
    func emptyTile() -> [Tile] {
        var emptyTiles = [Tile]()
        for t in tiles! {
            if t.number == 0 {
                emptyTiles.append(t)
            }
        }
        return emptyTiles
    }
    
    func addingNewNumberForEmptyTile(withAnimation toAnimate: Bool) {
        let freeTiles = emptyTile()
        if freeTiles.count > 0
        {
            // randon index for empty cells sub list
            let index = Int(arc4random_uniform(UInt32(freeTiles.count)))
            
            // get cell and update content
            let tileToUpdate: Tile = freeTiles[index]
            tiles![tileToUpdate.index].number = generateNewTileNumber()
            
            // animating his appearance
            if toAnimate == true { animateAppearingNewCell(atIndex: tileToUpdate.index) }
        }
    }
    
    // MARK: Move
    
    func nextIndex(_ index: Int, direction: Direction) -> Int? {
        
        let min = 0, max = cellsNumber-1
        var newIndex: Int?
        
        switch direction {
        case .left:
            newIndex = index - 1
            let div = boxWidth
            newIndex = (index/div == newIndex!/div) ? newIndex : nil
        case .right:
            newIndex = index + 1
            let div = boxWidth
            newIndex = (index/div == newIndex!/div) ? newIndex : nil
        case .up:
            newIndex = index - boxWidth
        case .down:
            newIndex = index + boxWidth
        }
        
        if newIndex == nil { return newIndex }
        newIndex = (newIndex! >= min) && (newIndex! <= max) ? newIndex : nil
        return newIndex
    }
    
    func farthestEmptyIndexCell(_ index: Int, direction: Direction) -> Int {
        
        // -A-
        var indexFarthestEmptyCell = index
        var newIndex: Int? = nextIndex(index, direction: direction)
        
        // -B-
        while (newIndex != nil) && (tiles?[newIndex!].number == 0) {
            indexFarthestEmptyCell = newIndex!
            newIndex = nextIndex(indexFarthestEmptyCell, direction: direction)
        }
        
        // -C-
        return indexFarthestEmptyCell
    }
    
    func cellAtIndex(_ index: Int, withNumber number: Int, canBeUnionWithNextCellAtDirection direction: Direction) -> Bool {
        
        // indexs
        //let currentIndex = index
        let nextIndexCell: Int? = nextIndex(index, direction: direction)
        if (nextIndexCell == nil) { return false }
        
        // cells
        //let currentCell = tiles?[currentIndex]
        let nextCell = tiles?[nextIndexCell!]
        
        // checking move
        let canBeUnion = ((number == nextCell!.number) && !(nextCell!.isUnionCell)) ? true : false
        
        return canBeUnion
    }
    
    func destinaionIndexForCell(_ index: Int, direction: Direction) -> Int {
        
        // 1- move to the farthest empty cell
        var indexFarthestEmptyCell = farthestEmptyIndexCell(index, direction: direction)
        
        // 2- check if poisble to union with the next cell (include that it not doing union already)
        let numberOfCurrentCell = tiles?[index].number
        let canBeUnion = cellAtIndex(indexFarthestEmptyCell, withNumber: numberOfCurrentCell!, canBeUnionWithNextCellAtDirection: direction)
        
        // 3- update the index farthest empty cell if necessary
        if canBeUnion {
            indexFarthestEmptyCell = nextIndex(indexFarthestEmptyCell, direction: direction)!
        }
        
        // 4- return result
        return indexFarthestEmptyCell
    }
    
    func movingAllCellTo(_ direction: Direction) -> Bool {
        // get list of index to run on
        let indexOrderList = indexesOrderforDirection(direction: direction)
        
        var isLegalMove = false
        
        for index in indexOrderList {
            // get destinaion cell index
            let destinaionIndexCell = destinaionIndexForCell(index, direction: direction)
            
            // update cells
            if (index != destinaionIndexCell) && (tiles![index].number != 0) {
                
                // update tiles data list
                let unionStatus = (tiles![destinaionIndexCell].number != 0) ? true : false
                tiles![destinaionIndexCell].isUnionCell = unionStatus
                tiles![destinaionIndexCell].number += (tiles?[index].number)!
                tiles![index].number = 0
                
                // animate
                animateCellMove(fromIndex: index, toIndex: destinaionIndexCell)
                
                // update legal status
                isLegalMove = true
            }
        }
        return isLegalMove
    }
    
    func isEndGame() -> Bool {
        
        // 1- no empty cell left
        for tile in tiles! {
            if (tile.number == 0) { return false }
        }
        
        // 2- all cells are black by athers
        // if fareast cell is not myself, for all direcsions
        for tile in tiles! {
            if (destinaionIndexForCell(tile.index, direction: .down) != tile.index) { return false }
            if (destinaionIndexForCell(tile.index, direction: .left) != tile.index) { return false }
            if (destinaionIndexForCell(tile.index, direction: .right) != tile.index) { return false }
            if (destinaionIndexForCell(tile.index, direction: .up) != tile.index) { return false }
        }
        
        return true
    }
    
    func resetAllCellsToNonunion() {
        for tile in tiles! {
            tiles?[tile.index].isUnionCell = false
        }
    }
    
    // MARK: Indexes Order Search
    
    func indexesOrderforDirection(direction: Direction) -> [Int] {
        var indexesOrder = [Int]()
        
        switch direction {
        case .left:
            indexesOrder = indexesLeftOrder()
        case .right:
            indexesOrder = indexesRightOrder()
        case .up:
            indexesOrder = indexesUpOrder()
        case .down:
            indexesOrder = indexesDownOrder()
        }
        
        // maybe update this line with boxWidth/boxHieght ???
        var result = indexesOrder
        for _ in 0..<4 { result.remove(at: 0) }
        return result
    }
    
    func indexesLeftOrder() -> [Int] {
        let max = cellsNumber-1
        var indexesOrder = [Int]()
        
        var tempIndex = 0
        for _ in 0..<cellsNumber {
            // adding to index order list
            indexesOrder.append(tempIndex)
            
            // update index
            var nextIndex = tempIndex + boxWidth
            nextIndex -= (nextIndex > max) ? max : 0
            tempIndex = nextIndex
        }
        
        return indexesOrder
    }
    func indexesRightOrder() -> [Int] {
        let max = cellsNumber-1
        var indexesOrder = [Int]()
        
        var tempIndex = boxWidth-1
        for _ in 0..<cellsNumber {
            // adding to index order list
            indexesOrder.append(tempIndex)
            
            // update index
            var nextIndex = tempIndex + boxWidth
            nextIndex -= (nextIndex > max) ? max+2 : 0
            tempIndex = nextIndex
        }
        
        return indexesOrder
    }
    func indexesUpOrder() -> [Int] {
        var indexesOrder = [Int]()
        
        var tempIndex = 0
        for _ in 0..<cellsNumber {
            // adding to index order list
            indexesOrder.append(tempIndex)
            
            // update index
            tempIndex += 1
        }
        
        return indexesOrder
    }
    func indexesDownOrder() -> [Int] {
        var indexesOrder = [Int]()
        
        var tempIndex = cellsNumber-1
        for _ in 0..<cellsNumber {
            // adding to index order list
            indexesOrder.append(tempIndex)
            
            // update index
            tempIndex -= 1
        }
        
        return indexesOrder
    }
    
    // MARK: Gestures
    
    func gesturesInitial() {
        
        leftSwip = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.leftSwipAction))
        leftSwip!.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwip!)
        
        rightSwip = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.rightSwipAction))
        rightSwip!.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwip!)
        
        upSwip = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.upSwipAction))
        upSwip!.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(upSwip!)
        
        downSwip = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.downSwipAction))
        downSwip!.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(downSwip!)
    }
    
    func gameOverAction() {
        
        print("*******************")
        print("***  Game Over  ***")
        print("*******************")
        
        let alert = UIAlertController(title: "Game Over", message: "Score: ...", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: { action in
            // reset data tiles list
            for i in 0..<cellsNumber {
                self.tiles![i].number = 0
            }
            // adding tow start tiles
            for _ in 0..<2 {
                self.addingNewNumberForEmptyTile(withAnimation: false)
            }
            // refresh view
            self.board.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func gameOverCheckAndAction() {
        
        if isEndGame() {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameOverAction), userInfo: nil, repeats: false)
        }

    }
    
    func swipAction(withDirection direction: Direction) {
        // reset all cell to nonunion
        resetAllCellsToNonunion()
        
        // make move
        if movingAllCellTo(direction) {
            
            // adding new number for empty tile
            addingNewNumberForEmptyTile(withAnimation: true)
        }
        
        // check game over
        gameOverCheckAndAction()
    }
    
    func leftSwipAction() {
        print("left swip")
        
        swipAction(withDirection: .left)
    }
    func rightSwipAction() {
        print("right swip")
        
        swipAction(withDirection: .right)
    }
    func upSwipAction() {
        print("up swip")
        
        swipAction(withDirection: .up)
    }
    func downSwipAction() {
        print("down swip")
        
        swipAction(withDirection: .down)
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    private func collectionView(_ collectionView: UICollectionView, willDisplay cell: tileCollectionViewCell, forItemAt indexPath: IndexPath) {
            //
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = board.bounds.width/5.0
        let cellHeight = board.bounds.height/5.0
        let size = CGSize(width: cellWidth, height: cellHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let singleDistance: CGFloat = distanceBetweenCells()
        return UIEdgeInsets(top: singleDistance, left: singleDistance, bottom: singleDistance, right: singleDistance)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return distanceBetweenCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return distanceBetweenCells()
    }
    
    func distanceBetweenCells() -> CGFloat {
        let distanceBetweenCells = board.bounds.width/5.0
        let singleDistance: CGFloat = distanceBetweenCells/5.0
        return singleDistance
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! tileCollectionViewCell
        
        if let t = tiles?[(indexPath as NSIndexPath).row] {
            cell.tile = t
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsNumber
    }
    
}

extension ViewController {  //Tests
    
    func testNextIndex() -> Bool {
        
        let indexes = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        let answersDown: [Int?] = [4,5,6,7,8,9,10,11,12,13,14,15,nil,nil,nil,nil]
        let answersUp: [Int?] = [nil,nil,nil,nil,0,1,2,3,4,5,6,7,8,9,10,11]
        let answersRight: [Int?] = [1,2,3,nil,5,6,7,nil,9,10,11,nil,13,14,15,nil]
        let answersLeft: [Int?] = [nil,0,1,2,nil,4,5,6,nil,8,9,10,nil,12,13,14]
        
        var direction: Direction
        
        direction = .down
        for i in 0..<indexes.count {
            if (nextIndex(indexes[i], direction:direction) != answersDown[i]) { return false }
        }
        
        direction = .up
        for i in 0..<indexes.count {
            if (nextIndex(indexes[i], direction:direction) != answersUp[i]) { return false }
        }
        
        direction = .right
        for i in 0..<indexes.count {
            if (nextIndex(indexes[i], direction:direction) != answersRight[i]) { return false }
        }
        
        direction = .left
        for i in 0..<indexes.count {
            if (nextIndex(indexes[i], direction:direction) != answersLeft[i]) { return false }
        }
        
        return true
    }
}











