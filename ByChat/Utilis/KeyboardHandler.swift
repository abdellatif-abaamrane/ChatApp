//
//  KeyboardHandler.swift
//  ByChat
//
//  Created by macbook-pro on 27/05/2020.
//

import UIKit


class KeyboardHandler {
    var view : UIView
    init(view: UIView) {
        self.view = view
        handleKeyboard()
    }
    func handleKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            let dictionary = notification.userInfo!
            var rect = dictionary[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            print(rect.height)
            rect = self.view.convert(rect, from: nil)
            
            (self.view as! UICollectionView).contentInset = UIEdgeInsets(top: 0, left: 0, bottom: rect.height, right: 0)
            
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
            (self.view as! UICollectionView).contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

}
