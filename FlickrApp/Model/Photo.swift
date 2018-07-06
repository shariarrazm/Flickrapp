//
//  Photo.swift
//  FlickrApp
//
//  Created by Shariar Razm1 on 2018-06-22.
//  Copyright © 2018 Shariar Razm. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
class Photo: Mappable {
    //var id: Int?
    var title: String?
    var url_o: String?
    var owner: String?
    init(title: String, url_o: String,owner: String) {
        self.title = title
        self.url_o = url_o
        self.owner = owner
    }
    
    init() {
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title <- map["title"]
        url_o <- map["url_o"]
        owner <- map["owner"]
        if url_o == nil {
            url_o = ""
        }
    }
}
