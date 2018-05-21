//
//  URLUnitCell.swift
//  Routable_Example
//
//  Created by linhey on 2018/4/20.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SPKit
import SPRoutable
import Then
import SnapKit

class URLReturnValueCell: UITableViewCell,SPCellProtocol{
  
  let backView = UIView().then { (item) in
    item.layer.cornerRadius = 2
    item.sp.setShadow(color: UIColor.black.withAlphaComponent(0.5),
                      offset: CGSize(width: -0.5, height: -0.5),
                      radius: 5)
  }
  
  let label = UILabel().then { (item) in
    item.font = UIFont.boldSystemFont(ofSize: 15)
    item.textColor = UIColor.black
    item.numberOfLines = 0
  }
  
  let leftBtn = UIButton().then { (item) in
    item.titleLabel?.numberOfLines = 0
    item.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    item.setBackgroundColor(color: .red, for: .normal)
    item.setTitleColor(.white, for: .normal)
  }
  
  let rightBtn = UIButton().then { (item) in
    item.titleLabel?.numberOfLines = 0
    item.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    item.setBackgroundColor(color: .black, for: .normal)
    item.setTitleColor(.white, for: .normal)
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(backView)
    backView.addSubview(label)
    backView.addSubview(leftBtn)
    backView.addSubview(rightBtn)
    
    backView.snp.makeConstraints { (make) in
      make.top.left.equalToSuperview().offset(5)
      make.right.bottom.equalToSuperview().offset(-5)
    }
    
    label.snp.makeConstraints { (make) in
      make.top.left.right.equalToSuperview()
      make.height.greaterThanOrEqualTo(60)
    }
    
    leftBtn.snp.makeConstraints { (make) in
      make.bottom.left.equalToSuperview()
      make.height.equalTo(45)
      make.width.equalToSuperview().multipliedBy(0.5)
      make.top.equalTo(label.snp.bottom)
    }
    
    rightBtn.snp.makeConstraints { (make) in
      make.bottom.right.equalToSuperview()
      make.top.equalTo(label.snp.bottom)
      make.left.equalTo(leftBtn.snp.right)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
