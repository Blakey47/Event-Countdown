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
    var eventCountdownTimeLabel = UILabel()
    var eventCountdownDate = Date()
    var eventImageView = ECEventImageView(frame: .zero)
    
    let padding: CGFloat = 20
    let timer: Timer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(event: Event) {
        eventNameLabel.text = event.name
        eventDistriptionLabel.text = event.description
        eventCountdownDate = event.date
    }
    
    @objc func runTimer() {
        // Setting the current Date
        let date = NSDate()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([ .year, .month, .day, .hour, .minute, .second], from: date as Date)
        let currentDate = calendar.date(from: components)
        let userCalendar = Calendar.current
    }
    
    private func configure() {
        configureEventImageView()
    }
    
    private func configureEventImageView() {
        addSubview(eventImageView)
        
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: topAnchor),
            eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            eventImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            eventImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureEventNameLabel() {
        eventImageView.addSubview(eventNameLabel)
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        eventNameLabel.textAlignment = .center
        eventNameLabel.textColor = .white
        eventNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        eventNameLabel.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            eventNameLabel.topAnchor.constraint(equalTo: eventImageView.topAnchor, constant: 8),
            eventNameLabel.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: padding),
            eventNameLabel.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -padding),
            eventNameLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func configureCountdownTimer() {
        
    }
}
