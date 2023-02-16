//
//  QuakesProvider.swift
//  Earthquakes-iOS
//
//  Created by Andre on 16/02/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

@MainActor
final class QuakesProvider: ObservableObject {
    @Published var quakes = [Quake]()

    let client: QuakeClient

    init(client: QuakeClient) {
        self.client = client
    }

    func fetchQuakes() async throws {
        let latestQuakes = try await client.quakes
        quakes = latestQuakes
    }

    func deleteQuakes(atOffsets offsets: IndexSet) {
        quakes.remove(atOffsets: offsets)
    }
}
