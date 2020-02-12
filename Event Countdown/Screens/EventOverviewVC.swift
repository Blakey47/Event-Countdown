//
//  EventOverviewVC.swift
//  Event Countdown
//
//  Created by Darragh Blake on 04/02/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit
import CoreData

protocol EventOverviewVCDelegate: class {
    func didTapSaveButton(event: Event)
    func didTapSaveEditButton(event: Event, position: Int)
    func didTapDeleteButton(position: Int)
    func didTapCloseButton()
}

class EventOverviewVC: UIViewController {

    @IBOutlet weak var eventBackgroundImage: UIImageView!
    @IBOutlet weak var eventNameButton: UIButton!
    @IBOutlet weak var eventCountdownLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var eventOverviewVCDelegate: EventOverviewVCDelegate!
    var eventCountdownDay = Date()
    var eventCountdownTime = Date()
    
    var event: Event!
    var eventPosition: Int?
    var eventHasValue = false
    var managedObjectContext: NSManagedObjectContext!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
        configure()
    }
    
    func configure() {
        saveButton.isUserInteractionEnabled = false
        saveButton.setTitleColor(.systemGray, for: .normal)
        
        if eventHasValue {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
        
        if event != nil {
            eventNameButton.setTitle(event.eventName, for: .normal)
            if let backgroundImage = UIImage(data: event.eventBackgroundImage!) {
                eventBackgroundImage.image = backgroundImage
            }
        }
    }

    @IBAction func eventCloseButtonTapped(_ sender: Any) {
        eventOverviewVCDelegate.didTapCloseButton()
        dismiss(animated: true)
    }
    
    @IBAction func changeImageButtonTapped(_ sender: Any) {
        showImagePickerController()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let image = eventBackgroundImage.image!.pngData()
        event.eventBackgroundImage = image
                
        if let position = eventPosition {
            eventOverviewVCDelegate.didTapSaveEditButton(event: event, position: position)
        } else {
            eventOverviewVCDelegate.didTapSaveButton(event: event)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let position = eventPosition {
            eventOverviewVCDelegate.didTapDeleteButton(position: position)
            dismiss(animated: true, completion: nil)
        } else {
            print("Nothing to delete")
        }
        
    }
    
    @IBAction func eventNameButtonTapped(_ sender: Any) {
        let eventDetailsVC = storyboard?.instantiateViewController(identifier: "EventDetailsVC") as! EventDetailsVC
        if event != nil {eventDetailsVC.event = event}
        eventDetailsVC.eventDetailsVCDelegate = self
        present(eventDetailsVC, animated: true, completion: nil)
    }
    
    private func saveButtonInteractable() {
        saveButton.isUserInteractionEnabled = true
        
        DispatchQueue.main.async {
            self.saveButton.setTitleColor(.white, for: .normal)
        }
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
        saveButtonInteractable()
        dismiss(animated: true, completion: nil)
    }
}


// MARK: Delegate Impl

extension EventOverviewVC: EventDetailsVCDelegate {
    func didTapSaveDetailsButton(event: Event) {
        self.event = event
        
        saveButtonInteractable()
        
        DispatchQueue.main.async {
            self.eventNameButton.setTitle(event.eventName, for: .normal)
        }
    }
}
