//
//  JSONInitializable.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/19/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONInitializable {
    init?(json: JSON)
}
