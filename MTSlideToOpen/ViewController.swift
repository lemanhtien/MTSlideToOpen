//
//  ViewController.swift
//  MTSlideToOpen
//
//  Created by Martin Lee on 10/12/17.
//  Copyright © 2017 Martin Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let slideToOpen: MTSlideToOpenControl = {
        let slide = MTSlideToOpenControl(frame: CGRect(x: 50, y: 100, width: 250, height: 50))
        return slide
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(slideToOpen)
        slideToOpen.frame = CGRect(x: 26, y: 400, width: 317, height: 56)
        slideToOpen.sliderTopGap = 6
        slideToOpen.sliderCornerRadious = 22
        slideToOpen.canAutomaticResetState = true
    }
}

