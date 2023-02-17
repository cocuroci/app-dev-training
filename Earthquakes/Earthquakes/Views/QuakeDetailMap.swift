//
//  QuakeDetailMap.swift
//  Earthquakes-iOS
//
//  Created by Andre on 17/02/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI
import MapKit

struct QuakeDetailMap: View {
    let location: QuakeLocation
    let tintColor: Color
    private var place: QuakePlace

    @State private var region = MKCoordinateRegion()

    init(location: QuakeLocation, tintColor: Color) {
        self.location = location
        self.tintColor = tintColor
        self.place = .init(location: location)
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [place]) { place in
            MapMarker(coordinate: place.location, tint: tintColor)
        }
        .onAppear {
            withAnimation {
                region.center = place.location
                region.span = .init(latitudeDelta: 1, longitudeDelta: 1)

            }
        }
    }
}

struct QuakePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D

    init(id: UUID = UUID(), location: QuakeLocation) {
        self.id = id
        self.location = .init(latitude: location.latitude, longitude: location.longitude)
    }
}
