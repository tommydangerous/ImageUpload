//
//  ViewController.swift
//  ImageUpload
//
//  Created by Tommy DANGerous on 1/23/15.
//  Copyright (c) 2015 Quantum Ventures. All rights reserved.
//

import UIKit

import Alamofire

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let screen = UIScreen.mainScreen().bounds
    self.view = UIView(frame: CGRect(x: 0, y: 0, width: screen.width, height: screen.height))
    self.view.backgroundColor = UIColor.redColor()

    let imageData = downloadImage({ (data: NSData) in
      let image = UIImage(data: data)
      let imageView = UIImageView(image: image)
      imageView.frame = self.view.bounds
      self.view.addSubview(imageView)

      let jData = self.jpegData(image!)

      self.uploadImage(jData)
    })
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func downloadImage(callback: (data: NSData) -> ()) -> NSData? {
    var imageData: NSData?
    let url =
      "http://qph.is.quoracdn.net/main-thumb-3930434-50-MIqoe1Rb3kvQQYHzojAF3HJeKLk2G7O4.jpeg"
    Alamofire.request(.GET, url).response { (_, _, data, _) in
      if (data != nil) {
        imageData = data as? NSData
        callback(data: imageData!)
      }
    }
    return imageData
  }

  func jpegData(image: UIImage) -> NSData {
    return UIImageJPEGRepresentation(image, 0.1)
  }

  func imageStringFromData(data: NSData) -> String {
    // Get the data into a string
    let stringFromData = "\(data)"
    // Remove white space from the string
    var imageString = stringFromData.stringByReplacingOccurrencesOfString(" ",
      withString: "")

    // Remove < and > from string
    let startIndex = advance(imageString.startIndex, 1)
    let endIndex = advance(imageString.endIndex, -1)
    let range = startIndex..<endIndex
    imageString = imageString.substringWithRange(range)

    return imageString
  }

  func uploadImage(data: NSData) {
    let url = NSURL(string: "http://54.177.86.14:3002/api/v1/listings")
    var request = NSMutableURLRequest(URL: url!)
    var session = NSURLSession.sharedSession()

    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.HTTPMethod = "POST"

    let dict = [
      "address": "123 fun street",
      "city": "santa clara",
      "state": "ca",
      "zip": "95050",
      "parking_spots": "1",
      "available_on": "2014-05-01",
      "bedrooms": "2",
      "bathrooms": "5",
      "deposit": "3432",
      "rent": "2355",
      "title": "hey what is up",
      "type": "house",
      "images_attributes": [
        ["image_data": imageStringFromData(data)]
      ]
    ]
    let body = NSJSONSerialization.dataWithJSONObject(dict,
      options: nil, error: nil)

    request.HTTPBody = body

    var returnData = NSURLConnection.sendSynchronousRequest(request,
      returningResponse: nil, error: nil)
    println(returnData)
  }
}
