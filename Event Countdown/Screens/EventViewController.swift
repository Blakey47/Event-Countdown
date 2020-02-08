//
//  EventViewController.swift
//  Event Countdown
//
//  Created by Darragh Blake on 07/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

protocol EventViewControllerDelegate: class {
    func didTapSaveEditButton(event: Event, position: Int)
    func didTapCloseButton()
}

class EventViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var eventName: UIButton!
    @IBOutlet weak var timeLeft: UIButton!
    @IBOutlet weak var eventBackgroundImage: UIImageView!
    
    var event: Event!
    var eventPosition: Int!
    weak var eventViewControllerDelegate: EventViewControllerDelegate!
    
    let eventCountdownVC = EventCountdownVC()
    
    var countdownComponents = DateComponents()
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        eventViewControllerDelegate.didTapSaveEditButton(event: event, position: eventPosition)
        dismiss(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        eventViewControllerDelegate.didTapCloseButton()
        dismiss(animated: true)
    }
    
    @IBAction func eventNameTapped(_ sender: Any) {
        
    }
    
    @IBAction func timeLeftTapped(_ sender: Any) {
    }
    
    @IBAction func changeImageTapped(_ sender: Any) {
        showImagePickerController()
    }
    
    private func configure() {
        eventName.setTitle(event.eventName, for: .normal)
        eventBackgroundImage.image = event.eventBackgroundImage
        
        // Setting the Due Date
        let eventDate = event.eventCountdownDay
        let calendar = Calendar.current
        countdownComponents = calendar.dateComponents([ .year, .month, .day, .hour, .minute, .second], from: eventDate )
        
    }
    
    @objc func runTimer() {
        let userCalendar = Calendar.current
        // Setting the current Date
        let date = Date()
        let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, . second], from: date)
        guard let currentDate = userCalendar.date(from: components) else {return}
        
        // Convert eventCountdownDate to the user's calendar
        guard let eventDate = userCalendar.date(from: countdownComponents) else {return}
        
        // Change the seconds to days, hours, minutes and seconds
        let timeThatIsLeft = userCalendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: eventDate)
        
        // Display Countdown
        timeLeft.setTitle(calculateTimer(for: timeThatIsLeft), for: .normal)
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
    
}


extension EventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            DispatchQueue.main.async {
                self.eventBackgroundImage.image = editedImage
                self.event.eventBackgroundImage = editedImage
            }
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.eventBackgroundImage.image = originalImage
                self.event.eventBackgroundImage = originalImage
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}

