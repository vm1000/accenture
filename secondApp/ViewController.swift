//
//  ViewController.swift
//  secondApp
//
//  Created by egmars.janis.timma on 02/04/2019.
//  Copyright © 2019 egmars.janis.timma. All rights reserved.
//



import UIKit
import WebKit



    class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate  {
        
       
//        @IBOutlet weak var textView: UITextView!
        @IBOutlet weak var myScreen: WKWebView!
        
        
        var code = ""
        var tokenLink = "https://login.live.com/oauth20_token.srf"
        var graph = ""
        var clientID = "dc573c5b-2378-4f5e-a6dc-b8edbde0e96f"
        var scope = "onedrive.readonly"
        var redirectUri = "msaldc573c5b-2378-4f5e-a6dc-b8edbde0e96f://auth"
        var responseType = "code"
        var baseUrl = "https://login.live.com/oath20_authorize.srf"
        let ODGetTokenUrl = "https://login.microsoftonline.com/common/oauth2/v2.0/token"
        var graphID = "3f6926fa-7599-45b1-896a-456e7133694d"
        var accesssToken: String = "Token is not set"
        var recievedFinalJson: String? = nil
        let ODMyDriveInfoUrl = "https://graph.microsoft.com/v1.0/me/drives/1827857dba6e5020/root/children"
        let urlEncodedHeader = "application/x-www-form-urlencoded"

        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            let withHomePage = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=dc573c5b-2378-4f5e-a6dc-b8edbde0e96f&scope=files.read&response_type=code&redirect_uri=msaldc573c5b-2378-4f5e-a6dc-b8edbde0e96f://auth"
            let withUrl = URL(string: withHomePage)
            let openWithPageRequest = URLRequest(url: withUrl!)
            myScreen.navigationDelegate = self as WKNavigationDelegate;
            myScreen.load(openWithPageRequest)
        }
        

        
        
        func webView(_ webView:WKWebView, decidePolicyFor navigationAction:WKNavigationAction, decisionHandler: @escaping(WKNavigationActionPolicy) -> Void)
        {
        let body = navigationAction.request.url?.absoluteString
            if body?.range(of: "?code=") != nil {
                let idArr : [String] = body!.components(separatedBy: "=")
                code = idArr[1]
                
                print ("🤬 MY CODE IS!!!  \(code)")
            }
            
            decisionHandler(WKNavigationActionPolicy.allow)
        }
        
        
        func webView(_ webView:WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            getToken()
        }
        
        
        func getToken(){
            let getTokenUrl = URL(string: ODGetTokenUrl)!
            var getTokenRequest = URLRequest(url: getTokenUrl)
            getTokenRequest.setValue(urlEncodedHeader, forHTTPHeaderField: "Content-Type")
            
            getTokenRequest.httpMethod = "POST"
            
            let urlData = "client_id=" + clientID + "&redirect_uri=" + redirectUri + "&code=" + code + "&grant_type=authorization_code"
            
//            getTokenRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            getTokenRequest.httpBody = urlData.data(using: .utf8)
            let tokenTask = URLSession.shared.dataTask(with: getTokenRequest) {
            data, urlResponse, Error in guard
                let data = data, Error == nil else {
                    
                    Error
                    
                    print("error=\(String(describing: Error))")
                    return
                    
                  }
                
                
                self.checkHTTPStatus(response: urlResponse!)
                self.saveAccessToken(allTokenData: data)
                self.getDriveInfo()
            }
            tokenTask.resume()
            
        }
        
        
        
        func getDriveInfo(){
            let urlDrive = URL(string: ODMyDriveInfoUrl)!
               var requestDrive = URLRequest(url: urlDrive)
            requestDrive.setValue("Bearer \(self.accesssToken)",
        forHTTPHeaderField: "Authorization")
            requestDrive.httpMethod = "GET"
                let taskDrive = URLSession.shared.dataTask(with: requestDrive) {
                    data, urlResponse, error in
                    guard let data = data, error == nil else {
                        error
                        print("error=\(String(describing: error))")
                        return
                    }
                    self.checkHTTPStatus(response: urlResponse!)
                    self.printMyOneDriveInfo(allRecievedInfo: data)
            }
            taskDrive.resume()
        }
        
        
        func checkHTTPStatus(response: URLResponse) {
            if let httpStatus = response as? HTTPURLResponse,
                httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is\(httpStatus.statusCode)")
                    print("response = \(response)")
            } }
        
        
        
        
        func saveAccessToken(allTokenData: Data) {
            let tokenResponseData = String(data: allTokenData, encoding: .utf8)
            let fullResponse : [String] = (tokenResponseData!.components(separatedBy: ","))
            let accessTokenPart = fullResponse.last
            let accessTokenSplitArray: [String] =
                accessTokenPart!.components(separatedBy: ":")
            let temAccessToken = accessTokenSplitArray.last!
            let endIndex = temAccessToken.index(temAccessToken.endIndex,
                                                offsetBy: -1)
            
            self.accesssToken = String(temAccessToken[..<endIndex])
        }
        
        
        func printMyOneDriveInfo(allRecievedInfo: Data) {
            let info = String(data: allRecievedInfo, encoding: .utf8)
            print("One Drive Information = \(info!)")
            self.recievedFinalJson = info!
        }
        
        func dataRecieved() {
            if let finalData = recievedFinalJson {
                myScreen.isHidden = true
//                textView.text = finalData
//                closeButton.isHidden = true
            }
        }
        
        
