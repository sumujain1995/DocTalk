//
//  Constants.swift
//  DocTalk
//
//  Created by Sumeet Jain on 24/05/18.
//  Copyright © 2018 Sumeet Jain. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class UserModel : Mappable
{
    var name: String?
    var followersCount: Int = 0{
        didSet{
            if let userName = name{
                usersArr[followersCount] = userName
            }
        }
    }
    var followers_url: String?{
        didSet{
            if let tempName = name{
                BaseWebService.sharedInstance.getFollowersCount(name: tempName) { (response, error) in
                    if let userResponse = response{
                        do {
                            
                            self.followersCount = userResponse.count
                        }catch let error{
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map)
    {
        name <- map["login"]
        followers_url <- map["followers_url"]
    }
}
