//
//  DubrovnikCardFont.swift
//  Dubrovnik Card
//
//  Created by Andrej Saric on 10/05/15.
//  Copyright (c) 2015 Andrej Saric. All rights reserved.
//

import Foundation
import UIKit
/**
Class that allows easier use of custom fonts
*/
class DubrovnikCardFont {
    /**
    Gives utf8 string for icon
    
    :returns: String
    */
    class var explore: String { return "\u{E800}" }
    class var map: String { return "\u{E801}" }
    class var buy: String { return "\u{E802}" }
    class var visit: String { return "\u{E803}" }
    
    /**
    Creates UIFont with custom font size
    
    -Input font size
    
    :param: font size
    
    :returns: UIFont object
    */
    class func getFont(size:CGFloat) -> UIFont {
        return UIFont(name: "dbkcardfont", size: size)!
    }
}