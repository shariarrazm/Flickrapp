//
//  PublicPhotos.swift
//  FlickrApp
//
//  Created by Shariar Razm1 on 2018-06-22.
//  Copyright © 2018 Shariar Razm. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
class PublicPhotos: Mappable {
    //var id: Int?
    var id: Int?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    init(title: String, id: Int, owner: String,secret: String, server: String, farm: Int) {
        self.title = title
        self.id = id
        self.owner = owner
        self.secret = owner
        self.server = server
        self.farm = farm
    }
    
    init() {
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        id <- (map["id"], IntTransform())
        owner <- map["owner"]
        secret <- map["secret"]
        server <- map["server"]
        farm <- (map["farm"], IntTransform())
        title <- map["title"]
    }
}

class IntTransform: TransformType {
    typealias Object = Int
    typealias JSON = Int
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let value = value {
            return Int("\(value)")
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        return value
    }
}
