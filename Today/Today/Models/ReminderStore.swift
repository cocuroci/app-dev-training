//
//  ReminderStore.swift
//  Today
//
//  Created by Andre on 13/02/23.
//

import EventKit
import Foundation

final class ReminderStore {
    static let shared = ReminderStore()
    private let ekStore = EKEventStore()

    var isAvaliable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }

    func requestAccess() async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .notDetermined:
            let accessGranted = try await ekStore.requestAccess(to: .reminder)
            guard accessGranted else { throw TodayError.accessDenied }
        case .restricted:
            throw TodayError.accessRestricted
        case .denied:
            throw TodayError.accessDenied
        case .authorized:
            return
        @unknown default:
            throw TodayError.unknown
        }
    }

    func readAll() async throws -> [Reminder] {
        guard isAvaliable else {
            throw TodayError.accessDenied
        }

        let predicate = ekStore.predicateForReminders(in: nil)
        let ekReminders = try await ekStore.reminders(matching: predicate)
        let reminders: [Reminder] = try ekReminders.compactMap { ekReminder in
            do {
                return try Reminder(with: ekReminder)
            } catch TodayError.reminderHasNoDueDate {
                return nil
            }
        }

        return reminders
    }
}
