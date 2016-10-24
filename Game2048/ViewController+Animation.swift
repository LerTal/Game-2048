//
//  ViewController+Animation.swift
//  Game2048
//
//  Created by Tal Lerman on 20/10/2016.
//  Copyright © 2016 TalPractice. All rights reserved.
//

import UIKit

extension ViewController {  //+Animation
    
    func createImageOfView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return viewImage!
    }
    
    private func imageOfCell(atIndex index: Int) -> UIImageView? {
        // get cell at index
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = board.cellForItem(at: indexPath) as? tileCollectionViewCell {
            // crate view with image
            let result = UIImageView(frame: cell.frame)
            result.image = createImageOfView(view: cell)
            result.layer.cornerRadius = 5
            return result
        }
        return nil
    }
    
    private func addMaskViewForCell(atIndex index: Int) -> UIImageView? {
        
        // create mask view
        if let mask: UIImageView = imageOfCell(atIndex: index) {
            
            // adding tag to mask view
            mask.tag = index+1
            
            // if need to add mask or that is already have mask
            let isUnionCell = tiles![index].isUnionCell                 // term- A- if union cell
            let existMaskView: UIView? = board.viewWithTag(index+1)     // term- B- if already have mask
            
            // adding mask if need
            if (existMaskView == nil) || (isUnionCell == false) {
                // adding mask view to board
                board.addSubview(mask)
            }
            
            // return mask view anyway (if added or not to board), mainly for get CGFrame
            return mask
        }
        return nil
    }
    
    /*private*/ func removeMaskViewForCell(atIndex index: Int) {
        if let mask = board?.viewWithTag(index+1) as? UIImageView {
            mask.removeFromSuperview()
        }
    }
    
    // MARK: Animation Functions
    
    func animateAppearingNewCell(atIndex index: Int) {
        // index path
        let indexPath = IndexPath(row: index, section: 0)
        
        // adding mask view
        _ = addMaskViewForCell(atIndex: index)
        
        // reload data
        board.reloadItems(at: [indexPath])
        
        // get cell
        let tileCell = board.cellForItem(at: indexPath) as? tileCollectionViewCell
        if (tileCell == nil) { return }
        
        // update cell fram
        tileCell!.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        // animate
        let delay = AnimationTimers.newCell_delay
        
        UIView.animate(withDuration: AnimationTimers.newCell_duration, delay: delay, options: [], animations: {
            
            // remove mask view after delay
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { _ in 
                    self.removeMaskViewForCell(atIndex: index)
                })
            } else {
                // Fallback on earlier versions
                
                Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(self.removeMaskViewForCell(atIndex:)), userInfo: nil, repeats: false)
            }
            
            // return scale to origin
            tileCell!.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
    }

    func animateCellMove(fromIndex: Int, toIndex: Int) {
        
        // adding mask calls to board
        let maskStart: UIImageView? = addMaskViewForCell(atIndex: fromIndex)
        maskStart?.layer.zPosition = 10
        let maskEnd: UIImageView? = addMaskViewForCell(atIndex: toIndex)
        maskEnd?.layer.zPosition = 9
        if (maskStart == nil) || (maskEnd == nil) { return }
        
        // get indexes
        let indexStart = IndexPath(row: fromIndex, section: 0)
        let indexEnd = IndexPath(row: toIndex, section: 0)
        
        // update data of board/cells
        board.reloadItems(at: [indexStart, indexEnd])
        
        // animation
        UIView.animate(withDuration: AnimationTimers.cellMove_duration, animations: {
            
            // option A
            maskStart?.frame = (maskEnd?.frame)!
            // option B
            //let translationX =  maskEnd!.frame.origin.x - maskStart!.frame.origin.x
            //let translationY =  maskEnd!.frame.origin.y - maskStart!.frame.origin.y
            //maskStart!.transform = CGAffineTransform(translationX: translationX, y: translationY)
            
            }, completion: { _ in
                self.removeMaskViewForCell(atIndex: fromIndex)
                self.removeMaskViewForCell(atIndex: toIndex)
                
                //animate the apperance of new cell with the sum of tow
                self.animateAppearingNewSumCell(atIndex: toIndex)
        })
        
    }
    
    func animateAppearingNewSumCell(atIndex index: Int) {
        // index path
        let indexPath = IndexPath(row: index, section: 0)
        
        // check if need to animate (if union of two ather cells)
        if let tile = tiles?[index] as Tile? {
            if tile.isUnionCell == false { return }
        }
        
        // get cell
        if let tileCell = board.cellForItem(at: indexPath) as? tileCollectionViewCell {
            
            // animation
            UIView.animateKeyframes(withDuration: AnimationTimers.newSumCell_duration, delay: AnimationTimers.newSumCell_delay, options: [], animations: {
                // first animation part, grow
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                    let scale: CGFloat = 1.15
                    tileCell.transform = CGAffineTransform(scaleX: scale, y: scale)
                })
                // second animation part, shrink
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 1.0, animations: {
                    let scale: CGFloat = 1
                    tileCell.transform = CGAffineTransform(scaleX: scale, y: scale)
                })
                }, completion: nil)
        }
    }
    
    
    // MARK: Old, not used
    
    func blabla1() {
        
        //board.reloadData()
        
        let cells = board.visibleCells
        
        let boardHeight: CGFloat = board.bounds.size.height
        
        for i in cells {
            let cell: tileCollectionViewCell = i as! tileCollectionViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: boardHeight)
        }
        
        var index = 0
        for i in cells {
            let cell: tileCollectionViewCell = i as! tileCollectionViewCell
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
            
            index += 1
        }
    }
}

private struct AnimationTimers {
    
    static let newCell_duration: TimeInterval = 0.4     //0.5
    static var newCell_delay: TimeInterval {
        get {
            return cellMove_duration
        }
    }
    
    static let cellMove_duration: TimeInterval = 0.5    //1.0
    static let cellMove_delay: TimeInterval = 0
    
    static let newSumCell_duration: TimeInterval = 0.4  //0.8
    static let newSumCell_delay: TimeInterval = 0
    
}










