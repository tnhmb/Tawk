//
//  Extensions.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit

import UIKit

extension UIImageView {
    func loadImage(from urlString: String, completion: ((UIImage?) -> Void)? = nil, failure: ((ErrorEntity) -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            failure?(ErrorEntity(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        // Check if the image is available in the cache
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            // Use the cached image
            self.image = image
            completion?(image)
            return
        }
        
        // Create a URLSessionDataTask to download the image
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                failure?(ErrorEntity(error: error))
            } else if let data = data, let image = UIImage(data: data) {
                let cachedResponse = CachedURLResponse(response: response!, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                
                // Display the downloaded image on the main queue
                DispatchQueue.main.async {
                    self.image = image
                    completion?(image)
                }
            }
        }
        
        // Start the data task
        task.resume()
    }
}

extension UIViewController {
    func showErrorMessage(_ message: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: "Tawk", message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .cancel) { (action) in
            completion?()
        }
        
        alertController.addAction(okButton)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
extension UIView {
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutAttachAll()
        return contentView
    }
    
    /// attaches all sides of the receiver to its parent view
    func layoutAttachAll(margin : CGFloat = 0.0) {
        let view = superview
        layoutAttachTop(to: view, margin: margin)
        layoutAttachBottom(to: view, margin: margin)
        layoutAttachLeading(to: view, margin: margin)
        layoutAttachTrailing(to: view, margin: margin)
    }
    
    /// attaches the top of the current view to the given view's top if it's a superview of the current view, or to it's bottom if it's not (assuming this is then a sibling view).
    /// if view is not provided, the current view's super view is used
    @discardableResult
    func layoutAttachTop(to: UIView? = nil, margin : CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = view == superview
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: isSuperview ? .top : .bottom, multiplier: 1.0, constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the bottom of the current view to the given view
    @discardableResult
    func layoutAttachBottom(to: UIView? = nil, margin : CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: isSuperview ? .bottom : .top, multiplier: 1.0, constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the leading edge of the current view to the given view
    @discardableResult
    func layoutAttachLeading(to: UIView? = nil, margin : CGFloat = 0.0) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: isSuperview ? .leading : .trailing, multiplier: 1.0, constant: margin)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    /// attaches the trailing edge of the current view to the given view
    @discardableResult
    func layoutAttachTrailing(to: UIView? = nil, margin : CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: isSuperview ? .trailing : .leading, multiplier: 1.0, constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)
        
        return constraint
    }
}
