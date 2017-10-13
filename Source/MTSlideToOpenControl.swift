//
//  MTSlideToOpenControl.swift
//  MTSlideToOpen
//
//  Created by Martin Lee on 10/12/17.
//  Copyright © 2017 Martin Le. All rights reserved.
//

import UIKit

class MTSlideToOpenControl: UIView, UIGestureRecognizerDelegate {
    // MARK: Private Views
    private let textLabel: UILabel = {
       let label = UILabel.init()
        return label
    }()
    private let buttonView: UIView = {
        let view = UIView()
        return view
    }()
    private let sliderHolderView: UIView = {
        let view = UIView()
        return view
    }()
    private let view: UIView = {
       let view = UIView()
        return view
    }()
    // MARK: Public Properties
    var animationVelocity: Double = 0.2
    var sliderTopGap: CGFloat = 8.0 {
        didSet {
            setStyle()
            layoutIfNeeded()
        }
    }
    var sliderCornerRadious: CGFloat = 30.0 {
        didSet {
            setStyle()
            layoutIfNeeded()
        }
    }
    var sliderBackgroundColor: UIColor = UIColor(red:0.1, green:0.61, blue:0.84, alpha:0.1)
    var buttonColor: UIColor = UIColor(red:0.1, green:0.61, blue:0.84, alpha:1)
    var labelText: String = "Swipe to sign document"
    var labelFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    var labelTextColor: UIColor = UIColor(red:0.1, green:0.61, blue:0.84, alpha:1)
    var labelTextAlignment: NSTextAlignment = .center
    var gapTextLabelLeading: CGFloat = 0
    var canAutomaticResetState: Bool = false
    // MARK: Private Properties
    private var leadingButtonViewConstraint: NSLayoutConstraint?
    private var leadingTextLabelConstraint: NSLayoutConstraint?
    private var xPositionInButtonView: CGFloat = 0
    private var xEndingPoint: CGFloat = 0
    private var isAnimaionEnabled: Bool = true
    private var buttonHeight: CGFloat = 0
    private var isStopAnimate: Bool = false
    
    private var xTapStartLocation: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(view)
        view.addSubview(buttonView)
        view.addSubview(sliderHolderView)
        view.addSubview(textLabel)
        view.bringSubview(toFront: self.buttonView)
        setupConstraint()
        setStyle()
        // Add pan gesture
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.delegate = self
        buttonView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupConstraint() {
        view.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        sliderHolderView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        // Setup for view
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        // Setup for circle View
        leadingButtonViewConstraint = buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        leadingButtonViewConstraint?.isActive = true
        buttonView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        buttonView.heightAnchor.constraint(equalTo: buttonView.widthAnchor).isActive = true
        // Setup for slider holder view
        sliderHolderView.topAnchor.constraint(equalTo: view.topAnchor, constant: sliderTopGap).isActive = true
        sliderHolderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sliderHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sliderHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // Setup for textLabel
        textLabel.topAnchor.constraint(equalTo: sliderHolderView.topAnchor, constant: sliderTopGap).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: sliderHolderView.centerYAnchor).isActive = true
        leadingTextLabelConstraint = textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: gapTextLabelLeading)
        leadingTextLabelConstraint?.isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: CGFloat(-8)).isActive = true
    }
    
    private func setStyle() {
        buttonView.backgroundColor = buttonColor
        buttonView.layer.masksToBounds = true
        buttonView.layer.cornerRadius = buttonView.frame.width / 2.0
        textLabel.text = labelText
        textLabel.font = labelFont
        textLabel.textColor = labelTextColor
        textLabel.textAlignment = labelTextAlignment
        sliderHolderView.layer.cornerRadius = sliderCornerRadious
        sliderHolderView.backgroundColor = sliderBackgroundColor
        buttonHeight = buttonView.bounds.height
        xEndingPoint = self.view.frame.maxX - buttonHeight
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonView.layer.cornerRadius = buttonView.frame.width / 2.0
        buttonView.layer.masksToBounds = true
        xEndingPoint = self.view.frame.maxX
        if buttonHeight == 0 {
            buttonHeight = buttonView.bounds.height
            xEndingPoint = self.view.frame.maxX - buttonHeight
        }
    }
    
    private func isTapOnButtonViewWithPoint(_ point: CGPoint) -> Bool{
        return self.buttonView.frame.contains(point)
    }
    
    private func updateButtonViewLeadingPosition(_ x: CGFloat) {
        leadingButtonViewConstraint?.constant = x
        layoutIfNeeded()
    }
    
    // MARK: UIPanGestureRecognizer
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translatedPoint = sender.translation(in: view).x
        let xLocation = translatedPoint > 0 ? translatedPoint : (xEndingPoint + translatedPoint)
        switch sender.state {
        case .began:
            break
        case .changed:
            if xLocation >= xEndingPoint {
                updateButtonViewLeadingPosition(xEndingPoint)
                return
            }
            if xLocation <= 0 {
                textLabel.alpha = 1
                updateButtonViewLeadingPosition(0)
                return
            }
            updateButtonViewLeadingPosition(xLocation)
            textLabel.alpha = (xEndingPoint - xLocation) / xEndingPoint
            break
        case .ended:
            if xLocation >= xEndingPoint {
                textLabel.alpha = 0
                updateButtonViewLeadingPosition(xEndingPoint)
                isStopAnimate = !canAutomaticResetState
                return
            }
            if xLocation <= 0 {
                textLabel.alpha = 1
                updateButtonViewLeadingPosition(0)
                return
            }
            UIView.animate(withDuration: animationVelocity) {
                self.leadingButtonViewConstraint?.constant = 0
                self.textLabel.alpha = 1
                self.layoutIfNeeded()
            }
            break
        default:
            break
        }
    }
    
    func resetState() {
        UIView.animate(withDuration: animationVelocity) {
            self.leadingButtonViewConstraint?.constant = 0
            self.textLabel.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    // MARK: UIGestureDelegate
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        let result = gestureRecognizer.location(in: view).x < xEndingPoint
//        if result {
//
//        }
//        return result
//    }
}
