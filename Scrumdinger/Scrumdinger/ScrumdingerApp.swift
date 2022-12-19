//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Andre on 12/12/22.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ScrumsView(scrums: $scrums)
            }
        }
    }
}
