//
//  FeedModel.swift
//  QuantsFeed
//
//  Created by Rajesh on 15/08/20.
//  Copyright © 2020 Rajesh. All rights reserved.
//

import Foundation

struct FeedModel : Decodable {
    var feed : [FeedData]?
}

struct FeedData : Decodable {
    
    var id: Int?
    var name: String?
    var image : String?
    var status : String?
    var profilePic : String?
    var timeStamp : String?
    var url : String?
    
}
