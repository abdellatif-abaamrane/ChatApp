//
//  MainChatViewController.swift
//  ByChat
//
//  Created by macbook-pro on 25/05/2020.
//

import UIKit


class MainChatViewController: UITableViewController {
    
    
    var user : User?
    var messages = [Message]()
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = 56/2
        button.backgroundColor = .chatPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient()
        checkAuthenticationAndConfigueUI()
        tableView.register(ConverserCell.self, forCellReuseIdentifier: "converser")
    }
    
    func checkAuthenticationAndConfigueUI() {
        DispatchQueue.main.async {
            if AUTH.currentUser == nil {
                let rootViewController = LoginViewController()
                let nav = UINavigationController(rootViewController: rootViewController)
                nav.navigationBar.barStyle = .black
                nav.navigationBar.isHidden = true
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            } else {
                self.setupNavigation()
                self.fetchUser()
               // self.fetchLastConversations()
                self.listenToLastConversations()
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupNavigation() {
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 56),
            actionButton.widthAnchor.constraint(equalTo: actionButton.heightAnchor),
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        
        navigationItem.largeTitleDisplayMode = .always
        let imageView = UIImageView(image: #imageLiteral(resourceName: "ic_account_box_white_2x").withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.layer.cornerRadius = 30/2
        let barButtonItem = UIBarButtonItem(customView: imageView)
        
        navigationItem.leftBarButtonItem = barButtonItem
        
        title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
        //appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor:UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor:UIColor.white]
        appearance.backgroundColor = .chatPink
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        
    }
    //MARK: - Properties
    
    //MARK: - LifeCycle
    
    //MARK: - Selectors
    @objc func actionButtonTapped() {
        let newMassage = NewMessageController(style: .insetGrouped)
        newMassage.delegate = self
        let nav = UINavigationController(rootViewController: newMassage)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    @objc func handleProfileImageTapped() {
        
    }
    //MARK: - API
    
    //MARK: - Helpers
    func fetchUser() {
        UserService.shared.fetchCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func fetchLastConversations() {
        MessageService.shared.getUserConversers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                self.messages.append(contentsOf: messages)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func listenToLastConversations() {
        MessageService.shared.listenToUserConversers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let change):
                switch change {
                case .added(messages: let messages):
                    self.tableView.performBatchUpdates {
                        messages.forEach { message in
                            self.messages.insert(message, at: 0)
                            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                        }
                    }
                    
                case .modified(message: let message):
                    print(message.isMine)
                    let converser =  message.isMine ? message.receiver : message.sender
                    let index = self.messages.firstIndex(where: { $0.receiver.uid == converser.uid || $0.sender.uid == converser.uid })
                    if let index = index {
                        self.tableView.performBatchUpdates {
                            self.messages.remove(at: index)
                            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .right)
                            self.messages.insert(message, at: 0)
                            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
                        } completion: { _ in
                            
                        }
                    }

                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension MainChatViewController: NewMessageControllerDelegate {
    func didSelectUser(user: User) {
        let chatVc = ChatViewController(user: user)
        show(chatVc, sender: self)
        
    }
    
    
}
extension MainChatViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "converser", for: indexPath) as! ConverserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatViewController = ChatViewController(user: message.converser)
        show(chatViewController, sender: self)
    }
}
