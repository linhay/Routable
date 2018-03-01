//
//  Timepiece
//  Pods
//
//  Created by naoty from https://github.com/naoty/Timepiece
//

import UIKit

public extension Date {

  public var now: Date{ return Date(timeIntervalSinceNow: 0) }

  public static func format(toString date:Date,mode: UIDatePickerMode) -> String {
    let dateFormatter = setDateFormatter(mode: mode)
    return dateFormatter.string(from: date)
  }

  public func format(mode: UIDatePickerMode) -> String {
    return Date.format(toString: self, mode: mode)
  }

  public static func initWith(string: String, mode: UIDatePickerMode) -> Date? {
    let dateFormatter = setDateFormatter(mode: mode)
    guard let date = dateFormatter.date(from: string) else {
      return nil
    }
    return date
  }

  private static func setDateFormatter(mode: UIDatePickerMode) -> DateFormatter{
    let dateFormatter = DateFormatter()
    switch mode {
    case .countDownTimer:
      dateFormatter.dateFormat = "ss.A"
    case .date:
      dateFormatter.dateFormat = "yyyy-MM-dd"
    case .dateAndTime:
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
    case .time:
      dateFormatter.dateFormat = "HH:mm:ss.A"
    }
    return dateFormatter
  }
}
