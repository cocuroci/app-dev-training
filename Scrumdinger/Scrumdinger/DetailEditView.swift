//
//  DetailEditView.swift
//  Scrumdinger
//
//  Created by Andre on 16/12/22.
//

import SwiftUI

struct DetailEditView: View {
    @Binding private var data: DailyScrum.Data
    @State private var newAttendeeName = ""

    init(data: Binding<DailyScrum.Data>) {
        _data = data
    }

    var body: some View {
        Form {
            Section("Meeting Info") {
                TextField("Title", text: $data.title)
                HStack {
                    Slider(value: $data.lengthInMinutes, in: 5...30, step: 1) {
                        Text("Length")
                    }
                    .accessibilityValue("\(Int(data.lengthInMinutes)) minutes")
                    Spacer()
                    Text("\(data.lengthInMinutes.formatted(.number)) minutes")
                        .accessibilityHidden(true)
                }
                ThemePicker(selection: $data.theme)
            }

            Section("Attendees") {
                ForEach(data.attendees) { attendees in
                    Text(attendees.name)
                }
                .onDelete { indices in
                    data.attendees.remove(atOffsets: indices)
                }
                HStack {
                    TextField("New Attendee", text: $newAttendeeName)
                    Button(action: {
                        withAnimation {
                            let attendee = DailyScrum.Attendee(name: newAttendeeName)
                            data.attendees.append(attendee)
                            newAttendeeName = ""
                        }
                    }) {
                        Image(systemName: "plus")
                            .accessibilityLabel("Add attendee")
                    }
                    .disabled(newAttendeeName.isEmpty)
                }
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(.init()))
    }
}
