//
//  BaseWebService.swift
//  DocTalk
//
//  Created by Sumeet Jain on 24/05/18.
//  Copyright © 2018 Sumeet Jain. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

typealias ResponseHandler = (Any?, NSError?) -> Void
typealias UserApiResposne = ([UserModel]?, NSError?) -> Void


class BaseWebService: NSObject {
    
    var alamofireManager : Alamofire.SessionManager!
    static let sharedInstance = BaseWebService()
    
    override init() {
        super.init()
        initAlamofire()
    }
    
    func initAlamofire() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10000
        config.timeoutIntervalForResource = 10000
        alamofireManager = Alamofire.SessionManager(configuration: config)
    }
    
    func getUsers(responseHandler:@escaping UserApiResposne) {
        let path = "https://api.github.com/users"
        let params:[String:AnyObject] = ["access_token" : "c1ce75f0d5f824cb1ddf52fd5d36dede75465fa4" as AnyObject]
        getResponse(path, params: params, isCancellable: false) { (response, error) in
            if let data = response as? [[String : Any]]
            {
                let post = Mapper<UserModel>().mapArray(JSONArray: data)
                responseHandler(post,nil)
            }
            else {
                responseHandler(nil,error)
            }
        }
    }
    
    func getFollowersCount(name: String, responseHandler:@escaping UserApiResposne){
        let path = "https://api.github.com/users/" + name + "/followers"
        let params:[String:AnyObject] = ["access_token" : "c1ce75f0d5f824cb1ddf52fd5d36dede75465fa4" as AnyObject]
        getResponse(path, params: params, isCancellable: false) { (response, error) in
            if let data = response as? [[String : Any]]
            {
                let post = Mapper<UserModel>().mapArray(JSONArray: data)
                responseHandler(post,nil)
            }
            else {
                responseHandler(nil,error)
            }
        }
    }
    
    func getResponse(_ path:String, params:[String:AnyObject] = [:], isCancellable:Bool = false, responseHandler:@escaping ResponseHandler)
    {
        let parameters:[String:String] = ["sumujain1995": "c1ce75f0d5f824cb1ddf52fd5d36dede75465fa4"]
        
        alamofireManager.request(path, method: .get, parameters: params, encoding: URLEncoding.default, headers: parameters).responseJSON() {
            response in
            if (response.result.isSuccess) && response.response!.statusCode == 200
            {
                responseHandler(response.result.value,nil)
            }
            else
            {
                let error = NSError(domain: "Something went wrong! Please try again later.", code: 0, userInfo: nil)
                responseHandler(nil, error)
                return
            }
            
        }
    }
    
}
