//
//  CatState.swift
//  BowCats
//
//  Created by Amanda Chaudhary on 11/15/20.
//

import Foundation
import UIKit
import Bow
import BowOptics

// The fields need to be "var" for optics to work

struct CatState {
    var image : UIImage? = nil
    var red = 1.0
    var green = 1.0
    var blue = 1.0
}

extension CatState : AutoLens {}
