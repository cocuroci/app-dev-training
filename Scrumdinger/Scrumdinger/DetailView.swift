//
//  DetailView.swift
//  Scrumdinger
//
//  Created by Andre on 16/12/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var scrum: DailyScrum
    @State private var isPresentingEditView = false
    @State private var isPresentingMeetingView = false
    @State private var data = DailyScrum.Data()

    var body: some View {
        List {
            Section("Meeting Info") {
                Button(action: {
                    isPresentingMeetingView.toggle()
                }) {
                    Label("Start meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(scrum.lengthInMinutes) minutes")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(scrum.theme.name)
                        .padding(4)
                        .foregroundColor(scrum.theme.accentColor)
                        .background(scrum.theme.mainColor)
                        .cornerRadius(4)

                }
                .accessibilityElement(children: .combine)
            }

            Section("Attendees") {
                ForEach(scrum.attendees) { attendee in
                    Label(attendee.name, systemImage: "person")
                }
            }
            Section("History") {
                if scrum.history.isEmpty {
                    Label("No meetings yet", systemImage: "calendar.badge.exclamationmark")
                }
                ForEach(scrum.history) { history in
                    NavigationLink(destination: HistoryView(history: history)) {
                        HStack {
                            Image(systemName: "calendar")
                            Text(history.date, style: .date)
                        }
                    }
                }
            }
        }
        .navigationTitle(scrum.title)
        .toolbar {
            Button("Edit") {
                isPresentingEditView.toggle()
                data = scrum.data
            }
        }
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                DetailEditView(data: $data)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView.toggle()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView.toggle()
                                scrum.update(from: data)
                            }
                        }
                    }
                    .navigationTitle(scrum.title)
            }
        }
        .sheet(isPresented: $isPresentingMeetingView) {
            MeetingView(scrum: $scrum)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(scrum: .constant(DailyScrum.sampleData[0]))
        }
    }
}
