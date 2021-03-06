//
//  ECBodyLabel.swift
//  Event Countdown
//
//  Created by Darragh Blake on 03/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

class ECBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    private func configure() {
        textColor = .white
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        font = UIFont.systemFont(ofSize: 20, weight: .bold)
        numberOfLines = 3
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
