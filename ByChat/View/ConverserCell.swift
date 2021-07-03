//
//  ConverserCell.swift
//  ByChat
//
//  Created by macbook-pro on 28/05/2020.
//

import UIKit



class ConverserCell : UITableViewCell {
    
    var message : Message? {
        didSet {
            
            configueCell()
        }
    }
    
    var converser : User? {
        guard let message = message else { return nil }
        if message.isMine {
            print(message.receiver.uid)
            return message.receiver
        }
        return message.sender
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configueUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var profileImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(color: .chatPink))
        imageView.layer.cornerRadius = 40/2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var converserLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var messageTextLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var timestampLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    func configueUI() {
        let stackView = UIStackView(arrangedSubviews: [converserLabel,timestampLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let stackView2 = UIStackView(arrangedSubviews: [stackView,messageTextLabel])
        stackView2.axis = .vertical
        stackView2.distribution = .fillProportionally
        stackView2.alignment = .leading
        stackView2.spacing = 2
        
        let stackView3 = UIStackView(arrangedSubviews: [profileImageView,stackView2])
        stackView3.axis = .horizontal
        stackView3.distribution = .fillProportionally
        stackView3.alignment = .center
        stackView3.spacing = 10
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView3)
        NSLayoutConstraint.activate([
            timestampLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            stackView3.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView3.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            stackView3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            stackView.widthAnchor.constraint(equalTo: stackView2.widthAnchor)
        ])
        
    }
    
    func configueCell() {
        selectionStyle = .none
        guard let message = message,
              let converser = converser else { return }
        print(converser.fullname)
        if let url = URL(string: converser.profileImageURL) {
            profileImageView.fetchImage(url: url)
        }
        converserLabel.text = converser.fullname
        messageTextLabel.text = message.body
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        timestampLabel.text = formatter.string(from: message.timestamp)
        
    }
    
    
}
