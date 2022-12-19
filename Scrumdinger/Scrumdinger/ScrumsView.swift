//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Andre on 13/12/22.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingNewScrumView = false
    @State private var newScrumData = DailyScrum.Data()
    let saveAction: ()->Void

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
            Button(action: {
                isPresentingNewScrumView.toggle()
            }) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")
        }
        .sheet(isPresented: $isPresentingNewScrumView) {
            NavigationStack {
                DetailEditView(data: $newScrumData)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewScrumView.toggle()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let newScrum = DailyScrum(data: newScrumData)
                                scrums.append(newScrum)
                                isPresentingNewScrumView.toggle()
                            }
                        }
                    }
            }
        }
        .navigationDestination(for: DailyScrum.self) { scrum in
            DetailView(scrum: binding(for: scrum))
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
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
            ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
        }
    }
}
