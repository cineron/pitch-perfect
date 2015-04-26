//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Cineron on 4/23/15.
//  Copyright (c) 2015 Cineron. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    //Add an initializer to this class to initialize these properties
    init(filePath: NSURL, title: String) {
    self.filePathUrl = filePath
    self.title = title
    }
    
}
