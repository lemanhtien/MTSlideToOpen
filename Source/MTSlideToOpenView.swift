//
//  MTSlideToOpenControl.swift
//  MTSlideToOpen
//
//  Created by Martin Lee on 10/12/17.
//  Copyright © 2017 Martin Le. All rights reserved.
//

import UIKit

@objc protocol MTSlideToOpenDelegate {
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView)
}

class MTSlideToOpenView: UIView {
    // MARK: All Views
    let textLabel: UILabel = {
        let label = UILabel.init()
        return label
    }()
    let thumnailImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true        
        view.contentMode = .center
        return view
    }()
    let sliderHolderView: UIView = {
        let view = UIView()
        return view
    }()
    let draggedView: UIView = {
        let view = UIView()
        return view
    }()
    let view: UIView = {
        let view = UIView()
        return view
    }()
    // MARK: Public properties
    weak var delegate: MTSlideToOpenDelegate?
    var animationVelocity: Double = 0.2
    var sliderViewTopDistance: CGFloat = 8.0 {
        didSet {
            topSliderConstraint?.constant = sliderViewTopDistance
            layoutIfNeeded()
        }
    }
    var thumbnailViewLeadingDistance: CGFloat = 0.0 {
        didSet {
            updateThumbnailViewLeadingPosition(thumbnailViewLeadingDistance)
            layoutIfNeeded()
        }
    }
    var textLabelLeadingDistance: CGFloat = 0 {
        didSet {
            leadingTextLabelConstraint?.constant = textLabelLeadingDistance
            layoutIfNeeded()
        }
    }
    var isEnabled:Bool = true {
        didSet {
            if isEnabled {
                thumnailImageView.backgroundColor = defaultThumbnailColor
                sliderHolderView.backgroundColor = defaultSliderBackgroundColor
                textLabel.text = defaultLabelText
            } else {
                thumnailImageView.backgroundColor = disableThumbnailViewColor
                sliderHolderView.backgroundColor = disableSliderViewColor
                textLabel.text = ""
            }
        }
    }
    // MARK: Default styles
    var sliderCornerRadious: CGFloat = 30.0 {
        didSet {
            sliderHolderView.layer.cornerRadius = sliderCornerRadious
            draggedView.layer.cornerRadius = sliderCornerRadious
        }
    }
    var disableThumbnailViewColor: UIColor = UIColor(red:182.0/255, green:192.0/255, blue:202.0/255, alpha:1) {
        didSet {
            if !isEnabled {
                thumnailImageView.backgroundColor = disableThumbnailViewColor
            }
        }
    }
    var disableSliderViewColor: UIColor = UIColor(red:245.0/255, green:247.0/255, blue:250.0/255, alpha:1) {
        didSet {
            if !isEnabled {
                sliderHolderView.backgroundColor = disableSliderViewColor
            }
        }
    }
    var defaultSliderBackgroundColor: UIColor = UIColor(red:0.1, green:0.61, blue:0.84, alpha:0.1) {
        didSet {
            sliderHolderView.backgroundColor = defaultSliderBackgroundColor
        }
    }
    
    var defaultSlidingColor:UIColor = UIColor(red:25.0/255, green:155.0/255, blue:215.0/255, alpha:0.7) {
        didSet {
            draggedView.backgroundColor = defaultSlidingColor
        }
    }
    var defaultThumbnailColor:UIColor = UIColor(red:25.0/255, green:155.0/255, blue:215.0/255, alpha:1) {
        didSet {
            thumnailImageView.backgroundColor = defaultSlidingColor
        }
    }
    var defaultLabelText: String = "Swipe to open" {
        didSet {
            textLabel.text = defaultLabelText
        }
    }
    // MARK: Private Properties
    private var leadingThumbnailViewConstraint: NSLayoutConstraint?
    private var leadingTextLabelConstraint: NSLayoutConstraint?
    private var topSliderConstraint: NSLayoutConstraint?
    private var xPositionInThumbnailView: CGFloat = 0
    private var xEndingPoint: CGFloat = 0
    private var buttonHeight: CGFloat = 0
    private var isFinished: Bool = false
    private var layoutSetuped: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    private func setupView() {
        self.addSubview(view)
        view.addSubview(thumnailImageView)
        view.addSubview(sliderHolderView)
        view.addSubview(draggedView)
        sliderHolderView.addSubview(textLabel)
        view.bringSubview(toFront: self.thumnailImageView)
        setupConstraint()
        setStyle()
        // Add pan gesture
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        thumnailImageView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupConstraint() {
        view.translatesAutoresizingMaskIntoConstraints = false
        thumnailImageView.translatesAutoresizingMaskIntoConstraints = false
        sliderHolderView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        draggedView.translatesAutoresizingMaskIntoConstraints = false
        // Setup for view
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        // Setup for circle View
        leadingThumbnailViewConstraint = thumnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        leadingThumbnailViewConstraint?.isActive = true
        thumnailImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        thumnailImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        thumnailImageView.heightAnchor.constraint(equalTo: thumnailImageView.widthAnchor).isActive = true
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
        draggedView.trailingAnchor.constraint(equalTo: thumnailImageView.trailingAnchor).isActive = true
    }
    
    private func setStyle() {
        thumnailImageView.backgroundColor = defaultThumbnailColor
        thumnailImageView.layer.masksToBounds = true
        thumnailImageView.layer.cornerRadius = self.frame.height / 2.0
        textLabel.text = defaultLabelText
        textLabel.font = UIFont.systemFont(ofSize: 15.0)
        textLabel.textColor = UIColor(red:0.1, green:0.61, blue:0.84, alpha:1)
        textLabel.textAlignment = .center
        sliderHolderView.backgroundColor = defaultSliderBackgroundColor
        sliderHolderView.layer.cornerRadius = sliderCornerRadious
        draggedView.backgroundColor = defaultSlidingColor
        draggedView.layer.cornerRadius = sliderCornerRadious
        buttonHeight = thumnailImageView.bounds.height
        xEndingPoint = self.view.frame.maxX - buttonHeight
    }
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        xEndingPoint = self.view.frame.maxX
        if buttonHeight == 0 {
            buttonHeight = thumnailImageView.bounds.height
            xEndingPoint = self.view.frame.maxX - buttonHeight
            return
        }
        thumnailImageView.layer.cornerRadius = thumnailImageView.frame.width / 2.0
        thumnailImageView.layer.masksToBounds = true
    }
    
    private func isTapOnThumbnailViewWithPoint(_ point: CGPoint) -> Bool{
        return self.thumnailImageView.frame.contains(point)
    }
    
    private func updateThumbnailViewLeadingPosition(_ x: CGFloat) {
        leadingThumbnailViewConstraint?.constant = x
        layoutIfNeeded()
    }
    
    // MARK: UIPanGestureRecognizer
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if isFinished || !isEnabled {
            return
        }
        let translatedPoint = sender.translation(in: view).x
        switch sender.state {
        case .began:
            break
        case .changed:
            if translatedPoint >= xEndingPoint {
                updateThumbnailViewLeadingPosition(xEndingPoint)
                return
            }
            if translatedPoint <= thumbnailViewLeadingDistance {
                textLabel.alpha = 1
                updateThumbnailViewLeadingPosition(thumbnailViewLeadingDistance)
                return
            }
            updateThumbnailViewLeadingPosition(translatedPoint)
            textLabel.alpha = (xEndingPoint - translatedPoint) / xEndingPoint
            break
        case .ended:
            if translatedPoint >= xEndingPoint {
                textLabel.alpha = 0
                updateThumbnailViewLeadingPosition(xEndingPoint)
                // Finish action
                isFinished = true
                delegate?.mtSlideToOpenDelegateDidFinish(self)
                return
            }
            if translatedPoint <= thumbnailViewLeadingDistance {
                textLabel.alpha = 1
                updateThumbnailViewLeadingPosition(thumbnailViewLeadingDistance)
                return
            }
            UIView.animate(withDuration: animationVelocity) {
                self.leadingThumbnailViewConstraint?.constant = self.thumbnailViewLeadingDistance
                self.textLabel.alpha = 1
                self.layoutIfNeeded()
            }
            break
        default:
            break
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if !layoutSetuped {
            thumnailImageView.layer.cornerRadius = self.frame.height / 2.0
            layoutSetuped = true
        }
    }
    
    // Others
    func resetStateWithAnimation(_ animated: Bool) {
        let action = {
            self.leadingThumbnailViewConstraint?.constant = 0
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
