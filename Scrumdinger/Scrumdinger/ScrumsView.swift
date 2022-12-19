//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Andre on 13/12/22.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]

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
            DetailView(scrum: binding(for: scrum))
        }
    }

    private func binding(for scrum: DailyScrum) -> Binding<DailyScrum> {
        Binding {
            guard let scrumIndex = scrums.firstIndex(where: { $0.id == scrum.id }) else {
                fatalError("Can't find scrum in array")
            }
            return scrums[scrumIndex]
        } set: { value in
            guard let scrumIndex = scrums.firstIndex(where: { $0.id == scrum.id }) else {
                fatalError("Can't find scrum in array")
            }
            return scrums[scrumIndex] = value
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScrumsView(scrums: .constant(DailyScrum.sampleData))
        }
    }
}
