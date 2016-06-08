//
//  SelectorView.swift
//  SelectionViewAnimation
//
//  Created by Dani Rangelov on 6/7/16.
//  Copyright © 2016 Dani Rangelov. All rights reserved.
//

import UIKit

enum ArrowPosition {
    case LeftSide
    case RightSide
}

enum ArrowDirection {
    case PointingRight
    case PointingLeft
}

protocol SelectorViewDelegate {
    /**
     Method caled on the delegate property if it is available to indicate that the value of the Selector has changed. 
     
     - Parameter selector: - it will carry the reference to the SelectorView that execuded the call.
     - Parameter selectedOption: - the value of the selectedOption after the change
     */
    func didChangeSelection(selector: SelectorView, selectedOption: ArrowDirection)
}

class SelectorView: UIView {
    
    var delegate: SelectorViewDelegate?
    
    var depthOfCut: CGFloat = 30.0
    var animationDuration = 0.3
    var lightGray = UIColor.darkGrayColor()
    var darkGray = UIColor.lightGrayColor()
    
    private var leftView = UIView()
    private var rightView = UIView()
    
    private var arrowDirection = ArrowDirection.PointingRight
    var currentArrowDirection: ArrowDirection  {
        get {
            return arrowDirection
        }
        set {
            if arrowDirection != newValue {
                arrowDirection = newValue
                switchArrowDirection(arrowDirection)
            }
        }
    }
    
