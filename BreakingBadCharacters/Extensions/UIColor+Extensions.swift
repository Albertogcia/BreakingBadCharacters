//
//  UIColor+Extensions.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import UIKit

extension UIColor{
    public class var primaryColor: UIColor{
        return UIColor(named: "primaryColor") ?? .black
    }
    public class var primaryLightColor: UIColor{
        return UIColor(named: "primaryLightColor") ?? .black
    }
    public class var secondaryColor: UIColor{
        return UIColor(named: "secondaryColor") ?? .black
    }
    public class var accentColor: UIColor{
        return UIColor(named: "accentColor") ?? .black
    }
}
