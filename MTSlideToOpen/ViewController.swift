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
        slide.sliderCornerRadius = 28
        slide.showSliderText = true
        slide.thumbnailColor = UIColor(red:141.0/255, green:19.0/255, blue:65.0/255, alpha:1.0)
        slide.slidingColor = UIColor.red
        slide.textColor = UIColor.orange
        slide.sliderBackgroundColor = UIColor(red:0.88, green:1, blue:0.98, alpha:1.0)
        slide.delegate = self
        slide.thumnailImageView.image = #imageLiteral(resourceName: "ic_arrow")
        return slide
    }()
    lazy var slideToLock: MTSlideToOpenView = {
        let slide = MTSlideToOpenView(frame: CGRect(x: 26, y: 200, width: 317, height: 56))
        slide.sliderViewTopDistance = 0
        slide.sliderCornerRadius = 28
        slide.thumnailImageView.backgroundColor  = UIColor(red:200.0/255, green:200.0/255, blue:200.0/255, alpha:1.0)
        slide.draggedView.backgroundColor = UIColor(red:200.0/255, green:200.0/255, blue:200.0/255, alpha:1.0)
        slide.delegate = self
        slide.thumbnailViewStartingDistance = 20
        slide.labelText = "Slide To Lock"
        slide.thumnailImageView.image = #imageLiteral(resourceName: "ic_arrow")
        return slide
    }()
    lazy var customizeSlideToOpen: MTSlideToOpenView = {
        let slide = MTSlideToOpenView(frame: CGRect(x: 26, y: 300, width: 317, height: 56))
        slide.sliderViewTopDistance = 0
        slide.thumbnailViewTopDistance = 4;
        slide.thumbnailViewStartingDistance = 4;
        slide.sliderCornerRadius = 28
        slide.thumnailImageView.backgroundColor = .white
        slide.draggedView.backgroundColor = .clear
        slide.delegate = self
        slide.thumnailImageView.image = #imageLiteral(resourceName: "ic_arrow")
        slide.sliderBackgroundColor = .black
        return slide
    }()
    lazy var slideToUnlock: MTSlideToOpenView = {
        let frame = CGRect(x: 26, y: 400, width: 317, height: 56)
        let slide = MTSlideToOpenView(frame: frame)
        slide.sliderViewTopDistance = 6
        slide.sliderCornerRadius = 22
        slide.delegate = self
        slide.labelText = "Slide To Unlock"
        slide.thumnailImageView.image = #imageLiteral(resourceName: "ic_arrow")
        slide.animationChangedEnabledBlock = { isEnabled in
            if isEnabled {
                slide.thumnailImageView.backgroundColor = slide.thumbnailColor
                slide.draggedView.isHidden = false
                slide.thumnailImageView.backgroundColor = slide.sliderBackgroundColor
                slide.textLabel.text = slide.labelText
                slide.thumnailImageView.layer.shadowOpacity = 0
            } else {
                slide.thumnailImageView.backgroundColor = UIColor(red:210.0/255, green:219.0/255, blue:228.0/255, alpha:0.8)
                slide.thumnailImageView.layer.shadowColor = UIColor(red:0/255, green:0/255, blue:0/255, alpha:0.2).cgColor
                slide.thumnailImageView.layer.shadowOffset = CGSize(width: 0, height: 25)
                slide.thumnailImageView.layer.shadowRadius = 28
                slide.thumnailImageView.layer.shadowOpacity = 1
                slide.draggedView.isHidden = true
                slide.sliderHolderView.backgroundColor = UIColor(red:245.0/255, green:247.0/255, blue:250.0/255, alpha:1)
                slide.textLabel.text = ""
            }
        }
        slide.isEnabled = false
        return slide
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(slideToOpen)
        self.view.addSubview(slideToUnlock)
        self.view.addSubview(customizeSlideToOpen)
        self.view.addSubview(slideToLock)
    }
    
    // MARK: MTSlideToOpenDelegate
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        let alertController = UIAlertController(title: "", message: "Done!", preferredStyle: .alert)
        sender.startAnimating()
        let doneAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            sender.resetStateWithAnimation(false)
            sender.stopAnimating()
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

