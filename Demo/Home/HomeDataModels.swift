//
//  HomeDataModels.swift
//  Demo
//
//  Created by Kajal Luthra on 15/3/21.
//

import Foundation

struct Welcome: Decodable {
    let items: [Item]
}
struct APIInfo: Codable {
    let status: String
}
struct Item: Codable {
    let cameras: [Camera]
}
struct Camera: Codable {
    let image: String
    let location: Location
}
struct ImageMetadata: Codable {
    let height, width: Int
    let md5: String
}
struct Location: Codable {
    let latitude, longitude: Double
}
