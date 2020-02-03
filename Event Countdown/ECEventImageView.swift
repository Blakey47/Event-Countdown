//
//  ECEventImageView.swift
//  Event Countdown
//
//  Created by Darragh Blake on 03/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

class ECEventImageView: UIImageView {
    
    var placeholderImage = UIImage(named: "CelebrationPlaceholder")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
