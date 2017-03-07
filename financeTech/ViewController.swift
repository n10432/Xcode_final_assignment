//
//  ViewController.swift
//  financeTech
//
//  Created by 中村俊允 on 2017/02/01.
//  Copyright © 2017年 Toshimitsu Nakamura. All rights reserved.
//

import UIKit
import Material
import Alamofire

var globalStr:String = ""

struct ButtonLayout {
    struct Flat {
        static let width: CGFloat = 120
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -150
    }
    
    struct Raised {
        static let width: CGFloat = 150
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -75
    }
    
    struct Fab {
        static let diameter: CGFloat = 48
    }
    
    struct Icon {
        static let width: CGFloat = 120
        static let height: CGFloat = 48
        static let offsetY: CGFloat = 75
    }
}



class ViewController: UIViewController {
    // インジケータのインスタンス
    let indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var testtext: UITextView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var resultTextView: UITextView!
    
    
    var months: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.713, blue: 0.890, alpha: 1.0)
        
        //ボタンの作成
        prepareRaisedButton(titleName: "予測する")
        let host = "https://www.quandl.com"
        let urlString = "/api/v3/datasets/NIKKEI/INDEX.json?api_key=4AioRsEyvJqav4u4zT8o&start_date=2014-02-26"
        let api = ApiManager(path: host+urlString)
        api.request(success: { (data: Dictionary) in debugPrint(data) }, fail: { (error: Error?) in print(error) })

        
        
    }
    
    
    func showIndicator() {
        self.prepareRaisedButton(titleName: "予測中")
        
        //別途用意したサーバから株価予測情報を取得する
        let url2: URL = URL(string: "http://52.6.82.159")!
        let task2 = URLSession.shared.dataTask(with: URLRequest(url: url2), completionHandler: { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                globalStr = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                //print(String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
                //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            }
            
        })
        task2.resume()
        
        
        // UIActivityIndicatorView のスタイルをテンプレートから選択
        indicator.activityIndicatorViewStyle = .whiteLarge
        
        // 表示位置
        indicator.center = self.view.center
        
        // 色の設定
        indicator.color = UIColor.green
        
        // アニメーション停止と同時に隠す設定
        indicator.hidesWhenStopped = true
        
        // 画面に追加
        self.view.addSubview(indicator)
        
        // 最前面に移動
        self.view.bringSubview(toFront: indicator)
        
        // アニメーション開始
        indicator.startAnimating()
        
        // 3秒後にアニメーションを停止させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.indicator.stopAnimating()
            self.prepareRaisedButton(titleName: "予測完了")
            let img = UIImage(named:"upArrow")
            self.arrow.image = img
            print(globalStr)
            var resultValue:String = globalStr
            self.resultTextView.text = "終値の予想は"+resultValue+"となりました！"
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController {
    
    fileprivate func prepareRaisedButton(titleName:String) {
        let button = RaisedButton(title: titleName, titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        button.addTarget(self, action: #selector(self.showIndicator), for: .touchUpInside)
        button.sizeToFit()
        view.layout(button)
            .width(ButtonLayout.Raised.width)
            .height(ButtonLayout.Raised.height)
            .center(offsetY: ButtonLayout.Raised.offsetY)
    }
    
}
