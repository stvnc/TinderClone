//
//  CardView.swift
//  TinderClone
//
//  Created by Vincent Angelo on 18/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit
import SDWebImage

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

protocol CardViewDelegate: class {
    func cardView(_ view: CardView, wantsToShowProfilefor user: User)
    func cardView(_ view: CardView, didLikeUser: Bool)
}

class CardView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CardViewDelegate?
    
    
    private lazy var barStackView =  SegmentedBarView(withCount: viewModel.imageURLs.count)
    
    let viewModel: CardViewModel
    
    
    
    private let gradientLayer = CAGradientLayer()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "app_icon")
        
        return iv
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        
        label.attributedText = viewModel.userInfoText
        
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
        
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        
        configureGestureRecognizers()
        
        imageView.sd_setImage(with: viewModel.imageURL)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
//        imageView.image = viewModel.user.images.first
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        addSubview(infoLabel)
        infoLabel.attributedText = viewModel.userInfoText
        infoLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 16)
        
        configureGradientLayer()
        
        configureBarStackView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    
    // MARK: - Actions
    
    @objc func handleShowProfile(){
        delegate?.cardView(self, wantsToShowProfilefor: viewModel.user)
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: nil)
        print("DEBUG: Translation x is \(translation.x)")
        print("DEBUG: Translation y is \(translation.y)")
        
        switch sender.state {
        case .began:
            print("DEBUG: Pan did begin..")
            superview?.subviews.forEach({ $0.layer.removeAllAnimations()
            })
        case .changed:
            panCard(sender: sender)
        case .ended:
            print("DEBUG: Pan ended..")
            resetCardPosition(sender: sender)
        default: break
        }
    }
    
    @objc func handleChangePhoto(sender: UITapGestureRecognizer){
        print("DEBUG: Tapped on photo")
        let location = sender.location(in: nil).x
        
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto {
            viewModel.showNextPhoto()
        } else {
            viewModel.showPreviousPhoto()
        }
        
        imageView.sd_setImage(with: viewModel.imageURL)
        
//        imageView.image = viewModel.imageToShow
        barStackView.setHighlighted(index: viewModel.index)
        
        
    }
    
    
    
    
    // MARK: - Helpers
    
    func configureBarStackView(){
        
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 4)
        
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
    }
    
    func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
        
    }
    
    func resetCardPosition(sender: UIPanGestureRecognizer) {
        
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shouldDismissCard = abs(sender.translation(in: nil).x ) > 100
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                let xTranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity
            }
        }) { _ in
            if shouldDismissCard {
                let didLike = direction == .right
                self.delegate?.cardView(self, didLikeUser: didLike)
            }
        }
    }
    
    func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    func configureGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
    }
}
