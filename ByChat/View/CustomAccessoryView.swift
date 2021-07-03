//
//  CustomAccessoryView.swift
//  ByChat
//
//  Created by macbook-pro on 26/05/2020.
//

import UIKit

protocol CustomAccessoryViewDelegate: AnyObject {
    func didBeginEdit(accessoryView:CustomAccessoryView)
    func sendMassage(message:String, accessoryView:CustomAccessoryView)

}
class CustomAccessoryView: UIView {
    //MARK: - Properties
    lazy var textView : CaptionTextView = {
        let tv = CaptionTextView()
        tv.delegate = self
        tv.placeholderLabel.text = "Enter your message"
        tv.layer.cornerRadius = 8
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = true
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "paperplane.circle.fill")?.withConfiguration(configuration), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    weak var delegate : CustomAccessoryViewDelegate?
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.shadowColor = UIColor.blackUber.cgColor
        layer.shadowRadius = 1.2
        layer.shadowOpacity = 0.5
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: bounds.size), cornerRadius: 10).cgPath
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        addSubview(sendButton)
        addSubview(textView)
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor),
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            //textView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    @objc func handleSendMessage() {
        guard let message = textView.text,
              message.trimmingCharacters(in: .whitespacesAndNewlines) != "" else { return }
        delegate?.sendMassage(message: message, accessoryView: self)
        textView.text = ""
        UIView.animate(withDuration: 0.4) {
            self.textView.placeholderLabel.alpha = 1
        }
        textView.resignFirstResponder()
    }
    //MARK: - API
    
    //MARK: - Helpers
}
extension CustomAccessoryView : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.didBeginEdit(accessoryView: self)
    }
    func textViewDidChange(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 4, options: .allowAnimatedContent, animations: {
            self.textView.placeholderLabel.alpha = !textView.text.isEmpty ?  0 : 1
        }, completion: nil)
        if textView.contentSize.height >=  textView.bounds.height {
            textView.setContentOffset(CGPoint(x: 0, y: abs(textView.contentSize.height-textView.bounds.height)), animated: true)
        }
        
    }
    
}
