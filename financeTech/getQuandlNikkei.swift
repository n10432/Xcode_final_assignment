//
//  dataCollection.swift
//  financeTech
//ウェブ上から日経平均を収集するプログラム
//  Created by 中村俊允 on 2017/02/01.
//  Copyright © 2017年 Toshimitsu Nakamura. All rights reserved.
//

import Foundation
import Alamofire

private let host = "https://www.quandl.com"

struct ApiManager {
    let url: String
    let method: HTTPMethod
    let parameters: Parameters
    
    init(path: String, method: HTTPMethod = .get, parameters: Parameters = [:]) {
        url = path
        self.method = method
        self.parameters = parameters
    }
    
    func request(success: @escaping (_ data: Dictionary<String, Any>)-> Void, fail: @escaping (_ error: Error?)-> Void) {
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                success(response.result.value as! Dictionary)
            }else{
                fail(response.result.error)
            }
        }
    }
}

func getNikkeiData() -> String {
    var urlString = "/api/v3/datasets/NIKKEI/ALL_STOCK.json?api_key=4AioRsEyvJqav4u4zT8o&start_date=2017-02-10"
    let api = ApiManager(path: urlString)
    api.request(success: { (data: Dictionary) in debugPrint(data) }, fail: { (error: Error?) in print(error) })
    return "test"
}