    private var maskLayerLeft = CAShapeLayer()
    private var maskLayerRight = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        leftView.translatesAutoresizingMaskIntoConstraints = false
        rightView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftView)
        self.addSubview(rightView)
        
        setupConstraints()
        addGestures()
        
        let path = maskPath(leftView, position: .RightSide, direction: arrowDirection)
        leftView.backgroundColor = darkGray
        maskLayerLeft.path = path.CGPath
        leftView.layer.mask = maskLayerLeft
        
        let path2 = maskPath(rightView, position: .LeftSide, direction: arrowDirection)
        rightView.backgroundColor = lightGray
        maskLayerRight.path = path2.CGPath
        rightView.layer.mask = maskLayerRight
    }
    
    private func setupConstraints() {
        let views = ["leftView": leftView,
                     "rightView": rightView]
        
        var allConstraints = [NSLayoutConstraint]()
        
        let horizontalConstraintsLeft = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(0)-[leftView]",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += horizontalConstraintsLeft

        let distanceBetweenViews = NSLayoutConstraint(item: leftView, attribute: .Trailing, relatedBy: .Equal, toItem: rightView, attribute: .Leading, multiplier: 1, constant: depthOfCut)
        allConstraints += [distanceBetweenViews]
        
        let horizontalConstraintsRight = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[rightView(==leftView)]-(0)-|",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += horizontalConstraintsRight
        
        let leftViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(0)-[leftView]-(0)-|",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += leftViewVerticalConstraints
        
        let rightViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(0)-[rightView]-(0)-|",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += rightViewVerticalConstraints
        
        
        NSLayoutConstraint.activateConstraints(allConstraints)
    }
    
    private func addGestures() {
        let gestureLeftView = UITapGestureRecognizer(target: self, action: #selector(leftViewTouched(_:)))
        gestureLeftView.numberOfTapsRequired = 1
        leftView.addGestureRecognizer(gestureLeftView)
        
        let gestureRightView = UITapGestureRecognizer(target: self, action: #selector(rightViewTouched(_:)))
        gestureRightView.numberOfTapsRequired = 1
        rightView.addGestureRecognizer(gestureRightView)
    }
    
    private func maskPath(view:UIView, position: ArrowPosition, direction: ArrowDirection) -> UIBezierPath {
        let path = UIBezierPath()
        
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        
        switch position {
        case .LeftSide:
            switch direction {
            case .PointingLeft:
                path.moveToPoint(CGPoint(x: width, y: 0))
                path.addLineToPoint(CGPoint(x: depthOfCut/2, y: 0))
                path.addLineToPoint(CGPoint(x: 0, y: height/2))
                path.addLineToPoint(CGPoint(x: depthOfCut/2, y: height))
                path.addLineToPoint(CGPoint(x: width, y: height))
                path.addLineToPoint(CGPoint(x: width, y: 0))
                
            case .PointingRight:
                path.moveToPoint(CGPoint(x: width, y: 0))
                path.addLineToPoint(CGPoint(x: depthOfCut/2, y: 0))
                path.addLineToPoint(CGPoint(x: depthOfCut, y: height/2))
                path.addLineToPoint(CGPoint(x: depthOfCut/2, y: height))
                path.addLineToPoint(CGPoint(x: width, y: height))
                path.addLineToPoint(CGPoint(x: width, y: 0))
            }
            
        case .RightSide:
            switch direction {
            case .PointingLeft:
                path.moveToPoint(CGPoint(x: 0, y: 0))
                path.addLineToPoint(CGPoint(x: width - depthOfCut/2, y: 0))
                path.addLineToPoint(CGPoint(x: width - depthOfCut, y: height/2))
                path.addLineToPoint(CGPoint(x: width - depthOfCut/2, y: height))
                path.addLineToPoint(CGPoint(x: 0, y: height))
                path.addLineToPoint(CGPoint(x: 0, y: 0))
                
            case .PointingRight:
                path.moveToPoint(CGPoint(x: 0, y: 0))
                path.addLineToPoint(CGPoint(x: width - depthOfCut/2, y: 0))
                path.addLineToPoint(CGPoint(x: width, y: height/2))
                path.addLineToPoint(CGPoint(x: width - depthOfCut/2, y: height))
                path.addLineToPoint(CGPoint(x: 0, y: height))
                path.addLineToPoint(CGPoint(x: 0, y: 0))
            }
        }
        
        return path
    }
    
    private func switchArrowDirection(toDirection: ArrowDirection) {
        switch toDirection {
        case .PointingLeft:
            let oldPathL = maskPath(leftView, position: .RightSide, direction: .PointingRight)
            let newPathL = maskPath(leftView, position: .RightSide, direction: .PointingLeft)
            let animationLeftView = animationForPathTransition(oldPathL.CGPath, newPath: newPathL.CGPath)
            
            let oldPathR = maskPath(rightView, position: .LeftSide, direction: .PointingRight)
            let newPathR = maskPath(rightView, position: .LeftSide, direction: .PointingLeft)
            let animationRightView = animationForPathTransition(oldPathR.CGPath, newPath: newPathR.CGPath)
            
            maskLayerLeft.path = newPathL.CGPath
            maskLayerRight.path = newPathR.CGPath
            
            maskLayerLeft.addAnimation(animationLeftView, forKey: "LeftViewPathTransitionAnimation")
            maskLayerRight.addAnimation(animationRightView, forKey: "RightViewPathTransitionAnimation")
            
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { [weak self] in
                self?.leftView.backgroundColor = self?.darkGray
                self?.rightView.backgroundColor = self?.lightGray
                }, completion: nil)
            
        case .PointingRight:
            let oldPathL = maskPath(leftView, position: .RightSide, direction: .PointingLeft)
            let newPathL = maskPath(leftView, position: .RightSide, direction: .PointingRight)
            let animationLeftView = animationForPathTransition(oldPathL.CGPath, newPath: newPathL.CGPath)
            
            let oldPathR = maskPath(rightView, position: .LeftSide, direction: .PointingLeft)
            let newPathR = maskPath(rightView, position: .LeftSide, direction: .PointingRight)
            let animationRightView = animationForPathTransition(oldPathR.CGPath, newPath: newPathR.CGPath)
            
            maskLayerLeft.path = newPathL.CGPath
            maskLayerRight.path = newPathR.CGPath
            
            maskLayerLeft.addAnimation(animationLeftView, forKey: "LeftViewPathTransitionAnimation")
            maskLayerRight.addAnimation(animationRightView, forKey: "RightViewPathTransitionAnimation")
            
            UIView.animateWithDuration(animationDuration, delay: 0, options: .CurveEaseInOut, animations: { [weak self] in
                self?.leftView.backgroundColor = self?.lightGray
                self?.rightView.backgroundColor = self?.darkGray
                }, completion: nil)
            
        }
    }
    
    private func animationForPathTransition(oldPath: CGPath, newPath: CGPath) -> CABasicAnimation {
        let animationPath = CABasicAnimation(keyPath: "path")
        animationPath.duration = animationDuration
        animationPath.fromValue = oldPath
        animationPath.toValue = newPath
        animationPath.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animationPath.fillMode = kCAFillModeForwards
        animationPath.removedOnCompletion = false
        return animationPath
    }
    
    override func layoutSubviews() {
        leftView.setNeedsLayout()
        rightView.setNeedsLayout()
        
        leftView.layoutIfNeeded()
        rightView.layoutIfNeeded()
        
        switchArrowDirection(arrowDirection)
    }
    
    @IBAction func rightViewTouched(sender: AnyObject) {
        self.currentArrowDirection = .PointingLeft
        delegate?.didChangeSelection(self, selectedOption: self.currentArrowDirection)
    }
    
    @IBAction func leftViewTouched(sender: AnyObject) {
        self.currentArrowDirection = .PointingRight
        delegate?.didChangeSelection(self, selectedOption: self.currentArrowDirection)
    }

}
