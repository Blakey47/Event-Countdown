//
//  Event.swift
//  Event Countdown
//
//  Created by Darragh Blake on 03/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

struct Event: Hashable {
    
    var eventName: String
    var eventCountdownDay: Date
    var eventBackgroundImage: UIImage?
    var eventCountdownTime: Date?
    
    init(eventName: String, eventCountdownDay: Date, eventCountdownTime: Date) {
        self.eventName = eventName
        self.eventCountdownDay = eventCountdownDay
        self.eventCountdownTime = eventCountdownTime
    }
    
    init(eventName: String, eventCountdownDay: Date, eventBackgroundImage: UIImage, eventCountdownTime: Date) {
        self.eventName = eventName
        self.eventCountdownDay = eventCountdownDay
        self.eventBackgroundImage = eventBackgroundImage
        self.eventCountdownTime = eventCountdownTime
    }
    
}
