//
//  Channel.swift
//  Smack
//
//  Created by Rafał Chołody on 22/05/2018.
//  Copyright © 2018 Rafał Chołody. All rights reserved.
//

import Foundation

struct Channel : Decodable {
    public private(set) var channelTitle: String!
    public private(set) var channelDescription: String!
    public private(set) var id: String!
    
}
