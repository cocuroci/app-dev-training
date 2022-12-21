//
//  ReminderListViewController.swift
//  Today
//
//  Created by Andre on 20/12/22.
//

import UIKit

final class ReminderListViewController: UICollectionViewController {
    private var dataSource: DataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = listLayout()

        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map { $0.title })
        dataSource.apply(snapshot)

        collectionView.dataSource = dataSource
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}
