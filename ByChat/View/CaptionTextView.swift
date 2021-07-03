//
//  CaptionTextView.swift
//  ByChat
//
//  Created by macbook-pro on 26/05/2020.
//
import UIKit
class CaptionTextView: UITextView {
    let placeholderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.tag = 1
        label.textColor = .darkGray
        return label
    }()
    

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backgroundColor = .white
        if let label = viewWithTag(1) {
            label.removeFromSuperview()
        }
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: textContainerInset.top),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: textContainerInset.top),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textContainerInset.left+4)])
        contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

    }
    

}

