//
//  UIImageView+Download.swift
//  webHttpTest
//
//  Created by 楊文興 on 2018/6/7.
//  Copyright © 2018年 楊文興. All rights reserved.
//
//套件命名習慣UIImageView+Download

import UIKit

//var loadingView: UIActivityIndicatorView

extension UIImageView{//URL session基本型用法，有很多用法，這是其中一種
    
    static var currenTasks = [String: URLSessionDataTask]()
    
    func showImage(url: URL){//URL也可以代表硬碟裡面local的路徑跟遠端網路的路徑
        
        print("self.description: \(self.description)")
        
        
        if let existTask = UIImageView.currenTasks[self.description]{//檢查是不是已經有某個TASK存在，確保不會有第二個Task跑進來
            existTask.cancel()
            UIImageView.currenTasks.removeValue(forKey: self.description)
            print("A exist task is canceled")
        }
        
        
        let fileName = String(format: "Cacher_%ld", url.hashValue)//
        guard let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {//比較推這種取法，.first只取第一個值
            return
        }
        let fullFileURL = cachesURL.appendingPathComponent(fileName)
        print("Caches: \(cachesURL)")
        
        if let image = UIImage(contentsOfFile: fullFileURL.path){//如果有檔案，就直接show圖片，沒有則上網下載
            //Exist cache file, let's use if and return immediately
            self.image = image
            return
        }
        //Keep goint to download process.
        
        let loadingView = prepareLoadingView()
        
        let congfig = URLSessionConfiguration.default
        let session = URLSession(configuration: congfig)//其意思有點像是開一個任務，工作則是用底下的dataTask:資料下載的一個task
        let task = session.dataTask(with:url) { (data, response, error) in//一出生時是暫停狀態，直到下達resume才會開始作動，回傳的為可選型別
            defer{//defer延後執行，讓這個closure結束後才執行（離開這個大括號才執行
                //這個語法可以用不只一次，最後一個加入的，會最先執行
                DispatchQueue.main.async {
                    loadingView.stopAnimating()//結束轉轉轉
                }
            }
            if let error = error{//基本檢查，先檢查有沒有錯誤
                print("Download fail: \(error)")
                return
            }
            guard let data = data else{//基本檢查，可能永遠不會來到這裡，十之八九會被前一個擋下來
                assertionFailure("data is nil")//
                return
            }
            let image = UIImage(data: data)
            //非常非常重要！
            DispatchQueue.main.async {//在這之前都是在背景執行緒，要在這裡轉回到主執行緒才可以使用
                self.image = image
            }
            
            //save the data into file
            
            //try? data.write(to: fullFileURL)//將檔案存到APP預設路徑，簡易存取方法，如果不在意失敗會怎麼樣，則用這個方法
            //try! data.write(to: fullFileURL)//失敗則直接crash，假設這個東西一定會成功
            
            do{//完整版用法do try catch
                try data.write(to: fullFileURL)
            }catch{
                print("write cache file fail: \(error)")//error:隱藏的參數
            }
            
            defer{
                //....
            }
            
            UIImageView.currenTasks.removeValue(forKey: self.description)//任務完成

        }
        task.resume()//重要！！！有這行才會開始作動
        //Keep the running task
        UIImageView.currenTasks[self.description] = task
        
        loadingView.startAnimating()//開始轉轉轉，不一定要放在這裡
        //        task.cancel()//取消
        //        task.suspend()//暫停
    }
    
    private func prepareLoadingView() -> UIActivityIndicatorView {
        //檢查已經存在的loadingView
        
        /*
         for view in self.subviews{//檢查方式A
         if view is UIActivityIndicatorView{
         return view as! UIActivityIndicatorView
         }
         }
         */
        
        
        let tag = 98765//加上UI元件的Tag
        if let view = self.viewWithTag(tag) as? UIActivityIndicatorView{
            return view
        }
        
        // create loadingView
        let frame = CGRect(origin: .zero, size: self.frame.size)//autoSizing，self.frame.size指定跟view一樣大
        let result = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)//創造loading物件，whiteLarge(有三種形式，也可以自己指定顏色等)
        result.frame = frame
        result.color = .blue//指定顏色
        result.hidesWhenStopped = true//停止時自動隱藏
        result.autoresizingMask = [.flexibleHeight, .flexibleWidth]//指定大小
        result.tag = tag//運用UI元件的tag的做法
        self.addSubview(result)//貼到view上
        return result
    }
    
}

//主執行緒通常執行與使用者互動，盡量不要讓主執行緒太忙，讓他越閒越好

//可以增加定期去清理Cache
//掃檔案的清單，太舊的就砍掉，參考資料管理篇13頁
