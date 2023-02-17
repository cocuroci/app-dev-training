//
//  CacheEntryObject.swift
//  Earthquakes-iOS
//
//  Created by Andre on 17/02/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

final class CacheEntryObject {
    let entry: CacheEntry

    init(entry: CacheEntry) {
        self.entry = entry
    }
}

enum CacheEntry {
    case inProgress(Task<QuakeLocation, Error>)
    case ready(QuakeLocation)
}
