//
//  BLFoundation
//  Pods
//
//  Created by BigL on 2017/9/15.
//

import UIKit

extension Data {
  // http://stackoverflow.com/questions/39248092/nsattributedstring-extension-in-swift-3
  @available(iOS 9.0,*)
  public var attributedString: NSAttributedString? {
    do {
      return try NSAttributedString(data: self, options:[NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    return nil
  }
}
