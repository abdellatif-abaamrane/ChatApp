//
//  UserCell.swift
//  Twitter
//
//  Created by macbook-pro on 16/05/2020.
//

import UIKit


class UserCell : UITableViewCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupBackgroud(for: state)
    }
    
    func setupBackgroud(for state: UICellConfigurationState) {
        guard var configuration = self.backgroundConfiguration?.updated(for: state)  else { return }
        (self.contentConfiguration as! UIListContentConfiguration).image?.averageColor({ color in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    configuration.strokeColor = color ?? .clear
                    self.backgroundConfiguration = configuration
                }
            }
        })
                
        }

}

extension UICellConfigurationState {
    var isNormal: Bool {
        !self.isDisabled && !self.isFocused && !self.isHighlighted && !self.isSelected
    }
}
