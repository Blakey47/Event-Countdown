//
//  AddEventVC.swift
//  Event Countdown
//
//  Created by Darragh Blake on 04/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

class EventDetailsVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        datePicker.setValue(UIColor.white, forKey: "textColor")
        timePicker.setValue(UIColor.white, forKey: "textColor")
        saveButton.layer.cornerRadius = 10
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
        dismiss(animated: true)
    }
    
}
