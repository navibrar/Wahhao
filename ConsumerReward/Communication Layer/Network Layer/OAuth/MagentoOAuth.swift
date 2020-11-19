//  Created by Navpreet on 16/08/18.
//  Copyright © 2018 apple. All rights reserved.

import UIKit
//import CryptoSwift

public class MagentoOAuth {
   /* var apiUrl = String()
    
    public func generateSignature(apiType: String, completion: @escaping (_ OAuthHeader:String) -> Void) {
        OAuthConstants.oAuth.updateValue(self.timestamp, forKey: "oauth_timestamp")
        OAuthConstants.oAuth.updateValue(self.nonce, forKey: "oauth_nonce")
        var encodedURL = ""
        var encodedQueryParameters = ""//Parameters that are attached in URL
        var encodedParameters = ""
        var components = URLComponents(string: apiUrl)!
        if components.queryItems == nil {
            components.createItemsForURLComponentsObject(array: Array<String>().parameters)
            let parameters = components.getURLParameters()
            encodedURL = apiUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet().percentEncoded)!
            encodedParameters = parameters.addingPercentEncoding(withAllowedCharacters: CharacterSet().percentEncoded)!
        }else {
            let arrayURL = apiUrl.components(separatedBy: "?")
            //This is to handle the api url's query string.
            //print(components.queryItems!)
            let arrayQueryString = arrayURL[1].components(separatedBy: "&")
            //print(arrayQueryString)
            //If query string contains more than one parameter then they are reversed to create accurate signature
            let reversedQueryStringArray : [String] = Array(arrayQueryString.reversed())
            //print(reversedQueryStringArray)
            var apiURLWithOutQueryStringParameter = ""
            if reversedQueryStringArray.count > 1 {
                let parameters = reversedQueryStringArray.joined(separator: "&")
                apiURLWithOutQueryStringParameter = "&\(parameters)"
            }else {
                apiURLWithOutQueryStringParameter = "&\(reversedQueryStringArray[0])"
            }
            components.createItemsForURLComponentsObject(array: Array<String>().parameters)
            let parameters = components.getURLParameters()
            //let url = "\(components.scheme!)://\(components.host!)\(components.path)"
            let url = arrayURL[0]
            encodedURL = url.addingPercentEncoding(withAllowedCharacters: CharacterSet().percentEncoded)!
            encodedParameters = parameters.addingPercentEncoding(withAllowedCharacters: CharacterSet().percentEncoded)!
            encodedQueryParameters = apiURLWithOutQueryStringParameter.addingPercentEncoding(withAllowedCharacters: CharacterSet().percentEncoded)!
        }
        var signatureBaseString = ""
        var apiMethod = String()
        if apiType.caseInsensitiveCompare("Get") == .orderedSame {
            apiMethod = OAuthConstants.httpTypeGet
        }else if apiType.caseInsensitiveCompare("Post") == .orderedSame {
            apiMethod = OAuthConstants.httpTypePost
        }else if apiType.caseInsensitiveCompare("Put") == .orderedSame {
            apiMethod = OAuthConstants.httpTypePut
        }else if apiType.caseInsensitiveCompare("Delete") == .orderedSame {
            apiMethod = OAuthConstants.httpTypeDelete
        }
        if components.queryItems == nil {
            signatureBaseString = "\(apiMethod)&\(encodedURL)&\(encodedParameters)".replacingOccurrences(of: "%20", with: "%2520")
        }else {
            signatureBaseString = "\(apiMethod)&\(encodedURL)&\(encodedParameters)\(encodedQueryParameters)".replacingOccurrences(of: "%20", with: "%2520")
        }
        
        let signature = String().getSignature(key: OAuthConstants.key, params: signatureBaseString)
        //print(signature)
        //Create OAuth String to send to server for Authorization
        var oAuthHeader = (OAuthConstants.oAuth.compactMap({ (key, value) -> String in
            return "\(key)=\"\(value)\""
        }) as Array).joined(separator: ",")
        oAuthHeader.append(",oauth_signature=\"")
        oAuthHeader.append("\(signature)\"")
        oAuthHeader = "Oauth "+oAuthHeader
        completion(oAuthHeader)
    }
}

extension MagentoOAuth {
    var timestamp: String {
        get { return String(Int(Date().timeIntervalSince1970)) }
    }
    // Creates a random set of 10 characters
    // The nonce is used for the OAuth process
    var nonce: String {
        get {
            var string: String = ""
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let char = Array(letters)
            for _ in 1...7 { string.append(char[Int(arc4random()) % char.count]) }
            return string
        }
    }
}

/////////////////////////////////
// Extensions to the Array object
/////////////////////////////////
private extension Array {
    // Creates the parameters key, value pair array
    // Sorts the parameters, by name, using ascending byte value ordering
    var parameters: [(key: String, value: String)] {
        get{
            var array = [(key: String, value: String)]()
            
            for (key,value) in OAuthConstants.oAuth {
                array.append((key: key, value: value))
            }
            let newArray = array.sorted(by: { $0 < $1 })
            return newArray
            //return array.sorted(by: { $0 < $1 })
        }
    }
}

/////////////////////////////////////////////////////////
// All constants that may be used for OAUTH
/////////////////////////////////////////////////////////
private struct OAuthConstants {
    // OAuth Parameters
    static var oAuth = ["oauth_consumer_key":KeychainWrapper.standard.string(forKey: "oauth_consumer_key")!,
                        "oauth_signature_method":KeychainWrapper.standard.string(forKey: "oauth_signature_method")!,
                        "oauth_timestamp":"",
                        "oauth_nonce":"",
                        "oauth_token":KeychainWrapper.standard.string(forKey: "oauth_token")!,
                        "oauth_version":KeychainWrapper.standard.string(forKey: "oauth_version")!] as Dictionary

    //1.Consumer Secret Key & 2.accessTokenSecret
    //Append ConsumerSecretKey with accessTokenSecret using "&"
    static let consumerSecret = KeychainWrapper.standard.string(forKey: "consumerSecret")!
    static let accessTokenSecret = KeychainWrapper.standard.string(forKey: "accessTokenSecret")!
    static var key = "\(consumerSecret)&\(accessTokenSecret)"
    //HTTP Request Method
    static let httpTypePost = "POST"
    static let httpTypeGet = "GET"
    static let httpTypePut = "PUT"
    static let httpTypeDelete = "DELETE"
}

////////////////////////////////////////
// Extensions to the CharacterSet object
////////////////////////////////////////
private extension CharacterSet {
    // Percent encodes string based on the URL encoding process described in RFC 3986
    // https://tools.ietf.org/html/rfc3986#section-2.4
    var percentEncoded: CharacterSet {
        get { return CharacterSet.init(charactersIn: String().getPercentEncodingCharacterSet()) }
    }
}

/////////////////////////////////////////
// Extensions to the URLComponents object
/////////////////////////////////////////
private extension URLComponents {
    // Creates URLQueryItems for URLComponent
    // Used for HTTP request
    mutating func createItemsForURLComponentsObject(array: [(key: String, value: String)]) {
        var queryItems = [URLQueryItem]()
        
        for tuple in array {
            queryItems.append(URLQueryItem(name: tuple.key, value: tuple.value))
        }
        
        self.queryItems = queryItems
    }
    
    // Returns the url parameters concatenated together
    // Parameters are seperated by '&'
    func getURLParameters() -> String {
        let queryItems = self.queryItems!
        var params = ""
        
        for item in queryItems {
            let index = queryItems.index(of: item)
            
            if index != queryItems.endIndex - 1 {
                params.append(String(describing: "\(item)&"))
            } else {
                params.append(String(describing: item))
            }
        }
        return params
    }
}

//////////////////////////////////
// Extensions to the String object
//////////////////////////////////
private extension String {
    // String set for URL encoding process described in RFC 3986
    // Also refered to as percent encoding
    func getPercentEncodingCharacterSet() -> String {
        let digits = "0123456789"
        let lowercase = "abcdefghijklmnopqrstuvwxyz"
        let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let reserved = "-._~"
        return digits + lowercase + uppercase + reserved
    }
    
    // Creates the signature string based on the consumer key and signature base string
    // Uses HMAC-SHA1 encryption
    func getSignature(key: String, params: String) -> String {
        //print("Signature Params: \(params)")
        var array = [UInt8]()
        array += params.utf8
        let sign = try! HMAC(key: key, variant: .sha1).authenticate(array).toBase64()!
        return sign
    }
*/
}


