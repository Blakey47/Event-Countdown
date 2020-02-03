//
//  ViewController.swift
//  Event Countdown
//
//  Created by Darragh Blake on 30/01/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

class EventCountdownVC: UIViewController {
    
    @IBOutlet weak var myEventsLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    
    var timer: Timer?
    var collectionView: UICollectionView!
    
    let emptyCollectionViewLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        configureEmptyCollectionViewLabel()
        configureCurrentDateLabel()
    }
    
    func setupUI() {
        
    }
    
    func configureEmptyCollectionViewLabel() {
        view.addSubview(emptyCollectionViewLabel)
        emptyCollectionViewLabel.text = "You have not created an Event yet. Please add an Event."
        emptyCollectionViewLabel.textAlignment = .center
        emptyCollectionViewLabel.textColor = .white
        emptyCollectionViewLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emptyCollectionViewLabel.lineBreakMode = .byWordWrapping
        emptyCollectionViewLabel.numberOfLines = 0
        emptyCollectionViewLabel.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            emptyCollectionViewLabel.topAnchor.constraint(equalTo: myEventsLabel.bottomAnchor, constant: 100),
            emptyCollectionViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyCollectionViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emptyCollectionViewLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: <#T##CGRect#>, collectionViewLayout: <#T##UICollectionViewLayout#>)
        view.addSubview(collectionView)
        
    }
    
    func configureCurrentDateLabel() {
        let date = NSDate()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date as Date)
        
        DispatchQueue.main.async {
            self.currentDateLabel.text = "\(components.day ?? 0) / \(components.month ?? 0) / \(components.year ?? 0)"
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

}

