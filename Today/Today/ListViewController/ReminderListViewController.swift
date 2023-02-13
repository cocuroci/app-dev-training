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
    var listStyle = ReminderListStyle.today

    var filteredReminders: [Reminder] {
        reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }.sorted {
            $0.dueDate < $1.dueDate
        }
    }

    var listStyleSegmentedControl = UISegmentedControl(items: ReminderListStyle.allCases.map { $0.name })

    var headerView: ProgressHeaderView?
    var progress: CGFloat {
        let chunkSize = 1.0 / CGFloat(filteredReminders.count)
        let progress = filteredReminders.reduce(0.0) {
            let chunk = $1.isComplete ? chunkSize : 0
            return $0 + chunk
        }
        return progress
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = listLayout()
        collectionView.backgroundColor = .todayGradientFutureBegin

        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration(
            elementKind: ProgressHeaderView.elementKind,
            handler: supplementaryRegistrationHandler
        )

        dataSource.supplementaryViewProvider = { view, elementKind, indexPath in
            self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didPressAddButton(_:))
        )

        addButton.accessibilityLabel = NSLocalizedString(
            "Add reminder",
            comment: "Add button accessibility label"
        )

        navigationItem.rightBarButtonItem = addButton

        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        navigationItem.titleView = listStyleSegmentedControl
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)

        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }

        updateSnapshot()

        collectionView.dataSource = dataSource
    }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredReminders[indexPath.item].id
        showDetail(for: id)
        return false
    }

    private func showDetail(for id: Reminder.ID) {
        let reminder = reminder(for: id)

        let detailViewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.update(reminder, with: reminder.id)
            self?.updateSnapshot(reloading: [reminder.id])
        }

        navigationController?.pushViewController(detailViewController, animated: true)
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        guard elementKind == ProgressHeaderView.elementKind, let progressHeaderView = view as? ProgressHeaderView else {
            return
        }

        progressHeaderView.progress = progress
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }

        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self ] _, _, completion in
            self?.delete(reminder: id)
            self?.updateSnapshot()
            completion(false)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func supplementaryRegistrationHandler(
        progressView: ProgressHeaderView,
        elementKind: String,
        indexPath: IndexPath
    ) {
        headerView = progressView
    }
}
