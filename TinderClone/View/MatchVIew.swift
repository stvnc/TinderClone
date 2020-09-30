//
//  MatchView.swift
//  TinderClone
//
//  Created by Vincent Angelo on 23/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

protocol MatchViewDelegate: class {
    func matchView(_ view: MatchView, wantsToSendMessageTo user: User)
}

class MatchView: UIView {
    private let viewModel: MatchViewViewModel
    
    weak var delegate: MatchViewDelegate?
    
    
    private let matchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let currentUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
        
    }()
    
    private let matchedUserImageView: UIImageView = {
           let iv = UIImageView(image: #imageLiteral(resourceName: "top_left_profile"))
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.layer.borderWidth = 2
           iv.layer.borderColor = UIColor.white.cgColor
           return iv
           
       }()
    
    private let sendMessageButton: SendMessageButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        return button
    }()
    
    private let keepSwipingButton: KeepSwipingButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        
        return button
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    lazy var views = [matchImageView, descriptionLabel, currentUserImageView, matchedUserImageView, sendMessageButton, keepSwipingButton]
    
    init(viewModel: MatchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        loadUserData()
        
        configureBlurView()
        configureUI()
        configureAnimations()
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSendMessage(){
        delegate?.matchView(self, wantsToSendMessageTo: viewModel.matchedUser)
    }
    
    @objc func handleKeepSwiping(){
        
    }
    
    @objc func handleDismissal(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func loadUserData(){
        descriptionLabel.text = viewModel.matchLabelText
        currentUserImageView.sd_setImage(with: viewModel.currentUserImageURL)
        matchedUserImageView.sd_setImage(with: viewModel.matchedUserImageURL)
    }
    
    func configureUI(){
        views.forEach { view in
            addSubview(view)
            view.alpha = 1
        }
        
        currentUserImageView.anchor(left: centerXAnchor, paddingLeft: 16)
        currentUserImageView.setDimensions(height: 140, width: 140)
        currentUserImageView.layer.cornerRadius = 140 / 2
        currentUserImageView.centerY(inView: self)
        
        matchedUserImageView.anchor(right: centerXAnchor, paddingRight: 16)
        matchedUserImageView.setDimensions(height: 140, width: 140)
        matchedUserImageView.layer.cornerRadius = 140 / 2
        
        matchedUserImageView.centerY(inView: self)
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 48, paddingRight: 48)
        sendMessageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 48, paddingRight: 48)
        keepSwipingButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        descriptionLabel.anchor(left: leftAnchor, bottom: currentUserImageView.topAnchor, right: rightAnchor, paddingBottom: 32)
        
        matchImageView.anchor(bottom: descriptionLabel.topAnchor, paddingBottom: 16)
        matchImageView.setDimensions(height: 80, width: 300)
        matchImageView.centerX(inView: self)
    }
    
    func configureAnimations(){
        views.forEach({ $0.alpha = 1})
        
        let angle = 30 * CGFloat.pi / 180
        
        let rotationAngle = -angle
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
//        self.sendMessageButton.transform = CGAffineTransform
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchedUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.45) {
                self.currentUserImageView.transform = .identity
                self.matchedUserImageView.transform = .identity
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.75, delay: 0.5 * 1.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
            
        }, completion: nil)
    }
    
    
    
    func configureBlurView(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        visualEffectView.addGestureRecognizer(tap)
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {self.visualEffectView.alpha = 1}, completion: nil)
    }
}
 
