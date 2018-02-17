//
//  Entities.swift
//  V_ROOT_IOT
//
//  Created by Andrew on 2/17/18.
//  Copyright © 2018 Alex Vihlayew. All rights reserved.
//

import Foundation

struct VisitsResponse: Codable {
    let visits: [Visit]
    
}

struct Visit: Codable {
    let previewPhotoUID: String
    let uid: String
    let time: UInt64
    
    
    
}

