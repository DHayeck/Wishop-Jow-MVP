//
//  ProductAdvertisingApi.swift
//  Amazon
//
//  Created by Samer Azar on 4/5/17.
//  Copyright © 2017 Samer Azar. All rights reserved.
//

import Foundation
import Alamofire
import CommonCrypto

public class ProductAdvertisingApi {
    
    var  e = 0
    
    let UTF8_CHARSET = "UTF-8"
    let REQUEST_URI = "/onca/xml"
    let REQUEST_METHOD = "GET"
    let endpoint = "webservices.amazon.fr"
    let awsAccessKeyId = "AKIAJMAFM6BOJDSWC4KA"
    let awsSecretKey = "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"
    let version = "2012-10-17"
    let associateTag = "familyaffai0f-21"
    let service = "AWSECommerceService"
    let availability = "Available"
    let timestamp = ProductAdvertisingApi.ISO8601FormatStringFromDate(date: NSDate())
    
    private class func ISO8601FormatStringFromDate(date: NSDate) -> NSString {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        return dateFormatter.string(from: date as Date) as NSString
    }
    
    func sign(params: [String: String]?) -> String {
        
        var mutableParameters = params!
        
        mutableParameters["Service"] = service
        mutableParameters["AssociateTag"] = associateTag
        mutableParameters["AWSAccessKeyId"] = awsAccessKeyId
        mutableParameters["Version"] = version
        mutableParameters["Timestamp"] = timestamp as String
        mutableParameters["Availability"] = availability
        
        var canonicalStringArray = [String]()
        
        let sortedKeys = Array(mutableParameters.keys).sorted {$0 < $1}
        
        for key in sortedKeys {
            if (key == "HMAC") {
                canonicalStringArray.append("\(key)=\(mutableParameters[key]!)")
            } else {
                let enodedCanonicalString0 = CFURLCreateStringByAddingPercentEscapes(
                    nil,
                    key as CFString!,
                    nil,
                    ":," as CFString!,//"!*'();:@&=+$,/?%#[]",
                    CFStringBuiltInEncodings.UTF8.rawValue
                    ) as String
                
                let enodedCanonicalString1 = CFURLCreateStringByAddingPercentEscapes(
                    nil,
                    mutableParameters[key]! as CFString!,
                    nil,
                    ":," as CFString!,//"!*'();:@&=+$,/?%#[]",
                    CFStringBuiltInEncodings.UTF8.rawValue
                    ) as String
                canonicalStringArray.append("\(enodedCanonicalString0)=\(enodedCanonicalString1)")
            }
            
        }
        
        let canonicalString = canonicalStringArray.joined(separator: "&")
        
        var signature = ""
        
        signature = "\(REQUEST_METHOD)\n\(endpoint)\n\(REQUEST_URI)\n\(canonicalString)"
        
        var encodedSignatureString = signature.digestHMac256(key: awsSecretKey)
        
        encodedSignatureString = CFURLCreateStringByAddingPercentEscapes(
            nil,
            encodedSignatureString as CFString!,
            nil,
            "+=" as CFString!,//"!*'();:@&=+$,/?%#[]",
            CFStringBuiltInEncodings.UTF8.rawValue
            ) as String
        
        var url = ""
        
        if let sig = encodedSignatureString {
            url = "http://" + endpoint + REQUEST_URI + "?" + canonicalString + "&Signature=" +  sig
        }
        return url
    }
    
    func itemSearch(keywords: String) -> [String : String] {
        
        var p: [String: String] = ["Operation" : "ItemSearch"]
        
        p["Keywords"] = keywords
        p["SearchIndex"] = "All"
        p["ResponseGroup"] = "ItemAttributes,Images"
        
        var r: [String: String] = [" ":" "]
        while (e == 0){
            r["url"] = sign(params: p)
            let URL = Foundation.URL(string: r["url"]!)
            if (URL != nil) {
                do {
                    let s:NSString =  try NSString(contentsOf: URL!, encoding: String.Encoding.utf8.rawValue)
                    let xmlData = s.data(using: String.Encoding.utf8.rawValue)!
                    let parser = XMLParser(data: xmlData)
                    let root = Items()
                    parser.delegate = root
                    parser.parse()
                    var i = 0
                    for c in root.items {
                        r["ASIN" + String(i)] = c.asin
                        i = i + 1
                    }
                    e = 1
                } catch {
                    e = 0
                }
            } else {
                print("EMPTY URL")
                e = 1
            }
        }
        e = 0
        return r
    }
    
