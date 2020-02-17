//
//  AddEventVC.swift
//  Event Countdown
//
//  Created by Darragh Blake on 04/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit
import CoreData

protocol EventDetailsVCDelegate: class {
    func didTapSaveDetailsButton(event: Event)
}

class EventDetailsVC: UIViewController {
    
    weak var eventDetailsVCDelegate: EventDetailsVCDelegate!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var event: Event!
    var allDay = true
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
        configure()
    }
    
    func configure() {
        createDismissKeyboardTapGesture()
        datePicker.setValue(UIColor.white, forKey: "textColor")
        timePicker.setValue(UIColor.white, forKey: "textColor")
        saveButton.layer.cornerRadius = 10
        
        if event != nil {
            eventNameTextField.text = event.eventName
            datePicker.date = event.eventCountdownDay!
        }
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @IBAction func AllDaySelecterToggled(_ sender: Any) {
        allDay.toggle()
        
        if timePicker.isHidden {
            UIView.animate(withDuration: 0.2, animations: {
                self.timePicker.transform = CGAffineTransform(translationX: 0, y: 50)
                self.timePicker.isHidden = false
                self.saveButton.transform = CGAffineTransform(translationX: 0, y: 80)
            }) { (true) in
            }
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.timePicker.isHidden = true
                self.timePicker.transform = .identity
                self.saveButton.transform = .identity
            }) { (true) in
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if event == nil {
            createEvent()
        } else {
            saveChanges()
        }
    }
    
    @IBAction func eventNameFinishEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    private func createEvent() {
        var components = timePicker.calendar.dateComponents([.hour, .minute, .second], from: timePicker.date)
        if allDay == true {
            components.hour = 0
            components.minute = 0
            components.second = 0
        }
        let dayCount = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: components.second!, of: datePicker.date)
        let event = Event(context: managedObjectContext)
        event.eventName = eventNameTextField.text
        event.eventCountdownDay = dayCount
        event.allDay = allDay
        
        
        
        dismiss(animated: true) {
            self.eventDetailsVCDelegate?.didTapSaveDetailsButton(event: event)
        }
    }
    
    private func saveChanges() {
        let components = timePicker.calendar.dateComponents([.hour, .minute, .second], from: timePicker.date)
        let dayCount = Calendar.current.date(bySettingHour: components.hour!, minute: components.minute!, second: components.second!, of: datePicker.date)
        event.eventName = eventNameTextField.text
        event.eventCountdownDay = dayCount
        dismiss(animated: true) {
            self.eventDetailsVCDelegate?.didTapSaveDetailsButton(event: self.event)
        }
    }
}



