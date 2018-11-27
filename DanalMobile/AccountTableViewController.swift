//
//  AccountTableViewController.swift
//  DanalMobile
//
//  Created by BENJAMIN BRYANT BUDIMAN on 05/09/18.
//  Copyright © 2018 Danal, Inc. All rights reserved.
//

import UIKit
import Foundation

class AccountTableViewController: UITableViewController {
    @IBOutlet weak var phoneVerificationResult: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let url = URL(string: "https://api-sbox.dnlsrv.com/cigateway/cinfo")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let correlationID = randomString(length: 8);
        let timeStamp = getTimestamp();
        
        let password = valueForSecretKey(keyname: "Password").addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)!
        
        let merchantID = valueForSecretKey(keyname: "MerchantID");
        
        let postString = "Method=StartPhoneIdentificationReq&Version=1.0.0&Sign=none" + "&MerchantID=" + merchantID + "&CorrelationID=" + correlationID + "&TimeStamp=" + timeStamp + "&Password=" + password;
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
           
            let pattern = "&EVURL=(.*)&CorrelationID="
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: responseString!, options: [], range: NSRange(location: 0, length: responseString!.count))
            
            var EVURL = "Error"
            for match in matches {
                for n in 0..<match.numberOfRanges {
                    let nsRange = match.range(at: n)
                    let range = Range(nsRange, in: responseString!)
                    EVURL = String(responseString![range!])
                }
            }
            
            EVURL = EVURL.removingPercentEncoding!
            
            DispatchQueue.main.async {
                let text = self.fireURL(url: EVURL)
            
                let pat1 = "ErrorDescription=(.*)&Carrier"
                let pat2 = "&Carrier=(.*)"
            
                let regex1 = try! NSRegularExpression(pattern: pat1, options: [])
                let regex2 = try! NSRegularExpression(pattern: pat2, options: [])
            
                let matches1 = regex1.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
                let matches2 = regex2.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
            
                var description = "Error"
                for match in matches1 {
                    for n in 0..<match.numberOfRanges {
                        let nsRange = match.range(at: n)
                        let range = Range(nsRange, in: text)
                        description = String(text[range!])
                    }
                }
            
                var carrier = "Error"
                for match in matches2 {
                    for n in 0..<match.numberOfRanges {
                        let nsRange = match.range(at: n)
                        let range = Range(nsRange, in: text)
                        carrier = (String(text[range!]) as NSString).substring(to: 3)
                    }
                }
            
                self.phoneVerificationResult.text = "Description: " + description + "\n" + "Carrier: " + carrier
            }
        }
        
        task.resume();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	@IBAction func done(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

    func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT:0)
        
        var timestamp = dateFormatter.string(from: NSDate() as Date)
        let utc = dateFormatter.date(from: timestamp)
        
        timestamp = dateFormatter.string(from: utc!)
        
        return String(timestamp);
    }
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func valueForSecretKey(keyname:String) -> String {
        // Get the file path for keys.plist
        let filePath = Bundle.main.path(forResource: "keys", ofType: "plist")
        
        // Put the keys in a dictionary
        let plist = NSDictionary(contentsOfFile: filePath!)
        
        // Pull the value for the key
        let value:String = plist?.object(forKey: keyname) as! String
        
        return value;
    }
    
    func fireURL(url:String) -> String {
        var response = "ERROR: Unknown HTTP Response"
        
        print("\nresponse in AccountTakeOver")
        
        response = HTTPRequester.performGetRequest(URL(string: url))
     
        print(response + "\n")
        
        if response.range(of:"REDIRECT:") != nil {            
            // Get redirect link
            let redirectRange = response.index(response.startIndex, offsetBy: 9)...
            let redirectLink = String(response[redirectRange])

            // Make recursive call
            response = fireURL(url: redirectLink)
        } else if response.range(of:"ERROR: Done") != nil {
            return "ERROR: Unknown HTTP Response";
        }
        
        return response;
    }
}
