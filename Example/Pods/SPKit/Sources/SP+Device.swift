//
//  DeviceInfo.swift
//  B7iOS
//
//  Created by 膳品科技 on 16/9/2.
//  Copyright © 2016年 Buy.Spzjs.iPhone. All rights reserved.
//

import UIKit
public struct Device {

  public static let infoDic = Bundle.main.infoDictionary

  public enum DeviceType: Int {
    case iPhone_SE
    case iPhone_S
    case iPhone_Plus
    case iPhone_X
    case unknown
  }

  public static var type: DeviceType {
    let size = UIScreen.main.bounds.size
    switch (size.width,size.height){
    case (812,375),(375,812): return .iPhone_X
    case (736,414),(414,736): return .iPhone_Plus
    case (667,375),(375,667): return .iPhone_S
    case (568,320),(320,568): return .iPhone_SE
    default:  return .unknown
    }
  }

  /// 获取设备名称
  public static let deviceName = UIDevice.current.name
  /// 获取系统版本号
  public static let sysVersion = UIDevice.current.systemVersion
  /// 获取设备唯一标识符
  public static let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
  /// 获取设备的型号
  public static let deviceModel = UIDevice.current.model

  // 获取App的版本号
  public static let appVersion = infoDic?["CFBundleShortVersionString"]
  // 获取App的build版本
  public static let appBuildVersion = infoDic?["CFBundleVersion"]
  // 获取App的名称
  public static let appName = infoDic?["CFBundleDisplayName"]

}

