//
//  MessageController.swift
//  TinderClone
//
//  Created by Vincent Angelo on 24/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MessageCell"

class MessageController: UITableViewController {
    
    // MARK: - Properties
    
    private let user: User
    
    private let headerView = MatchHeader()
    
    override func viewDidLoad() {
        configureTableView()
        configureNavigationBar()
        fetchMatches()
    }
    
    init(user: User){
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func fetchMatches(){
        Service.fetchMatches { matches in
            self.headerView.matches = matches
        }
    }
    
    // MARK: - Helpers
    
    func configureTableView(){
        headerView.delegate = self
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        
        tableView.tableHeaderView = headerView
        
    }
    
    func configureNavigationBar(){
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 28, width: 28)
        leftButton.isUserInteractionEnabled = true
        leftButton.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        leftButton.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysTemplate)
        icon.tintColor = .systemPink
        
        navigationItem.titleView = icon
    }
}

// MARK: - UITableViewDataSource

extension MessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MessageController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        label.text = "Messages"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        
        return view
    }
}

// MARK: - MatchHeaderDelegate

extension MessageController: MatchHeaderDelegate {
    func matchHeader(_ header: MatchHeader, wantsToStartChatWith uid: String) {
        Service.fetchUser(withUid: uid) { user in
            let controller = ChatController(user: user)
            let nav  = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    
}
