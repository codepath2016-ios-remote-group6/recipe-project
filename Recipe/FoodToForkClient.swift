//
//  FoodToForkClient.swift
//  Recipe
//
//  Created by Craig Vargas on 11/12/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class FoodToForkClient: BDBOAuth1SessionManager {
    
    private static let foodToForkBaseUrlString: String = "http://food2fork.com/api"
    private static let searchEndpoint: String = "search"
    private static let getEndpoint: String = "get"
    private static let apiKey: String = "8107488aac4242d1aa807ebd160ab248"
    
    class FoodToForkError: Error{
        var description: String
        init(description: String){
            self.description = description
        }
    }
    
    // http://food2fork.com/api/search?key=8107488aac4242d1aa807ebd160ab248&q=chili
    
    class func search(query: String?, page: String?, sort: String?, success: @escaping ([Dictionary<String,Any>])->(), failure: @escaping (Error?)->()){
        print("Food2Fork search started")

        let baseUrlString = "\(self.foodToForkBaseUrlString)/\(self.searchEndpoint)"
        let baseUrl = URL(string: baseUrlString)
        let baseUrlRequest = URLRequest(url: baseUrl!)
        
        var parameters = Dictionary<String,AnyObject>()
        parameters["key"] = self.apiKey as AnyObject
        if let query = query{
            parameters["q"] = query as AnyObject
        }
        if let sort = sort{
            parameters["sort"] = sort as AnyObject
        }
        if let page = page{
            parameters["page"] = page as AnyObject
        }

        
        let serializedRequest = AFHTTPRequestSerializer().request(bySerializingRequest: baseUrlRequest, withParameters: parameters, error: nil)

//        print("serializedRequest: \(serializedRequest)")
        
        if let serializedRequest = serializedRequest{
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            let task : URLSessionDataTask =
                session.dataTask(with: serializedRequest, completionHandler:{(dataOrNil, response, error) in
                    if let data = dataOrNil {
                        print("f2f not respoinding... error: \(error?.localizedDescription)")
                        print("f2f not respoinding... dataOrNil: \(dataOrNil)")
                        print("f2f not respoinding... response: \(response)")
                        if let responseDictionary =
                            try? JSONSerialization.jsonObject(with: data, options:[]) as! NSDictionary {
                            
                            if let recipeList = responseDictionary["recipes"] as? [Dictionary<String,Any>]{
                                success(recipeList)
                            }else{
                                print("f2f Food2ForkClient: Error parsing the response dictionary")
                                let apiError = FoodToForkError(description: "Api result format changed")
                                failure(apiError)
                            }
    
                        }else{
                            print("f2f something went wrong with conversion to dictionary")
                            let apiError = FoodToForkError(description: "Invalid response from api")
                            failure(apiError)
                        }
                    }else{
                        print("something went wrong with request")
                        print("Error: \(error?.localizedDescription)")
                        failure(error)
                    }

            });
            task.resume()
        }
    }
    
    
    //
    class func getRecpie(withRecipeId recipeId: String, success: @escaping (Dictionary<String,Any>)->(), failure: @escaping (Error?)->()){
        print("Food2Fork get recipie started")
        
        let baseUrlString = "\(self.foodToForkBaseUrlString)/\(self.getEndpoint)"
        let baseUrl = URL(string: baseUrlString)
        let baseUrlRequest = URLRequest(url: baseUrl!)
        
        var parameters = Dictionary<String,AnyObject>()
        parameters["key"] = self.apiKey as AnyObject
        parameters["rId"] = recipeId as AnyObject
        
        let serializedRequest = AFHTTPRequestSerializer().request(bySerializingRequest: baseUrlRequest, withParameters: parameters, error: nil)
        
        //        print("serializedRequest: \(serializedRequest)")
        
        if let serializedRequest = serializedRequest{
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            let task : URLSessionDataTask =
                session.dataTask(with: serializedRequest, completionHandler:{(dataOrNil, response, error) in
                    if let data = dataOrNil {
                        if let responseDictionary =
                            try? JSONSerialization.jsonObject(with: data, options:[]) as! NSDictionary {
                            
                            if let recipe = responseDictionary["recipe"] as? Dictionary<String,Any>{
                                success(recipe)
                            }else{
                                print("Food2ForkClient: Error parsing the response dictionary")
                                
                            }
                            
                        }else{
                            print("something went wrong with conversion to dictionary")
                        }
                    }else{
                        print("something went wrong with request")
                        print("Error: \(error?.localizedDescription)")
                        failure(error)
                    }
                    
                });
            task.resume()
        }
    }


    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
