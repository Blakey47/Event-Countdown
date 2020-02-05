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
}

class EventOverviewVC: UIViewController {

    @IBOutlet weak var eventBackgroundImage: UIImageView!
    @IBOutlet weak var eventNameButton: UIButton!
    @IBOutlet weak var eventCountdownLabel: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func eventCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            
        }
    }
    
    @IBAction func changeImageButtonTapped(_ sender: Any) {
        showImagePickerController()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        
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
        DispatchQueue.main.async {
            self.eventNameButton.setTitle(event.eventName, for: .normal)
        }
    }
}
