//
//  ViewController.swift
//  JYPageViewSwift
//
//  Created by hb on 2019/1/7.
//  Copyright © 2019 hb. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    fileprivate var pageView: JYPageView! = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "reload", style: .plain, target: self, action: #selector(self.reloadJYPageView))
        
        if #available(iOS 11, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let titles = [
            "测试分类01",
            "测试分类02",
            "测试分类03",
            "测试分类04",
            "测试分类05",
            "测试分类06",
            "测试分类07",
            "测试分类0000000000000000000000000000008"
        ]
        
        let imageInfos = [
            "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3699703635,816718470&fm=26&gp=0.jpg",
            "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3699703635,816718470&fm=26&gp=0.jpg",
            "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3699703635,816718470&fm=26&gp=0.jpg",
            "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3699703635,816718470&fm=26&gp=0.jpg",
            "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3699703635,816718470&fm=26&gp=0.jpg",
            "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3699703635,816718470&fm=26&gp=0.jpg",
            "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3699703635,816718470&fm=26&gp=0.jpg",
            "imageName1"
        ]
        
        let imageSelectedInfos = [
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3963687749,4116464709&fm=26&gp=0.jpg",
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3963687749,4116464709&fm=26&gp=0.jpg",
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3963687749,4116464709&fm=26&gp=0.jpg",
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3963687749,4116464709&fm=26&gp=0.jpg",
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3963687749,4116464709&fm=26&gp=0.jpg",
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3963687749,4116464709&fm=26&gp=0.jpg",
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3963687749,4116464709&fm=26&gp=0.jpg",
            "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3963687749,4116464709&fm=26&gp=0.jpg",
        ]
        
        var childs = [UIViewController]()
        for _ in 0..<titles.count {
            let child = UIViewController()
            child.view.backgroundColor = UIColor.randomColor()
            childs.append(child)
        }
        
        let top_height = navigationController!.navigationBar.bounds.size.height + UIApplication.shared.statusBarFrame.size.height
        let rect = CGRect(x: view.frame.origin.x,
                          y: top_height,
                          width: UIScreen.main.bounds.size.width,
                          height: UIScreen.main.bounds.size.height - top_height - 50)
        let style = JYPageTitleViewStyle()
        style.left_and_right_margin = 10;
        style.item_margin = 10
        style.title_view_position = .bottom
        style.image_view_height = 40
        style.image_view_width = 40
        style.is_hidden_when_only_one_item = true
        
        pageView = JYPageView(rect, style: style, titles: titles, imageInfos: imageInfos, imageSelectedInfos: imageSelectedInfos,  parent: self, childs: childs)
        pageView.delegate = self
        view.addSubview(pageView)
    }
    
    
    /// 刷新
    @objc func reloadJYPageView() {
        
        let titles = [
            "测0112321321321",
            "测01123123232121",
        ]
        
        let imageInfos = [
            "https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D220/sign=552789bf59df8db1b82e7b663923dddb/c2cec3fdfc039245dfcf69288094a4c27d1e259a.jpg",
            "https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D220/sign=552789bf59df8db1b82e7b663923dddb/c2cec3fdfc039245dfcf69288094a4c27d1e259a.jpg",
        ]
        
        let imageSelectedInfos = [
            "001",
            "002",
        ]
        var childs = [UIViewController]()
        
        for _ in 0..<titles.count {
            let child = UIViewController()
            child.view.backgroundColor = UIColor.randomColor()
            childs.append(child)
        }
        pageView.reload(with: titles, imageInfos: imageInfos, imageSelectedInfos: imageSelectedInfos, childs: childs)
    }
}

extension ViewController: JYPageViewDelegate {
    func pageView(_ pageMenu: JYPageView, didSelectedItemAt index: Int) {
        print(index)
    }
}

extension UIColor {
    public static func randomColor() -> UIColor {
        let r = CGFloat(arc4random()%255)
        let g = CGFloat(arc4random()%255)
        let b = CGFloat(arc4random()%255)
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}



