//
//  QuakeLocation.swift
//  Earthquakes-iOS
//
//  Created by Andre on 16/02/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

struct QuakeLocation: Decodable {
    var latitude: Double { properties.products.origin.first?.properties.latitude ?? 0.0 }
    var longitude: Double { properties.products.origin.first?.properties.longitude ?? 0.0 }

    private var properties: RootProperties

    init(latitude: Double, longitude: Double) {
        self.properties = .init(
            products: .init(origin: [.init(properties: .init(latitude: latitude, longitude: longitude))])
        )
    }

    struct RootProperties: Decodable {
        var products: Products
    }

    struct Products: Decodable {
        var origin: [Origin]
    }

    struct Origin: Decodable {
        var properties: OriginProperties
    }

    struct OriginProperties {
        var latitude: Double
        var longitude: Double
    }
}

extension QuakeLocation.OriginProperties: Decodable {
    private enum OriginPropertiesCodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OriginPropertiesCodingKeys.self)
        let longitude = try container.decode(String.self, forKey: .longitude)
        let latitude = try container.decode(String.self, forKey: .latitude)
        guard let longitude = Double(longitude),
              let latitude = Double(latitude) else { throw QuakeError.missingData }
        self.longitude = longitude
        self.latitude = latitude
    }
}
