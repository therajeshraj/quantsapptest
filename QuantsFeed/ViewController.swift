//
//  ViewController.swift
//  QuantsFeed
//
//  Created by Rajesh on 15/08/20.
//  Copyright © 2020 Rajesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var feeds : FeedModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callApi()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feeds?.feed?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "feedCell") as! FeedsTableViewCell
        
        cell.postName.text = self.feeds?.feed?[indexPath.row].name ?? ""
        
        let datetmp = self.feeds?.feed?[indexPath.row].timeStamp ?? ""
        
        if(datetmp != "") {
            cell.postTime.text = timeAgoSinceDate(date: getReadableDate(timeStamp: Double(datetmp)!)!, numericDates: false)
        }
        
        //cell.postTime.text = self.feeds?.feed?[indexPath.row].timeStamp ?? ""
        cell.postDesc.text = self.feeds?.feed?[indexPath.row].status ?? ""
        
        let profileUrl = self.feeds?.feed?[indexPath.row].profilePic ?? ""
        let imgUrl = self.feeds?.feed?[indexPath.row].url ?? ""
        
        
        
        
        if profileUrl != "" {
            cell.postProfile.imageFromURL(imgUrl: profileUrl)
        }
        
        if imgUrl != "" {
            cell.postProfile.imageFromURL(imgUrl: imgUrl)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let status = self.feeds?.feed?[indexPath.row].status ?? ""
        
        let height = estimatedHeightOfLabel(text: status)
        
        print("Hello\(height)")
        return 200 + height
        
        
        
    }
    
    func estimatedHeightOfLabel(text: String) -> CGFloat {

        let size = CGSize(width: view.frame.width - 20, height: 1000)

        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]

        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height

        return rectangleHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var url : NSURL?
        
        let urlString = self.feeds?.feed?[indexPath.row].url ?? ""
        
        if (urlString != "") {
            url = NSURL(string: urlString)
        }
        
        if url != nil{
            UIApplication.shared.openURL(url! as URL)
        }
        
    }
    
    
    func callApi(){
       
        APIManager.shared.callAPI(urlString: "feed.json", method: "GET", params: nil, type: FeedModel.self) { (json) in
            self.feeds = json
            
            DispatchQueue.main.async {
                self.feeds = json
                self.feedTableView.reloadData()
            }
            
       }
        
    }
    
    func getReadableDate(timeStamp: TimeInterval) -> NSDate? {
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.locale = Locale.init(identifier: "en")
        let strDate = dateFormatter.string(from: date as Date)
        let actDate = dateFormatter.date(from: strDate)
        
        return actDate as NSDate?
        
    }
    
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)

        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }

    }
    

    
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
}


extension UIImageView {
    public func imageFromURL(imgUrl: String) {
        if (imgUrl != "") {
            let str = imgUrl
            
            URLSession.shared.dataTask(with: NSURL(string: str)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    if image != nil{
                        self.image = image
                    }else{
                        self.image = UIImage.init(named: "")
                    }
                })
            }).resume()
        }
    }
}
