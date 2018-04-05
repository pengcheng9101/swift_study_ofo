//
//  ViewController.swift
//  first
//
//  Created by 彭程 on 2018/4/3.
//  Copyright © 2018年 www.riccin.com. All rights reserved.
//

import UIKit
import SWRevealViewController

class ViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate{
    @IBOutlet weak var panelView: UIView!   // 解锁单车
    var mapView: MAMapView!   // 高德地图
    

    @IBAction func loacationClick(_ sender: Any) {
        searchBikeNearBy()
    }
    
    
    var search: AMapSearchAPI!
    @IBOutlet weak var bottomRightBtn: UIStackView!
    @IBOutlet weak var bottomLeftBtn: UIStackView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MAMapView(frame: view.bounds)
        view.addSubview(mapView)
        view.bringSubview(toFront: panelView)  // panelView前置
        
        //  map加载的一些自定义 ,类似于安卓的接口实现
        mapView.delegate = self
        
        mapView.zoomLevel = 17 // 默认地图缩放比例
        // 显示定位蓝点(当前用户位置)   http://lbs.amap.com/api/ios-sdk/guide/create-map/location-map
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        self.mapView.customMapStyleEnabled = true
        var path = Bundle.main.bundlePath
        path.append("/style.data")
        let jsonData = NSData.init(contentsOfFile: path)
        self.mapView.setCustomMapStyleWithWebData(jsonData as Data!)
        self.mapView.customMapStyleEnabled = true;

        
        // 搜索初始化
        search = AMapSearchAPI()
        search.delegate = self
        
        
        
        // title 按钮 设置
        self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "leftTopImage").withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "rightTopImage").withRenderingMode(.alwaysOriginal)
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ofoLogo"))
        // 返回键去文字
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view, typically from a nib.
        // 设置 侧边栏
        if let revealVC = revealViewController(){
              revealVC.rearViewRevealWidth = 280
              self.navigationItem.leftBarButtonItem?.target = revealVC
             self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
             view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    
    }
    
    


    // 搜索周边小黄车
    func searchBikeNearBy(){
        
        searchCustomLocation(mapView.userLocation.coordinate)
    }
    
    func searchCustomLocation(_ center: CLLocationCoordinate2D!){
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        //poi 点
        request.keywords = "餐馆"   // 模拟周边小黄
        request.radius = 1000
        request.requireExtension = true
        search.aMapPOIAroundSearch(request)
    }
    
    //  poi 搜索的回调
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        guard response.count > 0 else{
            print("周边没有小黄车")
            return
        }
        
        var annotations: [MAPointAnnotation] = []
        annotations = response.pois.map{
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees($0.location.latitude),
            longitude: CLLocationDegrees($0.location.longitude))
            if $0.distance < 200 {
                annotation.title = "红包车"
            }else {
                annotation.title = "非红包车"
            }
             return annotation
    }
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)

    }
    
    
    /// 自定义大头针
    ///
    /// - Parameters:
    ///   - mapView: view
    ///   - annotation: 标注
    /// - Returns: 大头针
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        guard !(annotation is MAUserLocation) else {
            return nil
        }
        let reuseId = "pointReuseIndetifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MAPinAnnotationView
        
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        
        if annotation.title == "红包车"{
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPacket")
        }else {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        }
        annotationView?.canShowCallout = true
        annotationView?.animatesDrop = true
       // annotationView!.isDraggable = true
        
        
        
        
        return annotationView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

