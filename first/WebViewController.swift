//
//  WebViewController.swift
//  first
//
//  Created by 彭程 on 2018/4/3.
//  Copyright © 2018年 www.riccin.com. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var mWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "热门活动"
        let url  = URL(string: "http://m.ofo.so/active.html")
        let urlRequest = URLRequest(url: url!)
        mWebView.loadRequest(urlRequest)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
