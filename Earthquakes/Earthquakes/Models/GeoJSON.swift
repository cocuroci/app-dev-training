//
//  GeoJSON.swift
//  Earthquakes-iOS
//
//  Created by Andre on 16/02/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

struct GeoJSON: Decodable {
    private enum RootCondingKeys: String, CodingKey {
        case features
    }

    private enum FeatureCodingKeys: String, CodingKey {
        case properties
    }

    private(set) var quakes = [Quake]()

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCondingKeys.self)
        var featuresContainer = try rootContainer.nestedUnkeyedContainer(forKey: .features)

        while !featuresContainer.isAtEnd {
            let propertiesContainer = try featuresContainer.nestedContainer(keyedBy: FeatureCodingKeys.self)

            if let properties = try? propertiesContainer.decode(Quake.self, forKey: .properties) {
                quakes.append(properties)
            }
        }
    }
}
