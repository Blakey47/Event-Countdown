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
    
    var eventNameLabel = ECTitleLabel(textAlignment: .left, fontSize: 22)
    var eventDistriptionLabel = ECBodyLabel(textAlignment: .left)
    var eventCountdownTimeLabel = ECBodyLabel(textAlignment: .left)
    var eventCountdownDate = DateComponents()
    var eventDueDate = UILabel()
    var eventImageView = ECEventImageView(frame: .zero)
    
    let deleteButton = UIButton()
    let padding: CGFloat = 20
    var allDay: Bool!
    
    var timer: Timer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(event: Event) {
        guard let backgroundImage = event.eventBackgroundImage else {return}
        
        eventNameLabel.text = event.eventName
        eventImageView.image = UIImage(data: backgroundImage)
        allDay = event.allDay
        
        // Setting the Due Date
        let eventDate = event.eventCountdownDay
        let calendar = Calendar.current
        eventCountdownDate = calendar.dateComponents([ .year, .month, .day, .hour, .minute, .second], from: eventDate! )
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
        eventCountdownTimeLabel.text = calculateTimer(for: timeLeft)
        
    }
    
    private func calculateTimer(for timeLeft: DateComponents) -> String {
        
        if timeLeft.day! > 3 {
            return "In \(timeLeft.day!) days"
        } else if timeLeft.day! > 1 {
            return "In \(timeLeft.day!) days, \(timeLeft.hour!) hours and \(timeLeft.minute!) minutes"
        } else if timeLeft.hour! > 1 {
            return "In \(timeLeft.hour!) hours and \(timeLeft.minute!) minutes"
        } else if timeLeft.minute! > 1 {
            return "\(timeLeft.minute!) minutes and \(timeLeft.second!) seconds"
        } else if timeLeft.second! > 1{
            return "\(timeLeft.second!) seconds to go"
        } else if allDay == true && abs(timeLeft.day!) < 1 {
            return "Today"
        } else if abs(timeLeft.day!) > 2 {
            return "\(abs(timeLeft.day!)) days ago"
        } else if abs(timeLeft.day!) > 0 {
            return "\(abs(timeLeft.day!)) days, \(abs(timeLeft.hour!)) hours and \(abs(timeLeft.minute!)) minutes ago"
        } else if abs(timeLeft.hour!) > 0 {
            return "\(abs(timeLeft.hour!)) hours and \(abs(timeLeft.minute!)) minutes ago"
        } else if abs(timeLeft.minute!) > 0 {
            return "\(abs(timeLeft.minute!)) minutes and \(abs(timeLeft.second!)) seconds ago"
        } else if abs(timeLeft.second!) > 30 {
            return "\(abs(timeLeft.second!)) seconds ago"
        } else {
            return "Today"
        }
    }
    
    private func configure() {
        configureEventImageView()
        configureEventNameLabel()
        configureEventCountdownLabel()
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
        
        NSLayoutConstraint.activate([
            eventNameLabel.topAnchor.constraint(equalTo: eventImageView.topAnchor, constant: 8),
            eventNameLabel.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: padding),
            eventNameLabel.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -padding),
            eventNameLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureEventCountdownLabel() {
        eventImageView.addSubview(eventCountdownTimeLabel)
        
        NSLayoutConstraint.activate([
            eventCountdownTimeLabel.bottomAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: -padding),
            eventCountdownTimeLabel.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: padding),
            eventCountdownTimeLabel.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -padding),
            eventCountdownTimeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
