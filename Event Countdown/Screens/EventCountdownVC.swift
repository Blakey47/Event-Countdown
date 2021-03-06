//
//  ViewController.swift
//  Event Countdown
//
//  Created by Darragh Blake on 30/01/2020.
//  Copyright © 2020 Darragh Blake. All rights reserved.
//

import UIKit
import CoreData

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
    let message = "You have no Events yet.\nPlease add one."
    
    var events: [Event] = []
    var event: Event!
    var emptyStateView = UIView()
    var managedObjectContext: NSManagedObjectContext!
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
        self.events = CoreDataManager.shared.fetchEvents()
        
        configure()
    }
    
    
    // MARK: Configure UI
    
    func configure() {
        configureCollectionView()
        configureDataSource()
        updateData()
    }
    
    @IBAction func addButtonDidTap(_ sender: Any) {
        let eventOverviewVC = storyboard?.instantiateViewController(identifier: "EventOverviewVC") as! EventOverviewVC
        eventOverviewVC.eventOverviewVCDelegate = self
        present(eventOverviewVC, animated: true, completion: nil)
    }

    func configureEmptyCollectionViewLabel() {
        if events.isEmpty {
            print("Is Empty")
            DispatchQueue.main.async {self.emptyStateView = self.showEmptyStateView(with: self.message, in: self.view)}
        } else {
            print("Is not Empty")
            DispatchQueue.main.async {
                self.emptyStateView.transform = CGAffineTransform(translationX: 1000, y: 0)
                self.emptyStateView.isHidden = true
            }
        }
    }
    
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
    
    func saveData() {
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Could not save data \(error.localizedDescription)")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    

}


// MARK: Delegate Impl

extension EventCountdownVC: EventOverviewVCDelegate {
    
    func didTapSaveButton(event: Event) {
        events.append(event)
        saveData()
        updateData()
        collectionView.reloadData()
    }
    
    func didTapCloseButton() {
        if events.isEmpty {
            DispatchQueue.main.async {
                self.emptyStateView.transform = .identity
            }
        }
    }
    
    func didTapSaveEditButton(event: Event, position: Int) {
        events[position] = event
        saveData()
        updateData()
        collectionView.reloadData()
    }
    
    func didTapDeleteButton(position: Int) {
        if let managedItem = events[position] as? NSManagedObject {
            managedObjectContext.delete(managedItem)
        }
        events.remove(at: position)
        saveData()
        updateData()
        if events.isEmpty {
            emptyStateView.transform = .identity
        }
    }
    
}


// MARK: CollectionView Delegate

extension EventCountdownVC: UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        event = events[indexPath.item]
        let eventOverviewVC = storyboard?.instantiateViewController(identifier: "EventOverviewVC") as! EventOverviewVC
        
        eventOverviewVC.event = event
        eventOverviewVC.eventPosition = indexPath.item
        eventOverviewVC.eventHasValue = true
        eventOverviewVC.eventOverviewVCDelegate = self
        present(eventOverviewVC, animated: true)
    }
}

