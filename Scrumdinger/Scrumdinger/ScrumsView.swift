//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Andre on 13/12/22.
//

import SwiftUI

struct ScrumsView: View {
    let scrums: [DailyScrum]
    var body: some View {
        List {
            ForEach(scrums) { scrum in
                NavigationLink(value: scrum) {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
            }
        }
        .navigationTitle("Daily Scrums")
        .toolbar {
            Button(action: {}) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")
        }
        .navigationDestination(for: DailyScrum.self) { scrum in
            DetailView(scrum: scrum)
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScrumsView(scrums: DailyScrum.sampleData)
        }
    }
}
