//
//  EventOverviewVC.swift
//  Event Countdown
//
//  Created by Darragh Blake on 04/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

protocol EventOverviewVCDelegate: class {
    func didTapSaveButton(event: Event)
    func didTapCloseButton()
}

class EventOverviewVC: UIViewController {

    @IBOutlet weak var eventBackgroundImage: UIImageView!
    @IBOutlet weak var eventNameButton: UIButton!
    @IBOutlet weak var eventCountdownLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var eventOverviewVCDelegate: EventOverviewVCDelegate!
    var eventCountdownDay = Date()
    var eventCountdownTime = Date()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        saveButton.isUserInteractionEnabled = false
        saveButton.setTitleColor(.systemGray, for: .normal)
    }

    @IBAction func eventCloseButtonTapped(_ sender: Any) {
        eventOverviewVCDelegate.didTapCloseButton()
        dismiss(animated: true)
    }
    
    @IBAction func changeImageButtonTapped(_ sender: Any) {
        showImagePickerController()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let image = eventBackgroundImage.image!
        let event = Event(eventName: eventNameButton.currentTitle ?? "Event Name", eventCountdownDay: eventCountdownDay, eventBackgroundImage: image, eventCountdownTime: eventCountdownTime)
        eventOverviewVCDelegate.didTapSaveButton(event: event)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eventNameButtonTapped(_ sender: Any) {
        let eventDetailsVC = storyboard?.instantiateViewController(identifier: "EventDetailsVC") as! EventDetailsVC
        eventDetailsVC.eventDetailsVCDelegate = self
        present(eventDetailsVC, animated: true, completion: nil)
    }
    
}


// MARK: Image Picker Controller

extension EventOverviewVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            }
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.eventBackgroundImage.image = originalImage
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}


// MARK: Delegate Impl

extension EventOverviewVC: EventDetailsVCDelegate {
    func didTapSaveDetailsButton(event: Event) {
        guard let countdownTime = event.eventCountdownTime else {return}
        
        eventCountdownDay = event.eventCountdownDay
        eventCountdownTime = countdownTime
        
        saveButton.isUserInteractionEnabled = true
        
        DispatchQueue.main.async {
            self.saveButton.setTitleColor(.white, for: .normal)
            self.eventNameButton.setTitle(event.eventName, for: .normal)
        }
    }
}
