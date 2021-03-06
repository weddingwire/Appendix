//
//  UIColor+Appendix.swift
//  Appendix
//
//  Created by Wesley Cope on 6/29/15.
//  Copyright (c) 2015 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    public convenience init(hexString: String, alpha: Float) {
        var hex = hexString
        
        if hex.hasPrefix("#") {
            hex = hex.substringFromIndex(hex.startIndex.advancedBy(1))
        }
        
        assert(hex.characters.count == 6 || hex.characters.count == 3)
        
        if hex.characters.count == 3 {
            let red   = hex.substringToIndex(hex.startIndex.advancedBy(1))
            let green = hex.substringWithRange(hex.startIndex.advancedBy(1)..<hex.startIndex.advancedBy(2))
            let blue  = hex.substringFromIndex(hex.startIndex.advancedBy(2))
            
            hex = red + red + green + green + blue + blue
        }
        
        let red      = hex.substringToIndex(hex.startIndex.advancedBy(2))
        let green    = hex.substringWithRange(hex.startIndex.advancedBy(2)..<hex.startIndex.advancedBy(4))
        let blue     = hex.substringWithRange(hex.startIndex.advancedBy(4)..<hex.startIndex.advancedBy(6))
        
        var redInt:   CUnsignedInt = 0
        var greenInt: CUnsignedInt = 0
        var blueInt:  CUnsignedInt = 0
        
        NSScanner(string: red).scanHexInt(&redInt)
        NSScanner(string: green).scanHexInt(&greenInt)
        NSScanner(string: blue).scanHexInt(&blueInt)
        
        self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
    }
    
    public convenience init(hexString: String) {
        self.init(hexString: hexString, alpha:1)
    }
    
    public class func RGBA(r: Int, g: Int, b: Int, a: Float) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a))
    }
    
    public class func RGB(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }

    public class func randomColor() -> UIColor {
        func randomVal() -> CGFloat {
            return CGFloat(random())/CGFloat(RAND_MAX)
        }
        
        return UIColor(red: randomVal(), green: randomVal(), blue: randomVal(), alpha: 1.0)
    }
    
// MARK: - methods
    public func changeAlpha(to:CGFloat) -> UIColor {
        return self.colorWithAlphaComponent(to)
    }
    
// MARK: - Getters
    public var colorSpaceModel:CGColorSpaceModel {
        get {
            return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor))
        }
    }

    public var usesMonochromeColorSpace:Bool {
        get {
            return self.colorSpaceModel.rawValue == CGColorSpaceModel.Monochrome.rawValue
        }
    }

    var usesRGBColorspace:Bool {
        get {
            return self.colorSpaceModel.rawValue == CGColorSpaceModel.RGB.rawValue
        }
    }
    
    public var canProvideRGBComponents:Bool {
        get {
            switch self.colorSpaceModel.rawValue {
            case CGColorSpaceModel.RGB.rawValue:
                return true
                
            case CGColorSpaceModel.Monochrome.rawValue:
                return true
                
            default:
                return false
            }
        }
    }
    
    public var red:CGFloat {
        get {
            assert(self.canProvideRGBComponents, "Must be an RGB color to use .red")
            
            var red:CGFloat = 0
            
            switch self.colorSpaceModel.rawValue {
                case CGColorSpaceModel.RGB.rawValue:
                    self.getRed(&red, green: nil, blue: nil, alpha: nil)
                break
                
                case CGColorSpaceModel.Monochrome.rawValue:
                    self.getWhite(&red, alpha: nil)
                break
                
            default:
                break
            }
            
            return red
        }
    }

    public var green:CGFloat {
        get {
            assert(self.canProvideRGBComponents, "Must be an RGB color to use .green")
            
            var green:CGFloat = 0
            
            switch self.colorSpaceModel.rawValue {
            case CGColorSpaceModel.RGB.rawValue:
                self.getRed(nil, green: &green, blue: nil, alpha: nil)
                break
                
            case CGColorSpaceModel.Monochrome.rawValue:
                self.getWhite(&green, alpha: nil)
                break
                
            default:
                break
            }
            
            return green
        }
    }

    public var blue:CGFloat {
        get {
            assert(self.canProvideRGBComponents, "Must be an RGB color to use .green")
            
            var blue:CGFloat = 0
            
            switch self.colorSpaceModel.rawValue {
            case CGColorSpaceModel.RGB.rawValue:
                self.getRed(nil, green: nil, blue: &blue, alpha: nil)
                break
                
            case CGColorSpaceModel.Monochrome.rawValue:
                self.getWhite(&blue, alpha: nil)
                break
                
            default:
                break
            }
            
            return blue
        }
    }
    
    public var white:CGFloat {
        get {
            assert(self.canProvideRGBComponents, "Must be an RGB color to use .green")
            
            var white:CGFloat = 0
            
            self.getWhite(&white, alpha: nil)
            
            return white
        }
    }
    
    public var alpha:CGFloat {
        get {
            var alpha:CGFloat = 0
            
            self.getWhite(nil, alpha: &alpha)
            
            return alpha
        }
    }
}











