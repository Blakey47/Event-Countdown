//
//  File.swift
//  Event Countdown
//
//  Created by Darragh Blake on 06/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showEmptyStateView(with message: String, in view: UIView) -> UIView{
        let emptyStateView = ECEmptyStateView(message: message)
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 100
        
        NSLayoutConstraint.activate([
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.heightAnchor.constraint(equalToConstant: view.bounds.height / 2 + padding)
        ])
        
        return emptyStateView
    }
    
}
