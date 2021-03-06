//
//  NetworkHelper.swift
//  Book Swap
//
//  Created by Kamil Powałowski on 18.03.2016.
//  Copyright © 2016 Book Swap Team. All rights reserved.
//

import Foundation
import Alamofire
import Async
import Timberjack

class NetworkHelper {
    
    static func request(method: Alamofire.Method, endpoint: String, parameters: [String: AnyObject]?, encoding: ParameterEncoding = ParameterEncoding.JSON, completionHandler: (response: Alamofire.Response<AnyObject, NSError>) -> Void) {
        
        showNetworkActivityIndicator()

        HTTPManager.sharedManager.request(method, "\(Constans.apiUrl)\(endpoint)", parameters: parameters, encoding: encoding, headers: nil)
            .validate()
            .responseJSON { (response) -> Void in
                hideNetworkActivityIndicator()
                completionHandler(response: response)
        }
    }
    
    static func authorizedRequest(method: Alamofire.Method, endpoint: String, parameters: [String: AnyObject]?, encoding: ParameterEncoding = ParameterEncoding.JSON, completionHandler: (response: Alamofire.Response<AnyObject, NSError>) -> Void) {
        
        guard let token = NSUserDefaults.standardUserDefaults().stringForKey(Constans.DefualtKey.UserToken.rawValue) else {
            //TODO: when there is no token we should return something. ;P
            return
        }
        
        showNetworkActivityIndicator()
        
        let headers = ["X-BookSwap-Token": token]
        
        HTTPManager.sharedManager.request(method, "\(Constans.apiUrl)\(endpoint)", parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { (response) -> Void in
                hideNetworkActivityIndicator()
                completionHandler(response: response)
        }
    }
    
    private static var numberOfNetworkActivityIndicatorCalls = 0
    private static var turnOffNetworkActivityIndicatorAsyncTask: Async?
    
    static func showNetworkActivityIndicator() {
        numberOfNetworkActivityIndicatorCalls += 1
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if turnOffNetworkActivityIndicatorAsyncTask != nil {
            turnOffNetworkActivityIndicatorAsyncTask?.cancel()
        }
        
        turnOffNetworkActivityIndicatorAsyncTask = Async.main(after: 60) {
            numberOfNetworkActivityIndicatorCalls = 0
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
    }
    
    static func hideNetworkActivityIndicator() {
        numberOfNetworkActivityIndicatorCalls = max(numberOfNetworkActivityIndicatorCalls - 1, 0)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = (numberOfNetworkActivityIndicatorCalls > 0)
    }
}

//Used for timberjack https://github.com/andysmart/Timberjack
private class HTTPManager: Alamofire.Manager {
    static let sharedManager: HTTPManager = {
        let configuration = Timberjack.defaultSessionConfiguration()
        let manager = HTTPManager(configuration: configuration)
        return manager
    }()
}