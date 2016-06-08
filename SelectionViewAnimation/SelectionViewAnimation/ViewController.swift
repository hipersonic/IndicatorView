//
//  ViewController.swift
//  SelectionViewAnimation
//
//  Created by Dani Rangelov on 6/7/16.
//  Copyright © 2016 Dani Rangelov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SelectorViewDelegate {
    
    @IBOutlet weak var selectorView: SelectorView!
    
    override func viewDidLoad() {
        selectorView.delegate = self
        selectorView.currentArrowDirection = ArrowDirection.PointingLeft
    }
    
    func didChangeSelection(selector: SelectorView, selectedOption: ArrowDirection) {
        switch selectedOption {
        case .PointingLeft:
            print("Right View Touched")
        case .PointingRight:
            print("Left View Touched")
        
        }
    }
}