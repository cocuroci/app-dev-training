//
//  ReminderListViewController.swift
//  Today
//
//  Created by Andre on 20/12/22.
//

import UIKit

final class ReminderListViewController: UICollectionViewController {
    var dataSource: DataSource!
    var reminders = Reminder.sampleData

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = listLayout()

        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        updateSnapshot()

        collectionView.dataSource = dataSource
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}
