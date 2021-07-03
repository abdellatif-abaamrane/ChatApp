//
//  MessageCell.swift
//  ByChat
//
//  Created by macbook-pro on 26/05/2020.
//

import UIKit


class MessageCell : UICollectionViewCell {
    var message: Message? {
        didSet {
            configue()
        }
    }
    var profileImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(color: .chatPink))
        imageView.layer.cornerRadius = 40/2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var contentMessageView : ContentMessageView!
    
    var contentLabel : UILabel {
        get {
            contentMessageView.contentLabel
        }
        set {
            contentMessageView.contentLabel = newValue
        }
    }
    
    private var spacingView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    
    
    private func configue() {
        guard let message = message else { return }
        contentMessageView = ContentMessageView(message: message)
        contentMessageView.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [contentMessageView,spacingView])
        stackView.clipsToBounds = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if message.isMine {
            stackView.alignment = .trailing
        } else {
                stackView.alignment = .leading
        }
        let stackView1 = UIStackView(arrangedSubviews: [profileImageView])
        stackView1.axis = .horizontal
        stackView1.spacing = 0
        stackView1.clipsToBounds = false

        stackView1.alignment = .bottom
        stackView1.distribution = .fillProportionally
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        let stackView2 = UIStackView(arrangedSubviews: [stackView])
        stackView2.axis = .horizontal
        stackView2.spacing = 0
        stackView2.clipsToBounds = false
        stackView2.alignment = .center
        stackView2.distribution = .fillProportionally
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        if message.isMine {
            stackView2.insertArrangedSubview(stackView1, at: stackView2.arrangedSubviews.count)
        } else {
            stackView2.insertArrangedSubview(stackView1, at: 0)
        }
        
        
        let stackView3 = UIStackView(arrangedSubviews: [stackView2])
        stackView3.axis = .vertical
        stackView3.distribution = .fillProportionally
        stackView3.clipsToBounds = false
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        if message.isMine {
            stackView3.alignment = .trailing
        } else {
            stackView3.alignment = .leading
        }
        
        contentView.addSubview(stackView3)
        NSLayoutConstraint.activate([
            contentMessageView.widthAnchor.constraint(lessThanOrEqualTo: stackView3.widthAnchor, multiplier: 0.50),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            spacingView.widthAnchor.constraint(equalTo: contentMessageView.widthAnchor),
            spacingView.heightAnchor.constraint(equalTo: profileImageView.heightAnchor,multiplier: 0.66),
            stackView1.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            stackView1.widthAnchor.constraint(equalTo: profileImageView.widthAnchor),

            stackView3.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,constant: 4),
            stackView3.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,constant: 4),
            stackView3.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,constant: -4),
            stackView3.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
        let viewModel = MessageCellViewModel(cell: self, message: message)
        viewModel.configueCell()
    }
}
