//
//  MessageCellViewModel.swift
//  ByChat
//
//  Created by macbook-pro on 27/05/2020.
//

import UIKit


class MessageCellViewModel {
    let cell : MessageCell
    let message: Message
    
    init(cell:MessageCell,message:Message) {
        self.cell = cell
        self.message = message
    }
    
    func configueCell() {
        if let url = URL(string: message.sender.profileImageURL) {
            cell.profileImageView.fetchImage(url: url)
        }
        cell.contentLabel.text = message.body
    }
    
}
