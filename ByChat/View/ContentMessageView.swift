//
//  ContentMessageView.swift
//  ByChat
//
//  Created by macbook-pro on 27/05/2020.
//

import UIKit


class ContentMessageView: UIView {
    let message : Message
    init(message: Message) {
        self.message = message
        super.init(frame: .zero)
        configueUI()
        isOpaque = false
        clipsToBounds = true
        layer.cornerRadius = 4
        layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    var contentLabel : UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configueUI() {
        addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6)

        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.filter({ $0 is CAShapeLayer }).first?.removeFromSuperlayer()
        let roundingCorners : UIRectCorner
        let pathLine = UIBezierPath()
        if message.isMine {
            roundingCorners = [.topLeft,.topRight,.bottomLeft]
            pathLine.move(to: CGPoint(x: bounds.maxX-14, y: bounds.maxY-20))
            pathLine.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            pathLine.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY-20))
            pathLine.close()
        } else {
            roundingCorners = [.topLeft,.topRight,.bottomRight]
            pathLine.move(to: CGPoint(x: bounds.minX+14, y: bounds.maxY-20))
            pathLine.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            pathLine.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY-20))
            pathLine.close()
        }
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: bounds.width, height: bounds.height-20)), byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: 5, height: 5))
        path.append(pathLine)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.chatPink.cgColor

        self.layer.insertSublayer(layer, at: 0)
    }
    
}
