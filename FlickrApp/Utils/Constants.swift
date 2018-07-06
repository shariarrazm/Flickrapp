//
//  Constants.swift
//  FlickrApp
//
//  Created by Shariar Razm1 on 2018-06-22.
//  Copyright © 2018 Shariar Razm. All rights reserved.
//

import Foundation
class Constants {
    static let kAppName = "FlickrApp"
    static let kGetPhotoURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=c5e3f376f8e523016a1290314bd71116&format=json&nojsoncallback=1&per_page=10&extras=url_o&text="
    
    
    static let kGetPublicPhotoURL = "https://api.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=c5e3f376f8e523016a1290314bd71116&format=json&nojsoncallback=1&user_id="
    
    
    //Image constants
    static let kNoImage = "NoImage"
    
    
    //Loader Constants
    static let kLoading = "Loading"
}
