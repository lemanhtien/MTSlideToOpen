//
//  ViewController.swift
//  MTSlideToOpen
//
//  Created by Martin Lee on 10/12/17.
//  Copyright © 2017 Martin Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MTSlideToOpenDelegate {
    lazy var slideToOpen: MTSlideToOpenView = {
        let slide = MTSlideToOpenView(frame: CGRect(x: 26, y: 100, width: 317, height: 56))
        slide.sliderViewTopDistance = 0
        slide.sliderCornerRadious = 28
        slide.thumnailImageView.backgroundColor = .red
        slide.draggedView.backgroundColor = UIColor(red:141.0/255, green:19.0/255, blue:65.0/255, alpha:1.0)
        slide.delegate = self
        slide.thumnailImageView.image = #imageLiteral(resourceName: "ic_arrow")
        return slide
    }()
    lazy var slideToLock: MTSlideToOpenView = {
        let slide = MTSlideToOpenView(frame: CGRect(x: 26, y: 200, width: 317, height: 56))
        slide.sliderViewTopDistance = 0
        slide.sliderCornerRadious = 28
        slide.thumnailImageView.backgroundColor  = UIColor(red:200.0/255, green:200.0/255, blue:200.0/255, alpha:1.0)
        slide.draggedView.backgroundColor = UIColor(red:200.0/255, green:200.0/255, blue:200.0/255, alpha:1.0)
        slide.delegate = self
        slide.thumbnailViewLeadingDistance = 20
        slide.defaultLabelText = "Slide To Lock"
        slide.thumnailImageView.image = #imageLiteral(resourceName: "ic_arrow")
        return slide
    }()
    lazy var slideToUnlock: MTSlideToOpenView = {
        let slide = MTSlideToOpenView(frame: CGRect(x: 26, y: 400, width: 317, height: 56))
        slide.sliderViewTopDistance = 6
        slide.sliderCornerRadious = 22
        slide.delegate = self
        slide.defaultLabelText = "Slide To Unlock"
        slide.thumnailImageView.image = #imageLiteral(resourceName: "ic_arrow")
        return slide
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(slideToOpen)
        self.view.addSubview(slideToUnlock)
        self.view.addSubview(slideToLock)
    }
    
    // MARK: MTSlideToOpenDelegate
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        let alertController = UIAlertController(title: "", message: "Done!", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            sender.resetStateWithAnimation(false)
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