//        @IBAction func hideWebView(_ sender: UIButton) {
//            dataRecieved()
//        }
        
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
}
                    
                    
                    
                    
                    
                    
                    
                    




                    
                    
                    
                    
                    
                    
                
            
//        var myTokenUrl = URL(string: tokenLink + "?code=" + code)!
//        var getTokenRequest = URLRequest(url: myTokenUrl)
//
//        getTokenRequest.httpMethod = "POST"
        

        
        
//        url and url session - post and get method
//        header
//        budy
        
        
        
        
//        var getTokenRequest = URLRequest(url: "?code")
        
        // load content in user var
//       var user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
//
//}



    

//        func showValues(){
//            let graph = "https://graph.microsoft.com/v1.0/me/drives"
//
//            let myUrl = URL(string: graph)!
//
//            var request = URLRequest(url: myUrl)
//
//            request.httpMethod = "GET"

//            request.setValue("Bearer\((recievedCode: ""))", forHTTPHeaderField: "Authorization")
            
//            myScreen.navigationDelegate = self as WKNavigationDelegate
//            myScreen.load(request)
//
//}



//
//        let configuration = NSURLSessionConfiguration .defaultSessionConfiguration()
//        let session = NSURLSession(configuration: configuration)
//
//
//        let urlString = NSString(format: "your URL here")
//
//        print("get wallet balance url string is \(urlString)")
//        //let url = NSURL(string: urlString as String)
//        let request : NSMutableURLRequest = NSMutableURLRequest()
//        request.URL = NSURL(string: NSString(format: "%@", urlString) as String)
//        request.HTTPMethod = "GET"
//        request.timeoutInterval = 30
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        let dataTask = session.dataTaskWithRequest(request) {
//            (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
//
//            // 1: Check HTTP Response for successful GET request
//            guard let httpResponse = response as? NSHTTPURLResponse, receivedData = data
//                else {
//                    print("error: not a valid http response")
//                    return
//            }
//
//            switch (httpResponse.statusCode)
//            {
//            case 200:
//
//                let response = NSString (data: receivedData, encoding: NSUTF8StringEncoding)
//                print("response is \(response)")
//
//
//                do {
//                    let getResponse = try NSJSONSerialization.JSONObjectWithData(receivedData, options: .AllowFragments)
//
//                    EZLoadingActivity .hide()
//
//                    // }
//                } catch {
//                    print("error serializing JSON: \(error)")
//                }
//
//                break
//            case 400:
//
//                break
//            default:
//                print("wallet GET request got response \(httpResponse.statusCode)")
//            }
//        }
//        dataTask.resume()

//            }
//    }

