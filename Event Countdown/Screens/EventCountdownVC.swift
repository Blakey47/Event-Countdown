//
//  ViewController.swift
//  Event Countdown
//
//  Created by Darragh Blake on 30/01/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

protocol EventCountdownVCDelegate: class{
    func didAddEvent(event: Event)
}

class EventCountdownVC: UIViewController {
    
    enum Section {
        case main
    }
    
    @IBOutlet weak var myEventsLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Event>!
    
    let emptyCollectionViewLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let addEventView = UIView()
    
    var events: [Event] = []
    
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    
    // MARK: Configure UI
    
    func configure() {
        configureEmptyCollectionViewLabel()
        configureCollectionView()
        configureDataSource()
    }
    
    @IBAction func addButtonDidTap(_ sender: Any) {
        #warning("Please update UI")

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
        // Initial CollectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createSingleColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.reuseID)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: myEventsLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createSingleColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let itemWidth = width - (padding * 2)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 300)
        
        return flowLayout
    }
    
    
    
    // MARK: Data Source
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Event>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, event) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseID, for: indexPath) as! EventCell
            cell.set(event: event)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Event>()
        snapshot.appendSections([.main])
        snapshot.appendItems(events)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

}


// MARK: Delegate Impl

extension EventCountdownVC: EventCountdownVCDelegate {
    func didAddEvent(event: Event) {
        events.append(event)
        updateData()
    }
}
