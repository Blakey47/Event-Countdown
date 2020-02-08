//
//  AddEventVC.swift
//  Event Countdown
//
//  Created by Darragh Blake on 04/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        createDismissKeyboardTapGesture()
        datePicker.setValue(UIColor.white, forKey: "textColor")
        timePicker.setValue(UIColor.white, forKey: "textColor")
        saveButton.layer.cornerRadius = 10
        
        if event != nil {
            eventNameTextField.text = event.eventName
            datePicker.date = event.eventCountdownDay
        }
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @IBAction func AllDaySelecterToggled(_ sender: Any) {
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
        let dayCount = datePicker.date
        let timeCount = timePicker.date
        let event = Event(eventName: eventNameTextField.text ?? "Event Name", eventCountdownDay: dayCount, eventCountdownTime: timeCount)
        dismiss(animated: true) {
            self.eventDetailsVCDelegate?.didTapSaveDetailsButton(event: event)
        }
    }
    
    @IBAction func eventNameFinishEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}



