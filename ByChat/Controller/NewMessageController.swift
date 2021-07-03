//
//  NewMessageController.swift
//  ByChat
//
//  Created by macbook-pro on 26/05/2020.
//

import UIKit
import Firebase

protocol NewMessageControllerDelegate: AnyObject {
    func didSelectUser(user:User)
}


class NewMessageController: UITableViewController {
    
    var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    var filteredUsers = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    var isSearchMode : Bool {
        get {
            return searchController.isActive || !searchController.searchBar.text!.isEmpty
        }
    }
    
    weak var delegate : NewMessageControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: "user")
        configueUI()
        fetchUsers()
    }
    
    func configueUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelButtonTapped))
        title = "New Message"

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .chatPink
        appearance.titleTextAttributes = [.foregroundColor:UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a user"
        searchController.searchBar.tintColor = .chatPink

        navigationController?.navigationBar.tintColor = .white

        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    func fetchUsers() {
        guard let userID = AUTH.currentUser?.uid else { return }
        UserService.shared.fetchUsers { [weak self] result in
               guard let self = self else { return }
            switch result {
            case .success(let users):
                self.users.append(contentsOf: users.filter({ $0.uid != userID}))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    @objc func handleCancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUsers.count : users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        Utilities.configueContentCell(user: user, cell: cell, for: .custom)
        Utilities.configueBackgroundCell(cell: cell, with: .custom)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        dismiss(animated: true) {
            self.delegate?.didSelectUser(user: user)
        }
    }
}
extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let target = searchController.searchBar.text,
              !target.isEmpty else { tableView.reloadData(); return }
        
        REF_USERS.whereField("fullname", isEqualTo: target).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let snapshot = snapshot {
                    let users = snapshot.documents.map {  document -> User in
                        let user = User(uid: document.documentID,
                                        dictionary: document.data())
                        return user
                    }
                    self.filteredUsers = users
                }
            }
    }
}


