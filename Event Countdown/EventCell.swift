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
    var eventCountdownDate = DateComponents()
    var eventDueDate = UILabel()
    var eventImageView = ECEventImageView(frame: .zero)
    
    let padding: CGFloat = 20
    var timer: Timer!
    
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
        
        // Setting the Due Date
        let eventDate = event.date
        let calendar = Calendar.current
        eventCountdownDate = calendar.dateComponents([ .year, .month, .day, .hour, .minute, .second], from: eventDate as Date)
        eventDueDate.text = "Year: \(eventCountdownDate.year ?? 0) Month: \(eventCountdownDate.month ?? 0) Day: \(eventCountdownDate.day ?? 0) Hour: \(eventCountdownDate.hour ?? 0) Minute: \(eventCountdownDate.minute ?? 0)"
    }
    
    @objc func runTimer() {
        let userCalendar = Calendar.current
        // Setting the current Date
        let date = Date()
        let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, . second], from: date)
        guard let currentDate = userCalendar.date(from: components) else {return}
        
        // Convert eventCountdownDate to the user's calendar
        guard let eventDate = userCalendar.date(from: eventCountdownDate) else {return}
        
        // Change the seconds to days, hours, minutes and seconds
        let timeLeft = userCalendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: eventDate)
        
        // Display Countdown
        eventCountdownTimeLabel.text = "\(timeLeft.day ?? 0)d \(timeLeft.hour ?? 0)h \(timeLeft.minute ?? 0)m \(timeLeft.second ?? 0)s"
    }
    
    private func configure() {
        configureEventImageView()
        configureEventNameLabel()
        
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
    
    private func configureEventDescriptionLabel() {
        eventImageView.addSubview(eventDistriptionLabel)
        eventDistriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDistriptionLabel.backgroundColor = .blue
        eventDistriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        eventDistriptionLabel.textColor = .white
        eventDistriptionLabel.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            eventDistriptionLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: padding),
            eventDistriptionLabel.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: padding),
            eventDistriptionLabel.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -padding),
            eventDistriptionLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
