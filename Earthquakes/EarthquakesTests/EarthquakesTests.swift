//
//  EarthquakesTests.swift
//  EarthquakesTests
//
//  Created by Andre on 16/02/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import XCTest
@testable import Earthquakes

final class EarthquakesTests: XCTestCase {
    var decoder: JSONDecoder!

    override func setUp() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
    }

    func testGeoJSONDecoderDecodesQuake() throws {
        let quake = try decoder.decode(Quake.self, from: testFeature_nc73649170)

        XCTAssertEqual(quake.code, "73649170")

        let expectedSeconds = TimeInterval(1636129710550) / 1000
        let decodedSeconds = quake.time.timeIntervalSince1970

        XCTAssertEqual(expectedSeconds, decodedSeconds, accuracy: 0.00001)
    }

    func testGeoJSONDecoderDecodesGeoJSON() throws {
        let decoded = try decoder.decode(GeoJSON.self, from: testQuakesData)

        XCTAssertEqual(decoded.quakes.count, 6)
        XCTAssertEqual(decoded.quakes[0].code, "73649170")

        let expectedSeconds = TimeInterval(1636129710550) / 1000
        let decodedSeconds = decoded.quakes[0].time.timeIntervalSince1970
        XCTAssertEqual(expectedSeconds, decodedSeconds, accuracy: 0.00001)
    }

    func testQuakeDetailDecoder() throws {
        let decoded = try decoder.decode(QuakeLocation.self, from: testDetail_hv72783692)
        XCTAssertEqual(decoded.latitude, 19.2189998626709, accuracy: 0.00000000001)
    }

    func testClientDoesFetchEarthquakeData() async throws {
        let downloader = TestDownloader()
        let client = QuakeClient(network: downloader)
        let quakes = try await client.quakes

        XCTAssertEqual(quakes.count, 6)
    }
}
