//
//  JYPageContentView.swift
//  JYPageController
//
//  Created by hb on 2017/10/24.
//  Copyright © 2017年 com.bm.hb. All rights reserved.
//

import UIKit

public let k_content_cell_id = "kContentCellID"

/// Delegate
protocol JYPageContentViewDelegate: class {
    func contentView(_ contentView: JYPageContentView, didselectedItemAt index: Int)
}

/// View
class JYPageContentView: UIView {
    
    //MARK: - public models
    public weak var delegate: JYPageContentViewDelegate? = nil
    
    //MARK: - private models
    fileprivate weak var parent_controller: UIViewController!
    fileprivate var child_controllers = [UIViewController]()
    lazy var clv = { () -> UICollectionView in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: k_content_cell_id)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    fileprivate var current_index = 0
    fileprivate var is_forbid_scroll = false
    
    //MARK: - init
    convenience init(_ frame: CGRect, parent: UIViewController, childs:[UIViewController]) {
        self.init(frame: frame)
        self.parent_controller = parent
        self.child_controllers = childs
        ///
        for controller in self.child_controllers {
            self.parent_controller.addChild(controller)
        }
        addSubview(self.clv)
    }
    
    
    //MARK: - public functions
    
    /// 外界调用来更新滚动到选中的index
    ///
    /// - Parameters:
    ///   - index: 选中下标
    ///   - animate: 是否动画
    public func updateScrollToIndex(_ index: Int, animate: Bool) {
        clv.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: animate)
    }
    
    //MARK: - private functions
    
    /// 是否结束滚动
    fileprivate func contentViewEndScroll() {
        if !is_forbid_scroll {
            return
        }
        // 记录下标
        current_index = Int(self.clv.contentOffset.x / self.clv.bounds.size.width)
        // delegate 回调
        if let my_delegate = self.delegate {
            my_delegate.contentView(self, didselectedItemAt: current_index)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate
extension JYPageContentView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.child_controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: k_content_cell_id, for: indexPath)
        for v in cell.subviews {
            v.removeFromSuperview()
        }
        let controller = child_controllers[indexPath.item]
        cell.addSubview(controller.view)
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        cell.addConstraints([
            NSLayoutConstraint(item: controller.view, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: controller.view, attribute: .right, relatedBy: .equal, toItem: cell, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: controller.view, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: controller.view, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1, constant: 0)
            ])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !is_forbid_scroll {
            contentViewEndScroll()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        is_forbid_scroll = true
    }
    
}
