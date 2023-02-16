//
//  HTTPDataDownloader.swift
//  Earthquakes-iOS
//
//  Created by Andre on 16/02/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

let validStatus = 200...299

protocol HTTPDataDownloader {
    func httpData(from: URL) async throws -> Data
}

extension URLSession: HTTPDataDownloader {
    func httpData(from url: URL) async throws -> Data {
        guard let (data, response) = try await data(from: url) as? (Data, HTTPURLResponse),
              validStatus.contains(response.statusCode)
        else {
            throw QuakeError.missingData
        }

        return data
    }
}
