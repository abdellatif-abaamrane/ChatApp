//
//  Utilities.swift
//  Twitter
//
//  Created by macbook-pro on 13/05/2020.
//

import UIKit



class Utilities {
    static func attributedButton(_ firstPart: String,_ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }

    static func makeLayout(type: LayoutType) -> UICollectionViewLayout {
        switch type {
        case .flow:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width , height: 100)
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            return layout
        case .Compositional:
            var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
            configuration.showsSeparators = false
            let layout = UICollectionViewCompositionalLayout.list(using: configuration)
            let layoutConfiguartion = UICollectionViewCompositionalLayoutConfiguration()
            layoutConfiguartion.contentInsetsReference = UIContentInsetsReference.safeArea
            layout.configuration = layoutConfiguartion
            return layout
        }
    }
    enum LayoutType {
        case flow, Compositional
    }
    
    static func configueContentCell(user: User, cell:UITableViewCell, for style: ContentStyle) {
        var contentConfiguration : UIListContentConfiguration
        switch style {
        case .custom:
            contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16)
            contentConfiguration.secondaryTextProperties.alignment = .natural
            contentConfiguration.secondaryTextProperties.adjustsFontForContentSizeCategory = true
            contentConfiguration.secondaryTextProperties.colorTransformer = .preferredTint
            contentConfiguration.secondaryTextProperties.transform = .lowercase
            contentConfiguration.secondaryTextProperties.numberOfLines = 1
            contentConfiguration.textProperties.font = UIFont.boldSystemFont(ofSize: 16)
            contentConfiguration.textProperties.alignment = .natural
            contentConfiguration.textProperties.transform = .lowercase
            contentConfiguration.textProperties.color = .black
            contentConfiguration.textProperties.adjustsFontForContentSizeCategory = true
            contentConfiguration.textProperties.colorTransformer = .preferredTint
            contentConfiguration.textProperties.numberOfLines = 1
            contentConfiguration.prefersSideBySideTextAndSecondaryText = false
            contentConfiguration.axesPreservingSuperviewLayoutMargins = .vertical
            contentConfiguration.textToSecondaryTextVerticalPadding = 6
            contentConfiguration.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            contentConfiguration.imageProperties.reservedLayoutSize = CGSize(width: 50, height: 50)
            contentConfiguration.imageProperties.cornerRadius = 50/2
        case .accompaniedSidebarSubtitleCell:
            contentConfiguration = UIListContentConfiguration.accompaniedSidebarSubtitleCell()
        case .accompaniedSidebarCell:
            contentConfiguration = UIListContentConfiguration.accompaniedSidebarCell()
        case .sidebarSubtitleCell:
            contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
        case .sidebarCell:
            contentConfiguration = UIListContentConfiguration.sidebarCell()
        case .valueCell:
            contentConfiguration = UIListContentConfiguration.valueCell()
        case .subtitleCell:
            contentConfiguration = UIListContentConfiguration.subtitleCell()
        case .cell:
            contentConfiguration = UIListContentConfiguration.cell()
        }
        contentConfiguration.text = user.username
        contentConfiguration.secondaryText = user.fullname
        contentConfiguration.image = UIImage(color: .chatPink)
        if let url = URL(string: user.profileImageURL) {
            NetworkClient.shared.getProfileImage(url: url) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let response = response as? HTTPURLResponse,
                   (200..<300).contains(response.statusCode),
                   let data = data,
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        var configuration = cell.contentConfiguration as! UIListContentConfiguration
                        UIView.animate(withDuration: 0.4) {
                            configuration.image = image
                            cell.contentConfiguration = configuration
                            cell.setNeedsUpdateConfiguration()
                        }
                    }
                }
            }
        }
        
        
        cell.contentConfiguration = contentConfiguration
    }
    static func configueBackgroundCell(cell:UITableViewCell, with style: BackgroundStyle) {
        var backgroundConfiguration : UIBackgroundConfiguration
        switch style {
        case .listAccompaniedSidebarCell:
            backgroundConfiguration = UIBackgroundConfiguration.listAccompaniedSidebarCell()
        case .listGroupedCell:
            backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        case .listPlainCell:
            backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
        case .listSidebarCell:
            backgroundConfiguration = UIBackgroundConfiguration.listSidebarCell()
        case .custom:
            backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        backgroundConfiguration.cornerRadius = 10
        backgroundConfiguration.strokeWidth = 1
        backgroundConfiguration.strokeColor = .chatPink
        backgroundConfiguration.strokeColorTransformer = .preferredTint
        let effect = UIBlurEffect(style: .prominent)
        backgroundConfiguration.visualEffect = effect
        cell.backgroundConfiguration = backgroundConfiguration
    }
    enum ContentStyle {
        case custom, accompaniedSidebarSubtitleCell, accompaniedSidebarCell, sidebarSubtitleCell, sidebarCell, valueCell, subtitleCell, cell
    }
    enum BackgroundStyle {
        case listAccompaniedSidebarCell, listGroupedCell, listPlainCell, listSidebarCell, custom
    }
    enum ContentHeaderStyle {
        case groupedHeader, plainHeader, sidebarHeader, custom
    }
    enum BackgroundHeaderStyle {
        case listPlainHeaderFooter, listGroupedHeaderFooter, listSidebarHeader, custom
    }
    enum ContentFooterStyle {
        case groupedFooter, plainFooter, custom
    }
    enum BackgroundFooterStyle {
        case listPlainHeaderFooter, listGroupedHeaderFooter, custom
    }
    
    
}