    func GetCart(cartId: String,HMAC: String) -> [String: String] {
        
        var p: [String: String] = ["Operation" : "CartGet"]
        
        p["CartId"] = cartId
        p["HMAC"] = HMAC
        
        var r: [String: String] = [" ":" "]
        while (e == 0){
            
            r["url"] = sign(params: p)
            
            let URL = Foundation.URL(string: r["url"]!)
            if (URL != nil) {
                do {
                    let s:NSString =  try NSString(contentsOf: URL!, encoding:String.Encoding.utf8.rawValue)
                    let xmlData = s.data(using: String.Encoding.utf8.rawValue)!
                    let parser = XMLParser(data: xmlData)
                    let root = Cart()
                    parser.delegate = root
                    parser.parse()
                    r["CartId"] = root.cartId
                    r["URLEncodedHMAC"] = root.urlEncodedHMAC
                    r["PurchaseURL"] = root.purchaseURL
                    e = 1
                } catch {
                    e = 0
                }
            } else {
                print("EMPTY URL")
                e = 1
            }
        }
        e = 0
        return r
    }
    
    func AddCart(cartId: String,HMAC: String,ASIN: String,quantity: String) -> [String: String] {
        
        var p: [String: String] = ["Operation" : "CartAdd"]
        
        p["CartId"] = cartId
        p["HMAC"] = HMAC
        p["Item.1.ASIN"] = ASIN
        p["Item.1.Quantity"] = quantity
        
        var r: [String: String] = [" ":" "]
        
        while (e == 0){
            
            r["url"] = sign(params: p)
            let URL = Foundation.URL(string: r["url"]!)
            if (URL != nil) {
                do {
                    let s:NSString =  try NSString(contentsOf: URL!, encoding:String.Encoding.utf8.rawValue)
                    let xmlData = s.data(using: String.Encoding.utf8.rawValue)!
                    let parser = XMLParser(data: xmlData)
                    let root = Cart()
                    parser.delegate = root
                    parser.parse()
                    r["CartId"] = root.cartId
                    r["URLEncodedHMAC"] = root.urlEncodedHMAC
                    r["PurchaseURL"] = root.purchaseURL
                    e = 1
                } catch {
                    e = 0
                }
            } else {
                print("EMPTY URL")
                e = 1
            }
        }
        e = 0
        return r
    }
    
    func CreateCart(ASIN: String,quantity: String) -> [String: String] {
        
        var p: [String: String] = ["Operation" : "CartCreate"]
        
        p["Item.1.ASIN"] = ASIN
        p["Item.1.Quantity"] = quantity
        
        var r: [String: String] = [" ":" "]
        while (e == 0){
            
            r["url"] = sign(params: p)
            
            let URL = Foundation.URL(string: r["url"]!)
            if (URL != nil) {
                do {
                    let s:NSString =  try NSString(contentsOf: URL!, encoding:String.Encoding.utf8.rawValue)
                    let xmlData = s.data(using: String.Encoding.utf8.rawValue)!
                    let parser = XMLParser(data: xmlData)
                    let root = Cart()
                    parser.delegate = root
                    parser.parse()
                    r["CartId"] = root.cartId
                    r["URLEncodedHMAC"] = root.urlEncodedHMAC
                    r["PurchaseURL"] = root.purchaseURL
                    e = 1
                } catch let error as  NSError {
                    print ("Error: \(error.domain) \(error.code)")
                    e = 0
                }
            }else {
                print("EMPTY URL")
                e = 1
            }
        }
        e = 0
        return r
    }
    
    
    func ClearCart(cartId: String,HMAC: String) -> [String: String] {
        
        var p: [String: String] = ["Operation" : "CartClear"]
        
        p["CartId"] = cartId
        p["HMAC"] = HMAC
        
        var r: [String: String] = [" ":" "]
        
        r["url"] = sign(params: p)
        return r
    }
}



extension String {
    
    func digestHMac256(key: String) -> String! {
        
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = self.lengthOfBytes(using: String.Encoding.utf8)
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = key.lengthOfBytes(using: String.Encoding.utf8)
        let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA256)
        CCHmac(algorithm, keyStr!, keyLen, str!, strLen, result)
        let data = NSData(bytesNoCopy: result, length: digestLen)
        let hash = data.base64EncodedString()
        return hash
    }
}
