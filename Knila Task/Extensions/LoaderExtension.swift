//
//  LoaderExtension.swift
//  Knila Task
//
//  Created by Pavan Kumar Mathala on 06/03/21.
//

import UIKit

var loader: UIView?
extension UIViewController {
    func showLoader() {
        DispatchQueue.main.async {
            let loaderView = UIView.init(frame: self.view.bounds)
            loaderView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            let activityIndicator = UIActivityIndicatorView.init(style: .large)
            //        activityIndicator.color = .black
            activityIndicator.startAnimating()
            activityIndicator.center = loaderView.center
            
            loaderView.addSubview(activityIndicator)
            self.view.addSubview(loaderView)
            loader = loaderView
        }
    }
    
    func removeLoader() {
        DispatchQueue.main.async {
            loader?.removeFromSuperview()
            loader = nil
        }
    }
    
    func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
