//
//  CustomImageView.swift
//  iOSProficiencyExercise
//
//  Created by Rishabh Mathur on 04/04/20.
//  Copyright © 2020 Rishabh Mathur. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
  
  var imageURLString: String?
  
  func addLoader() {
    let loaderView = UIView()
    loaderView.tag = Constants.loadingImageViewTag
    loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    addSubview(loaderView)
    
    loaderView.translatesAutoresizingMaskIntoConstraints = false
    loaderView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    loaderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    loaderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    loaderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
    let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    activityIndicatorView.color = .white
    loaderView.addSubview(activityIndicatorView)
    
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor).isActive = true
    activityIndicatorView.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor).isActive = true
    
    activityIndicatorView.startAnimating()
  }
  
  func removeLoader() {
    if let loaderView = subviews.filter({ $0.tag == Constants.loadingImageViewTag }).first, let activityIndicatorView = loaderView.subviews.first as? UIActivityIndicatorView {
      
      activityIndicatorView.stopAnimating()
      activityIndicatorView.removeFromSuperview()
      loaderView.removeFromSuperview()
    }
  }
  
  func setImageFromURL(urlString: String) {
    
    imageURLString = urlString
    
    guard let url = URL(string: urlString) else {
      self.image = UIImage(named: "sampleImage")
      return
    }
    
    image = nil
    
    if let imageFromCache = CacheManager.shared.objectFromCache(withKey: urlString) as? UIImage {
      image = imageFromCache
      return
    }
    
    self.addLoader()
    DispatchQueue.global().async {
      var imageToCache: UIImage!
      if let data = try? Data(contentsOf: url) {
        imageToCache = UIImage(data: data)
      } else {
        imageToCache = UIImage(named: "sampleImage")
      }
      
      DispatchQueue.main.async {
        if self.imageURLString == urlString {
          self.image = imageToCache
        }
        
        self.removeLoader()
        
        CacheManager.shared.addToCache(objectToCache: imageToCache!, withKey: urlString)
      }
    }
  }
}