//
//  AQIDownloader.swift
//  NewsTableTest
//
//  Created by 楊文興 on 2018/6/13.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation

struct SiteInfo: Codable {
    var siteName: String = ""
    var county: String = ""
    var aqi: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var status: String = ""
    var pm25: String = ""
    enum CodingKeys: String,CodingKey {//嚴格遵守Value開頭小寫的變化做法，對應關係
        case siteName = "SiteName"
        case county = "County"
        case aqi = "AQI"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case status = "Status"
        case pm25 = "PM2.5"
    }
    
}

typealias AQIDownloaderHandler = (Error?, [SiteInfo]?) -> Void//typealias型別暱稱，指定名稱可以代替某個型別

class AQIDownloader{
    
    let targetURL: URL//延後給起始值的寫法，但是一定要有建構式
    
    init(rssURL: URL) {
        targetURL = rssURL
    }
    
    //會傳參數進來doneHandler，型別是closure，能被餵Error跟一個陣列，欄位不固定的話則可以嘗試Dictionary
    //func download(doneHandler:(Error?, [NewsItem]?) -> Void){
    
    func download(doneHandler: @escaping AQIDownloaderHandler){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: targetURL) { (data, response, error) in
            if let error = error{//判斷是不是有error發生
                print("Download Fail: \(error)")
                DispatchQueue.main.async {//轉換成main Thread
                    doneHandler(error, nil)//coding時一開始會有跳錯誤是正常的，@escaping
                }
                return
            }
            guard let data = data else{
                print("Data is nil.")
                //利用NSError自製一個error的物件，業界的錯誤代碼通常會用負數表示Ex:code: -1，顯示錯誤盡量讓ViewController去做
                let error = NSError(domain: "Data is nil.", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    doneHandler(error, nil)
                }
                return
            }
            //For Json
            let decoder = JSONDecoder()
            let results = try? decoder.decode([SiteInfo].self, from: data)//不一定成功，可能是因為跟Json格式兜不攏
            
            if let results = results {
                //parse OK
                DispatchQueue.main.async {
                    doneHandler(nil, results)
                }
            }else{
                //parse Fail
                let error = NSError(domain: "parse Json Fail!", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    doneHandler(error, nil)
                }
            }
        }
        task.resume()
    }

}
