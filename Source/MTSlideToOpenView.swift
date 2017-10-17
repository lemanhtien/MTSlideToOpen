//
//  MTSlideToOpenControl.swift
//  MTSlideToOpen
//
//  Created by Martin Lee on 10/12/17.
//  Copyright © 2017 Martin Le. All rights reserved.
//

import UIKit

protocol MTSlideToOpenDelegate {
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView)
}

class MTSlideToOpenView: UIView {
    // MARK: Private Views
    private let textLabel: UILabel = {
       let label = UILabel.init()
        return label
    }()
    private let thumnailView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true        
        view.contentMode = .center
        return view
    }()
    private let sliderHolderView: UIView = {
        let view = UIView()
        return view
    }()
    private let draggedView: UIView = {
        let view = UIView()
        return view
    }()
    private let view: UIView = {
       let view = UIView()
        return view
    }()
    // MARK: Public Properties
    var delegate: MTSlideToOpenDelegate?
    var animationVelocity: Double = 0.2
    var sliderViewTopDistance: CGFloat = 8.0 {
        didSet {
            topSliderConstraint?.constant = sliderViewTopDistance
            layoutIfNeeded()
        }
    }
    var buttonViewLeadingDistance: CGFloat = 0.0 {
        didSet {
            updateButtonViewLeadingPosition(buttonViewLeadingDistance)
        }
    }
    var sliderCornerRadious: CGFloat = 30.0 {
        didSet {
            setStyle()
            layoutIfNeeded()
        }
    }
    var isEnabled:Bool = true {
        didSet {
            setStyle()
        }
    }
    var disableButtonViewColor: UIColor = UIColor(red:182.0/255, green:192.0/255, blue:202.0/255, alpha:1) {
        didSet {
            setStyle()
        }
    }
    var disableSliderViewColor: UIColor = UIColor(red:245.0/255, green:247.0/255, blue:250.0/255, alpha:1) {
        didSet {
            setStyle()
        }
    }
    var sliderBackgroundColor: UIColor = UIColor(red:0.1, green:0.61, blue:0.84, alpha:0.1) {
        didSet {
            setStyle()
        }
    }
    
    var slidingColor:UIColor = UIColor(red:25.0/255, green:155.0/255, blue:215.0/255, alpha:0.7) {
        didSet {
            setStyle()
        }
    }
    
    var buttonColor: UIColor = UIColor(red:0.1, green:0.61, blue:0.84, alpha:1) {
        didSet {
            setStyle()
        }
    }
    
    var labelText: String = "Swipe to sign document" {
        didSet {
            setStyle()
        }
    }
    var labelFont: UIFont = UIFont.systemFont(ofSize: 15.0) {
        didSet {
            setStyle()
        }
    }
    var labelTextColor: UIColor = UIColor(red:0.1, green:0.61, blue:0.84, alpha:1) {
        didSet {
            setStyle()
        }
    }
    var labelTextAlignment: NSTextAlignment = .center {
        didSet {
            setStyle()
        }
    }
    var textLabelLeadingDistance: CGFloat = 0 {
        didSet {
            leadingTextLabelConstraint?.constant = textLabelLeadingDistance
        }
    }
    var thumbnailIcon: UIImage? {
        didSet {
            setStyle()
        }
    }
    
    // MARK: Private Properties
    private var leadingButtonViewConstraint: NSLayoutConstraint?
    private var leadingTextLabelConstraint: NSLayoutConstraint?
    private var topSliderConstraint: NSLayoutConstraint?
    private var xPositionInButtonView: CGFloat = 0
    private var xEndingPoint: CGFloat = 0
    private var buttonHeight: CGFloat = 0
    private var isFinished: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    private func setupView() {
        self.addSubview(view)
        view.addSubview(thumnailView)
        view.addSubview(sliderHolderView)
        view.addSubview(draggedView)
        sliderHolderView.addSubview(textLabel)
        view.bringSubview(toFront: self.thumnailView)
        setupConstraint()
        setStyle()
        // Add pan gesture
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        thumnailView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupConstraint() {
        view.translatesAutoresizingMaskIntoConstraints = false
        thumnailView.translatesAutoresizingMaskIntoConstraints = false
        sliderHolderView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        draggedView.translatesAutoresizingMaskIntoConstraints = false
        // Setup for view
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        // Setup for circle View
        leadingButtonViewConstraint = thumnailView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        leadingButtonViewConstraint?.isActive = true
        thumnailView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        thumnailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        thumnailView.heightAnchor.constraint(equalTo: thumnailView.widthAnchor).isActive = true
        // Setup for slider holder view
        topSliderConstraint = sliderHolderView.topAnchor.constraint(equalTo: view.topAnchor, constant: sliderViewTopDistance)
        topSliderConstraint?.isActive = true
        sliderHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sliderHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sliderHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Setup for textLabel
        textLabel.topAnchor.constraint(equalTo: sliderHolderView.topAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: sliderHolderView.centerYAnchor).isActive = true
        leadingTextLabelConstraint = textLabel.leadingAnchor.constraint(equalTo: sliderHolderView.leadingAnchor, constant: textLabelLeadingDistance)
        leadingTextLabelConstraint?.isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(-8)).isActive = true
        // Setup for Dragged View
        draggedView.leadingAnchor.constraint(equalTo: sliderHolderView.leadingAnchor).isActive = true
        draggedView.topAnchor.constraint(equalTo: sliderHolderView.topAnchor).isActive = true
        draggedView.bottomAnchor.constraint(equalTo: sliderHolderView.bottomAnchor).isActive = true
        draggedView.trailingAnchor.constraint(equalTo: thumnailView.trailingAnchor).isActive = true
    }
    
    private func setStyle() {
        if isEnabled {
            thumnailView.backgroundColor = buttonColor
            sliderHolderView.backgroundColor = sliderBackgroundColor
            textLabel.text = labelText
        } else {
            thumnailView.backgroundColor = disableButtonViewColor
            sliderHolderView.backgroundColor = disableSliderViewColor
            textLabel.text = ""
        }
        thumnailView.layer.masksToBounds = true
        thumnailView.layer.cornerRadius = thumnailView.frame.width / 2.0
        textLabel.font = labelFont
        textLabel.textColor = labelTextColor
        textLabel.textAlignment = labelTextAlignment
        sliderHolderView.layer.cornerRadius = sliderCornerRadious
        draggedView.backgroundColor = slidingColor
        draggedView.layer.cornerRadius = sliderCornerRadious
        buttonHeight = thumnailView.bounds.height
        xEndingPoint = self.view.frame.maxX - buttonHeight
        thumnailView.image = thumbnailIcon
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumnailView.layer.cornerRadius = thumnailView.frame.width / 2.0
        thumnailView.layer.masksToBounds = true
        xEndingPoint = self.view.frame.maxX
        if buttonHeight == 0 {
            buttonHeight = thumnailView.bounds.height
            xEndingPoint = self.view.frame.maxX - buttonHeight
        }
    }
    
    private func isTapOnButtonViewWithPoint(_ point: CGPoint) -> Bool{
        return self.thumnailView.frame.contains(point)
    }
    
    private func updateButtonViewLeadingPosition(_ x: CGFloat) {
        leadingButtonViewConstraint?.constant = x
        layoutIfNeeded()
    }
    
    // MARK: UIPanGestureRecognizer
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if isFinished || !isEnabled {
            return
        }
        let translatedPoint = sender.translation(in: view).x
        switch sender.state {
        case .began:
            break
        case .changed:
            if translatedPoint >= xEndingPoint {
                updateButtonViewLeadingPosition(xEndingPoint)
                return
            }
            if translatedPoint <= buttonViewLeadingDistance {
                textLabel.alpha = 1
                updateButtonViewLeadingPosition(buttonViewLeadingDistance)
                return
            }
            updateButtonViewLeadingPosition(translatedPoint)
            textLabel.alpha = (xEndingPoint - translatedPoint) / xEndingPoint
            break
        case .ended:
            if translatedPoint >= xEndingPoint {
                textLabel.alpha = 0
                updateButtonViewLeadingPosition(xEndingPoint)
                // Finish action
                isFinished = true
                delegate?.mtSlideToOpenDelegateDidFinish(self)
                return
            }
            if translatedPoint <= buttonViewLeadingDistance {
                textLabel.alpha = 1
                updateButtonViewLeadingPosition(buttonViewLeadingDistance)
                return
            }
            UIView.animate(withDuration: animationVelocity) {
                self.leadingButtonViewConstraint?.constant = self.buttonViewLeadingDistance
                self.textLabel.alpha = 1
                self.layoutIfNeeded()
            }
            break
        default:
            break
        }
    }
    
    // Others
    func resetStateWithAnimation(_ animated: Bool) {
        let action = {
            self.leadingButtonViewConstraint?.constant = 0
            self.textLabel.alpha = 1
            self.layoutIfNeeded()
            //
            self.isFinished = false
        }
        if animated {
            UIView.animate(withDuration: animationVelocity) {
               action()
            }
        } else {
            action()
        }
    }
}
