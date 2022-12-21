//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Andre on 21/12/22.
//

import UIKit

extension ReminderListViewController {
    @objc
    func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(with: id)
    }
}
