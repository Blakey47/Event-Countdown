//
//  ViewController.swift
//  Event Countdown
//
//  Created by Darragh Blake on 30/01/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit

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
        label.isHidden = true
        return label
    }()
    
    let addEventView = UIView()
    let message = "You have no Countdowns yet. Please add one."
    
    
    var events: [Event] = []
    var emptyStateView = UIView()
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        
        emptyStateView = showEmptyStateView(with: message, in: self.view)
    }
    
    
    // MARK: Configure UI
    
    func configure() {
        configureEmptyCollectionViewLabel()
        configureCollectionView()
        configureDataSource()
    }
    
    @IBAction func addButtonDidTap(_ sender: Any) {
        DispatchQueue.main.async {self.emptyStateView.transform = CGAffineTransform(translationX: 1000, y: 0)}
        
        
        let eventOverviewVC = storyboard?.instantiateViewController(identifier: "EventOverviewVC") as! EventOverviewVC
        eventOverviewVC.eventOverviewVCDelegate = self
        present(eventOverviewVC, animated: true, completion: nil)
    }

    func configureEmptyCollectionViewLabel() {}
    
    func configureCollectionView() {
        // Initial CollectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createSingleColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
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
        configureEmptyCollectionViewLabel()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    

}


// MARK: Delegate Impl

extension EventCountdownVC: EventOverviewVCDelegate {
    
    func didTapSaveButton(event: Event) {
        events.append(event)
        updateData()
    }
    
    func didTapCloseButton() {
        print("Closed")
        if events.isEmpty {
            emptyStateView.transform = .identity
        }
    }
    
    func didTapSaveEditButton(event: Event, position: Int) {
        events[position] = event
        updateData()
    }
    
}


// MARK: CollectionView Delegate

extension EventCountdownVC: UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = events[indexPath.item]
        let eventOverviewVC = storyboard?.instantiateViewController(identifier: "EventOverviewVC") as! EventOverviewVC
        
//        let eventViewController = storyboard?.instantiateViewController(identifier: "EventViewController") as! EventViewController
//
//        eventViewController.event = event
//        eventViewController.eventPosition = indexPath.item
//        eventViewController.eventViewControllerDelegate = self
        
        eventOverviewVC.event = event
        eventOverviewVC.eventPosition = indexPath.item
        eventOverviewVC.eventOverviewVCDelegate = self
        present(eventOverviewVC, animated: true)
    }
    
}


//extension EventCountdownVC: EventViewControllerDelegate {
//
//}
