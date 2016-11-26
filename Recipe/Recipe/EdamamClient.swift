//
//  EdamamClient.swift
//  Recipe
//
//  Created by Craig Vargas on 11/15/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//


//
//  FoodToForkClient.swift
//  Recipe
//
//  Created by Craig Vargas on 11/12/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class EdamamClient: NSObject{
    
    private static let baseUrlString: String = "https://api.edamam.com"
    private static let searchEndpoint: String = "search"
    private static let apiKey: String = "a6a15005e7a2a5db08d1635d0d5ed572"
    private static let appId: String = "c34882ee"
    
    private static let apiKeyParamName = "app_key"
    private static let appIdParamName = "app_id"
    private static let queryParamName = "q"
    private static let startIndexParamName = "from"
    private static let endIndexParamName = "to"
    private static let recipeUriParamName = "r"
    
    private static let resultsJsonKey = "hits"
    
    
    class EdamamError: Error{
        var description: String
        init(description: String){
            self.description = description
        }
    }
    
    //https://api.edamam.com/search?q=chicken&app_id=c34882ee&app_key=a6a15005e7a2a5db08d1635d0d5ed572
    
    class func search(query: String?, startIndex: Int?, numResults: Int?, recipeUri: String?, success: @escaping ([Dictionary<String,Any>])->(), failure: @escaping (Error?)->()){
        print("Edamam search started")
        
        let baseUrlString = "\(self.baseUrlString)/\(self.searchEndpoint)"
        let baseUrl = URL(string: baseUrlString)
        let baseUrlRequest = URLRequest(url: baseUrl!)
        
        var parameters = Dictionary<String,AnyObject>()
        parameters[self.apiKeyParamName] = self.apiKey as AnyObject
        parameters[self.appIdParamName] = self.appId as AnyObject
        
        if let query = query{
            parameters[self.queryParamName] = query as AnyObject
        }
        if let startIndex = startIndex{
            parameters[self.startIndexParamName] = startIndex as AnyObject
            if let numResults = numResults{
                parameters[self.endIndexParamName] = (startIndex + numResults) as AnyObject
            }
        }
        if let recipeUri = recipeUri{
            parameters[self.recipeUriParamName] = recipeUri as AnyObject
        }

        
        
        let serializedRequest = AFHTTPRequestSerializer().request(bySerializingRequest: baseUrlRequest, withParameters: parameters, error: nil)
        
        print("serializedRequest: \(serializedRequest)")
        
        if let serializedRequest = serializedRequest{
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            let task : URLSessionDataTask =
                session.dataTask(with: serializedRequest, completionHandler:{(dataOrNil, response, error) in
                    if let data = dataOrNil {
                        print("Edamam result - error: \(error?.localizedDescription)")
                        print("Edamam result - dataOrNil: \(dataOrNil)")
                        print("Edamam result - response: \(response)")
                        if let responseDictionary =
                            try? JSONSerialization.jsonObject(with: data, options:[]) as! NSDictionary {
                            
                            if let recipeList = responseDictionary[self.resultsJsonKey] as? [Dictionary<String,Any>]{
                                success(recipeList)
                            }else{
                                print("Edamam Clent: Error parsing the response dictionary")
                                let apiError = EdamamError(description: "Api result format changed")
                                failure(apiError)
                            }
                            
                        }else{
                            print("Edamam something went wrong with conversion to dictionary")
                            let apiError = EdamamError(description: "Invalid response from api")
                            failure(apiError)
                        }
                    }else{
                        print("something went wrong with request")
                        print("Edamam error - dataOrNil: \(dataOrNil)")
                        print("Edamam error - response: \(response)")
                        print("Edamam error - error: \(error)")
                        print("Error: \(error?.localizedDescription)")
                        failure(error)
                    }
                    
                });
            task.resume()
        }
    }
    
    
    //
//    class func getRecpie(withRecipeId recipeId: String, success: @escaping (Dictionary<String,Any>)->(), failure: @escaping (Error?)->()){
//        print("Food2Fork get recipie started")
//        
//        let baseUrlString = "\(self.foodToForkBaseUrlString)/\(self.getEndpoint)"
//        let baseUrl = URL(string: baseUrlString)
//        let baseUrlRequest = URLRequest(url: baseUrl!)
//        
//        var parameters = Dictionary<String,AnyObject>()
//        parameters["key"] = self.apiKey as AnyObject
//        parameters["rId"] = recipeId as AnyObject
//        
//        let serializedRequest = AFHTTPRequestSerializer().request(bySerializingRequest: baseUrlRequest, withParameters: parameters, error: nil)
//        
//        //        print("serializedRequest: \(serializedRequest)")
//        
//        if let serializedRequest = serializedRequest{
//            let session = URLSession(
//                configuration: URLSessionConfiguration.default,
//                delegate:nil,
//                delegateQueue:OperationQueue.main
//            )
//            
//            let task : URLSessionDataTask =
//                session.dataTask(with: serializedRequest, completionHandler:{(dataOrNil, response, error) in
//                    if let data = dataOrNil {
//                        if let responseDictionary =
//                            try? JSONSerialization.jsonObject(with: data, options:[]) as! NSDictionary {
//                            
//                            if let recipe = responseDictionary["recipe"] as? Dictionary<String,Any>{
//                                success(recipe)
//                            }else{
//                                print("Food2ForkClient: Error parsing the response dictionary")
//                                
//                            }
//                            
//                        }else{
//                            print("something went wrong with conversion to dictionary")
//                        }
//                    }else{
//                        print("something went wrong with request")
//                        print("Error: \(error?.localizedDescription)")
//                        failure(error)
//                    }
//                    
//                });
//            task.resume()
//        }
//    }
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
