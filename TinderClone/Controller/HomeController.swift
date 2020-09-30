//
//  HomeController.swift
//  TinderClone
//
//  Created by Vincent Angelo on 17/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    var user: User?
    
    private var viewModels = [CardViewModel]()
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private let deckView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateUserAndConfigureUI()
        fetchCurrentUserAndCards()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK:  - Selectors
    
    
    // MARK: - API
    
    
    func fetchUsers(forCurrentUser user: User){
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map({ CardViewModel(user: $0) })
            
            // short version of
            
//            users.forEach { user in
//                let viewModel = CardViewModel(user: user)
//                viewModels.append(viewModel)
//            }
        }
    }
    
    func logout() {
        do{
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG: Failed to sign out.")
        }
        
    }
    
    func presentLoginScreen(){
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
        }
    }
    
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async{
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        }else{
            configureUI()
            configureCards()
        }
        print("DEBUG: User is not logged in")
        
    }
    
    // MARK: - Helpers
    
    func fetchCurrentUserAndCards(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            print("DEBUG: User fullname is \(user.name)")
            self.user = user
            self.fetchUsers(forCurrentUser: user)
        }
    }
    
    func configureCards(){
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
            cardView.delegate = self
        }
        
        cardViews = deckView.subviews.map({ ($0 as? CardView)!})
        topCardView = cardViews.last
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        topStack.delegate = self
        bottomStack.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
        
    }
    
    func performSwipeAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700 : -700
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.topCardView?.frame = CGRect(x: translation, y: 0, width: (self.topCardView?.frame.width)!, height: (self.topCardView?.frame.height)!)
        }) { _ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            
            self.cardViews.remove(at: self.cardViews.count-1)
            self.topCardView = self.cardViews.last
        }
        
    }
    
    func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool) {
        Service.saveSwipe(forUser: user, isLike: didLike) { error in
            self.topCardView = self.cardViews.last
            
            guard didLike == true else { return }
            Service.checkIfMatchExists(forUser: user) { didMatch in
                print("Users did match..")
                self.presentMatchView(forUser: user)
                guard let currentUser = self.user else { return }
                Service.uploadMatch(currentUser: currentUser, matchedUser: user)
            }
        }
    }
    
    func presentMatchView(forUser user: User) {
        guard let currentUser = self.user else { return }
        let viewModel = MatchViewViewModel(currentUser: currentUser, matchedUser: user)
        let matchView = MatchView(viewModel: viewModel)
        view.addSubview(matchView)
        matchView.delegate = self
        matchView.fillSuperview()
    }
}

extension HomeController: HomeNavigationStackViewDelegate {
    func showSettings() {
        print("DEBUG: USER SETTINGS")
        guard let user = self.user else { return }
        let controller = SettingsController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showMessages() {
        
        guard let user = user else { return }
        
        let controller = MessageController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
}

extension HomeController: SettingsControllerDelegate {
    func handleLogout() {
        presentLoginScreen()
    }
    
    func updateUser(_ controller: SettingsController, updatedUser: User) {
        print("updated user")
    }
}



extension HomeController: CardViewDelegate {
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview()
        self.cardViews.removeAll(where: {view == $0})
        
        guard let user = topCardView?.viewModel.user else { return }
        Service.saveSwipe(forUser: user, isLike: didLikeUser, completion: nil)
        
        self.topCardView = cardViews.last
    }
    
    func cardView(_ view: CardView, wantsToShowProfilefor user: User) {
        let controller = ProfileController(user: user)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    
}

extension HomeController: BottomControlsStackViewDelegate {
    func handleLike() {
        print("DEBUG: Handle Like")
        guard let topCard = topCardView else { return }
        
        performSwipeAnimation(shouldLike: true)
        saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
        
        
        
        print("DEBUG: Like user \(topCard.viewModel.user.name)")
    }
    
    func handleDislike() {
        print("DEBUG: Handle dislike")
        guard let topCard = topCardView else { return }
        performSwipeAnimation(shouldLike: false)
        Service.saveSwipe(forUser: topCard.viewModel.user, isLike: false, completion: nil)
    }
    
    func handleRefresh() {
        print("DEBUG: Handle refresh")
        guard let user = self.user else { return }
    
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map({ CardViewModel(user: $0 )})
        }
        
    }
    
    
}

extension HomeController: ProfileControllerDelegate {
    func profileController(_ controller: ProfileController, didLikeUser user: User) {
        print("DEBUG: Handle liking user in home controller..")
        controller.dismiss(animated: true){
            self.performSwipeAnimation(shouldLike: true)
            self.saveSwipeAndCheckForMatch(forUser: user, didLike: true)
        }
    }
    
    func profileController(_ controller: ProfileController, didDislikeUser user: User) {
        print("DEBUG: Handle disliking user in home controller..")
        controller.dismiss(animated: true){
            self.performSwipeAnimation(shouldLike: false)
            self.saveSwipeAndCheckForMatch(forUser: user, didLike: false)
            
        }
    }
}

extension HomeController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        fetchCurrentUserAndCards()
    }
    
    
}

extension HomeController: MatchViewDelegate {
    func matchView(_ view: MatchView, wantsToSendMessageTo user: User) {
        print("DEBUG: Show messages for user \(user.name)")
    }
    
    
}
