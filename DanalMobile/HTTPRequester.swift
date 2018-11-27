//
//  HTTPRequester.swift
//  DanalDemo
//
//  Created by Saagar Jha on 8/14/17.
//  Copyright © 2017 Saagar Jha. All rights reserved.
//

import Foundation

extension HTTPRequester {
	static func getCellularInfo() throws -> String {
//        let endpoint = "https://api-sbox.dnlsrv.com/cigateway/cinfo"
//        var method = "StartPhoneIdentificationReq"
//        let merchantID = "00CA47700141"
//        let password = "kNT9tGtKzCh3f/V8T55mg93G==".addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)!
//        let sign = "none"
//        let version = "1.0.0"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMddhhmmss"
//        let timestamp = dateFormatter.string(from: Date())
//        let correlationID = "1"
//        var request = URLRequest(url: URL(string: endpoint)!)
//        request.httpMethod = "POST"
//        request.httpBody = "Method=\(method)&MerchantID=\(merchantID)&Password=\(password)&Sign=\(sign)&Version=\(version)&Timestamp=\(timestamp)&CorrelationID=\(correlationID)".data(using: .utf8)
//        //let semaphore = DispatchSemaphore(value: 0)
//        var authenticationKey = ""
//
//        var toReturn = "not good!"
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                return
//            }
//            guard let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)?.removingPercentEncoding?.replacingOccurrences(of: "EVURL=", with: "") else {
//                return
//            }
//
//            toReturn = result
//
//            authenticationKey = String(result.split(separator: "&").first(where: { $0.hasPrefix("AuthenticationKey=") })!)
//            _ = try? HTTPRequester.performGetRequest(with: URL(string: result))
//            //semaphore.signal()
//        }.resume()
        
        
        let decodedData = Data(base64Encoded: "ExNYKNKh2iCwPGijJdP64A==", options: .ignoreUnknownCharacters)!
        let aesKey = String(data: decodedData, encoding: .ascii)!
        
        let correlationID = randomString(length: 8)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        let timestamp = dateFormatter.string(from: Date())
        
        let randomNum:UInt32 = arc4random_uniform(90000)+10000
        let nonce:String = String(randomNum)
        
        let payLoad = "correlationid=" + correlationID
            + "&timestamp=" + timestamp
            + "&nonce=" + nonce
        
        var iv = randomString(length: 16)
        
        do {
            var encryptedPayload = try aesEncrypt(message: payLoad, key: aesKey, iv: iv)
            encryptedPayload = encryptedPayload.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            
            iv = iv.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let requestBody = "&data=" + encryptedPayload
                + "&cipherSalt=" + iv
            
            let EVURL = "http://mi-sbox.dnlsrv.com/msbox/id/kJlSiWWo?" + requestBody
            var response = try? HTTPRequester.performGetRequest(with: URL(string: result))
            return response
        } catch {
            print("aes encryption error")
        }

    }
}
//        semaphore.wait()
//        method = "GetPhoneIDReq"
//        request.httpBody = "Method=\(method)&MerchantID=\(merchantID)&Password=\(password)&Sign=\(sign)&Version=\(version)&Timestamp=\(timestamp)&CorrelationID=\(correlationID)&\(authenticationKey)".data(using: .utf8)
//        var result: (String, String)?
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                return
//            }
//            let results = NSString(data: data, encoding: String.Encoding.utf8.rawValue)?.removingPercentEncoding?.split(separator: "&")
//            guard let carrier = results?.first(where: {$0.hasPrefix("Carrier=")}),
//            let phoneNumber = results?.first(where: {$0.hasPrefix("MobileNumberToken=")}) else {
//                return
//            }
//            result = (carrier.replacingOccurrences(of: "Carrier=", with: ""), phoneNumber.replacingOccurrences(of: "MobileNumberToken=", with: ""))
//            semaphore.signal()
//        }.resume()
//        semaphore.wait()
//        if let result = result {
//            return result
//        } else {
//            throw RequestError.invalidData
//        }
//    }
//
//    enum RequestError: Error {
//        case invalidData
//    }
//}
