//
//  BLKit.h
//  Pods
//
//  Created by BigL on 2017/9/16.
//

import UIKit

public protocol SPCellProtocol: class {
  static var id: String { get }
  static  var nib: UINib? { get }
}

public extension SPCellProtocol {
  static public var id: String { return String(describing: Self.self) }
  static public var nib: UINib? { return nil }
}

public protocol SPNibProtocol: SPCellProtocol { }

public extension SPNibProtocol {
  static public var nib: UINib? {
    return UINib(nibName: String(describing: Self.self), bundle: nil)
  }
}

public extension BLExtension where Base: UITableView{

  public func register<T: UITableViewCell>(_ cell: T.Type) where T: SPCellProtocol {
    if let nib = T.nib {
      base.register(nib, forCellReuseIdentifier: T.id)
    } else {
      base.register(T.self, forCellReuseIdentifier: T.id)
    }
  }

  public func dequeueCell<T: SPCellProtocol>(_ indexPath: IndexPath) -> T {
    return base.dequeueReusableCell(withIdentifier: T.id, for: indexPath) as! T
  }

  public func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: SPCellProtocol {
    if let nib = T.nib {
      base.register(nib, forHeaderFooterViewReuseIdentifier: T.id)
    } else {
      base.register(T.self, forHeaderFooterViewReuseIdentifier: T.id)
    }
  }

  public func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: SPCellProtocol {
    return base.dequeueReusableHeaderFooterView(withIdentifier: T.id) as! T
  }
}

public extension BLExtension where Base: UICollectionView {

  public func register<T: UICollectionViewCell>(_ cell: T.Type) where T: SPCellProtocol {
    if let nib = T.nib {
      base.register(nib, forCellWithReuseIdentifier: T.id)
    } else {
      base.register(T.self, forCellWithReuseIdentifier: T.id)
    }
  }

  public func dequeueCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T where T: SPCellProtocol {
    return base.dequeueReusableCell(withReuseIdentifier: T.id, for: indexPath) as! T
  }

  public func registerSupplementaryView<T: SPCellProtocol>(elementKind: String, _: T.Type) {
    if let nib = T.nib {
      base.register(nib,
                    forSupplementaryViewOfKind: elementKind,
                    withReuseIdentifier: T.id)
    } else {
      base.register(T.self,
                    forSupplementaryViewOfKind: elementKind,
                    withReuseIdentifier: T.id)
    }
  }

  public func dequeueSupplementaryView<T: UICollectionViewCell>(elementKind: String, indexPath: IndexPath) -> T where T: SPCellProtocol {
    return base.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                 withReuseIdentifier: T.id,
                                                 for: indexPath) as! T
  }
}
