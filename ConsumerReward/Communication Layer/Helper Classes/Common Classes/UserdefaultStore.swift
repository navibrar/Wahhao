
import Foundation

struct UserdefaultStore {
    static let USERDEFAULTS = UserDefaults.standard
    
    static func USERDEFAULTS_SET_STRING_KEY(object:String, key:String) -> Void {
        USERDEFAULTS .set(object, forKey: key)
    }
    
    static func USERDEFAULTS_GET_STRING_KEY(key:String) -> String {
        return USERDEFAULTS.object(forKey: key) as? String == nil ? "" : USERDEFAULTS.object(forKey: key) as! String
    }
    
    static func USERDEFAULTS_SET_BOOL_KEY(object:Bool, key:String) -> Void {
        USERDEFAULTS .set(object, forKey: key)
    }
    
    static func USERDEFAULTS_GET_BOOL_KEY(key:String) -> Bool {
        return USERDEFAULTS.object(forKey: key) as? Bool == nil ? false : USERDEFAULTS.object(forKey: key) as! Bool
        
    }
    
    static func USERDEFAULTS_SET_INT_KEY(object:Int, key:String) -> Void {
        USERDEFAULTS .set(object, forKey: key)
    }
    
    static func USERDEFAULTS_GET_INT_KEY(key:String) -> Int {
        return USERDEFAULTS.object(forKey: key) as? Int == nil ? -786 : USERDEFAULTS.object(forKey: key) as! Int
    }
    
    static func USERDEFAULTS_SET_FLOAT_KEY(object:Float, key:String) -> Void {
        USERDEFAULTS .set(object, forKey: key)
    }
    
    static func USERDEFAULTS_GET_FLOAT_KEY(key:String) -> Float {
        return USERDEFAULTS.object(forKey: key) as? Float == nil ? -786.0 : USERDEFAULTS.object(forKey: key) as! Float
    }
    
    static func USERDEFAULTS_SET_DOUBLE_KEY(object:Double, key:String) -> Void {
        USERDEFAULTS .set(object, forKey: key)
    }
    
    static func USERDEFAULTS_GET_DOUBLE_KEY(key:String) -> Double {
        return USERDEFAULTS.object(forKey: key) as? Double == nil ? -786.0 : USERDEFAULTS.object(forKey: key) as! Double
    }
}
