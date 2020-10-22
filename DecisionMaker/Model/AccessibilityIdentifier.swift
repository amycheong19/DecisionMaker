//
//  AccessbilityIdentifier.swift
//  PickrUITests
//
//  Created by Amy Cheong on 21/10/20.
//

import Foundation

enum AI {

    enum PageView {
        static let scrollView = "AI.PageView.scrollView"
        static let close = "AI.PageView.close"
    }

    enum CollectionListView {
        static func collection(at index: Int) -> String {
            "AI.CollectionListView.collection\(index)"
        }
        static let addButton = "AI.CollectionListView.addButton"
        static let editButton = "AI.CollectionListView.editButton"
        static let submitButton = "AI.CollectionListView.submitButton"
        static let nameTextField = "AI.CollectionListView.nameTextField"

    }
    
    enum OptionListView {
        static func option(at index: Int) -> String {
            "AI.OptionListView.option\(index)"
        }
        
        static let pickrButton = "AI.OptionListView.pickrButton"
        static let newOptionButton = "AI.OptionListView.newOptionButton"
    }
    
    enum OptionRowView {
        static let newOptionTextField = "AI.OptionRowView.newOptionTextfield"
    }
    
    enum AlertControlView {
        static let nameValueTextView = "AI.AlertControlView.nameValueTextView"
    }
    
    enum PickedCardView {
        static let likeButton = "AI.PickedCardView.likeButton"
        static let dislikeButton = "AI.PickedCardView.dislikeButton"
        static let infoButton = "AI.PickedCardView.infoButton"
        static let backButton = "AI.PickedCardView.backButton"
        static let dismissButton = "AI.PickedCardView.dismissButton"
    }

}
