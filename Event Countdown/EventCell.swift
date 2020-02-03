//
//  EventCell.swift
//  Event Countdown
//
//  Created by Darragh Blake on 03/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    static let reuseID = "EventCell"
    
    var eventNameLabel = UILabel()
    var eventDistriptionLabel = UILabel()
    var eventDate = Date()
    var eventImageView = UIImageView()
}
