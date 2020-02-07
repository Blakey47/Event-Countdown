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
        eventNameLabel.text = event.eventName
        eventImageView.image = event.eventBackgroundImage
        
        // Setting the Due Date
        let eventDate = event.eventCountdownDay
        let calendar = Calendar.current
        eventCountdownDate = calendar.dateComponents([ .year, .month, .day, .hour, .minute, .second], from: eventDate )
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
            return "In \(timeLeft.day ?? 0) days"
        } else if timeLeft.day! > 1 {
            return "In \(timeLeft.day ?? 0) days, \(timeLeft.hour ?? 0) hours and \(timeLeft.minute ?? 0) minutes"
        } else if timeLeft.hour! > 1 {
            return "In \(timeLeft.hour ?? 0) hours and \(timeLeft.minute ?? 0) minutes"
        } else if timeLeft.minute! > 1 {
            return "\(timeLeft.minute ?? 0) minutes and \(timeLeft.second ?? 0) seconds"
        } else if timeLeft.second! > 1{
            return "\(timeLeft.second ?? 0) seconds to go"
        } else {
            timer.invalidate()
            return "Today"
        }
    }
    
    private func configure() {
        configureEventImageView()
        configureEventNameLabel()
        configureEventCountdownLabel()
//        configureDeleteButton()
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
    
    private func configureDeleteButton() {
        addSubview(deleteButton)
        
        deleteButton.setBackgroundImage(UIImage(systemName: SFSymbols.close), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),
            deleteButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
