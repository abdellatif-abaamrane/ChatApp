//
//  ChatViewController.swift
//  ByChat
//
//  Created by macbook-pro on 26/05/2020.
//

import UIKit



class ChatViewController: UICollectionViewController {
    
    let user : User
    var messages = [Message]()
    
    
    var cellRegisteration : UICollectionView.CellRegistration<MessageCell,Message> {
        UICollectionView.CellRegistration<MessageCell,Message> { cell, index, message in
            cell.message = message
        }
    }
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: Utilities.makeLayout(type: .Compositional))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        navigationItem.largeTitleDisplayMode = .never
        title = "@"+user.username
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        collectionView.addGestureRecognizer(tap)
        
    }
    @objc func handleTap() {
        accessoryView.textView.resignFirstResponder()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getConversation()
        listenConversation()
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: message)
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.count
    }
    lazy var accessoryView: CustomAccessoryView = {
       let accessoryView = CustomAccessoryView(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                          size: CGSize(width: view.frame.width, height: 100)))
        accessoryView.delegate = self
        accessoryView.backgroundColor = .chatPink
        return accessoryView
    }()
    
    
    override var inputAccessoryView: UIView? {
        get {
            return accessoryView
        }
        
    }
    override var canBecomeFirstResponder: Bool {
        true
    }
    func sendMessage(message:String,to user: User) {
        MessageService.shared.sendMessage(caption: message, to: user.uid) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func listenConversation() {
        MessageService.shared.listenConversetion(with: user) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                self.messages.append(message)
                self.collectionView.contentInset.bottom += 100
                delay(0.2) { [weak self] in
                    guard let self = self else { return }
                    self.collectionView.insertItems(at: [IndexPath(item: self.messages.count-1, section: 0)])
                }
                self.collectionView.scrollToBottomAnimated(padding: 100, animated: true)
                self.collectionView.contentInset.bottom -= 100

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func getConversation() {
        guard messages.isEmpty else { return }
        MessageService.shared.getConversetion(with: user) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                self.messages.append(contentsOf: messages)
                self.collectionView.reloadData()
                delay(0.2) { [weak self] in
                    guard let self = self else { return }
                    self.collectionView.scrollToBottomAnimated(padding: 100, animated: true)
                }
                
                

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension ChatViewController: CustomAccessoryViewDelegate {
    func sendMassage(message: String, accessoryView: CustomAccessoryView) {
        sendMessage(message: message, to: user)
    }
    
    func didBeginEdit(accessoryView: CustomAccessoryView) {
        collectionView.scrollToItem(at: IndexPath(item: messages.count-1, section: 0), at: .bottom, animated: true)
    }
    
    
}
