//
//  WonderApi.swift
//  Demo
//
//  Created by COMQUAS on 2/6/20.
//  Copyright © 2020 COMQUAS. All rights reserved.
//
import Moya

enum WonderApi{
    case bins
}

extension WonderApi : TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.myjson.com/") else { fatalError("baseURL could not be configured") }
        return url
    }
    
    var path: String {
        return "bins/13g69v"
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return "Nothing".utf8Encoded
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
