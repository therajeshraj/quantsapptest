//
//  APIManager.swift
//  QuantsFeed
//
//  Created by Rajesh on 15/08/20.
//  Copyright © 2020 Rajesh. All rights reserved.
//

import Foundation

let HOST_NAME = "https://api.androidhive.info/feed/"

class APIManager{
    
    static let shared = APIManager()
    
    private init(){
        
    }
    
    
    func callAPI <model : Decodable> (urlString:String,method: String,params : [String : Any]? , type : model.Type ,onCompletion:@escaping (model?)->Void){
        
        let url = urlString
       // url = url+"/format/json"
        
        var request = URLRequest(url: URL(string: HOST_NAME+url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = method
        
        if let parameters = params{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters,options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            guard let data = data else{
                return
            }
            do {
                
                let json = try JSONDecoder().decode(type, from: data)
                
                let j = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
                
                print(j)
                
                onCompletion(json)
                
            }catch let jsonErr{
                print(jsonErr)
                onCompletion(nil)
            }
        }.resume()
    }
    
    
}
