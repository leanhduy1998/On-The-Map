//
//  StudentsDatas.swift
//  On The Map
//
//  Created by Duy Le on 7/17/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import Foundation
import MapKit


class StudentDataSource {
    var studentData = [StudentInformation]()
    static let sharedInstance = StudentDataSource()
    private init() {} //This prevents others from using the default '()' initializer for this class.
}
