//
//  Entities.swift
//  V_ROOT_IOT
//
//  Created by Andrew on 2/17/18.
//  Copyright © 2018 Alex Vihlayew. All rights reserved.
//

import UIKit

struct VisitsResponseApiStruct: Codable {
    let visits: [VisitPreviewApiStruct]
}

struct VisitPreviewApiStruct: Codable {
    let previewPhotoUID: String
    let uid: String
    let number: Int
    let timestamp: UInt64
}

struct VisitApiStruct: Codable {
    let uid: String
    let number: Int
    let timestamp: UInt64
    let photoUIDs: [String]
}

struct Visit {
    let uid: String
    let number: Int
    let date: Date
    let photos: [UIImage]
}
