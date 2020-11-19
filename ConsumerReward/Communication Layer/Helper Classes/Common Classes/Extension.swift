
//  Created by yuchen liu on 4/24/16.
//  Copyright © 2016 Recruit Lifestyle Co., Ltd. All rights reserved.

import UIKit
import AVKit

enum ColorType: String {
    case blue = "20aee5"
    case textColor = "000000"
    case darkGreyColor = "c8c7cc"
    case circleBackColor = "F9F9F9"
    case lightGreyColor = "666666"
    case lightBlueColor = "B7C6E0"
    case blueSelectedColor = "0088FF"
    case darkBlueColor = "0C1524"
    case appThemeColor = "112341"
    case nonEditableTF = "5b687f"
    case blueLineSelectedColor = "1A3055"
}

extension UIColor {
    
    class func hexStr(_ hexStr: String) -> UIColor {
        return UIColor.hexStr(hexStr, alpha: 1)
    }
    
    class func color(_ hexColor: ColorType) -> UIColor {
        return UIColor.hexStr(hexColor.rawValue, alpha: 1.0)
    }
    
    class func hexStr(_ str: String, alpha: CGFloat) -> UIColor {
        let hexStr = str.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red: r, green: g, blue: b , alpha: alpha)
        } else {
            print("Invalid hex string")
            return .white
        }
    }
    class func textFieldBoarderHighlightedColor() -> UIColor {
        return UIColor(red: 41.0/255, green: 121.0/255, blue: 252.0/255, alpha: 1.0)
    }
}

extension UIButton {
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = self.frame
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = 8.0
        //self.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyGradient(colors: [CGColor], cornerRadius: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        gradientLayer.frame = self.bounds
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.opacity = 0.5
        //self.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyGradient(colors: [CGColor], cornerRadius: CGFloat, width: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: width, height: self.bounds.size.height)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.opacity = 0.5
        //self.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension UIView {
    func applyGradientForView(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = self.frame
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = 8.0
        //self.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyGradientView(colors: [CGColor], cornerRadius: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        gradientLayer.frame = self.bounds
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = cornerRadius
        //gradientLayer.opacity = 0.5
        //self.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyGradientView(colors: [CGColor], cornerRadius: CGFloat, width: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 1.0)
        gradientLayer.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: width, height: self.bounds.size.height)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = cornerRadius
        //gradientLayer.opacity = 0.5
        //self.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
//MARK:- DATE FORMATTER
extension Date {
    //"y-MM-dd"
    //"HH:mm:ss" //24-Hour
    //"h:mm a" //12 Hour with AM/PM
    static func CONVERT_DATE_TO_STRING(formatter: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: date as Date)
    }
    //MARK: CONVERT DATE AND TIME TO STRING AS PER CURRENT LOCALE
    var LOCALIZE_TIME_TO_STRING : String {
        return DateFormatter.localizedString(from: self, dateStyle: .none, timeStyle: .short)
    }
    var LOCALIZE_DATE_TO_STRING: String {
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .none)
    }
}
extension Date {
    func offsetFrom(date : Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        /*let seconds = "\(difference.second ?? 0)s"
         let minutes = "\(difference.minute ?? 0)m" + " " + seconds
         let hours = "\(difference.hour ?? 0)h" + " " + minutes
         let days = "\(difference.day ?? 0)d" + " " + hours
         
         if let day = difference.day, day          > 0 { return days }
         if let hour = difference.hour, hour       > 0 { return hours }
         if let minute = difference.minute, minute > 0 { return minutes }
         if let second = difference.second, second > 0 { return seconds }*/
        
        let seconds = (difference.second ?? 0) > 1 ? "\(difference.second ?? 0)secs" : "\(difference.second ?? 0)sec"
        let minutes = (difference.minute ?? 0) > 1 ? "\(difference.minute ?? 0)mins" : "\(difference.minute ?? 0)min"
        let hours = (difference.hour ?? 0) > 1 ? "\(difference.hour ?? 0)hrs" : "\(difference.hour ?? 0)hr"
        let days = (difference.day ?? 0) > 1 ? "\(difference.day ?? 0)days" : "\(difference.day ?? 0)day"
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
}

extension UIView {
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIImagePickerController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
    }
}

extension String {
    
    func labelHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2Attributed?.string ?? ""
    }
    
    
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        return attributedString.string
    }
}

extension UIViewController {
    func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}
extension UICollectionViewCell {
    func resolutionForimage(url: String) -> CGSize {
        let url = URL(string: url)
        var pixelWidth = Int()
         var pixelHeight = Int()
        if let imageSource = CGImageSourceCreateWithURL(url! as CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! Int
                pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Int
//                print("the image width is: \(pixelWidth)")
//                print("the image height is: \(pixelHeight)")
            }
        }
        return CGSize(width: abs(pixelWidth), height: abs(pixelHeight))
    }
}

func formatPriceToTwoDecimalPlace(amount: Float) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    formatter.currencySymbol = "$"
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    let formattedAmount = formatter.string(from: amount as NSNumber)!
    return formattedAmount
}
