//
//  Model.swift
//  DonaldsDiary
//
//  Created by Connor Hutchinson on 24/10/20.
//

import Foundation
import SwifteriOS

protocol Refresh
{
    func updateUI();
}


class TwitterAPI_Access {
    
    static let sharedInstance = TwitterAPI_Access();
    
    private let url:String = "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=realDonaldTrump&exclude_replies=true"
    private var session:URLSession = URLSession.shared;
    var delegate: Refresh?


    var tweets:[String] = [];
    var dates:[String] = [];
    
    
    func getTweets(){
        //seperate private class and function to hide my keys and authentication etc
        let oAuth = OAuth()
        
        let swifter = Swifter(consumerKey: oAuth.consumer_key, consumerSecret: oAuth.consumer_secret)
        
        swifter.getTimeline(for: .screenName("realDonaldTrump"), customParam:["tweet_mode":"extended"], count: 50, sinceID: nil, maxID: nil, trimUser: nil, excludeReplies: true, includeRetweets: false, contributorDetails: false, includeEntities: false, tweetMode: TweetMode.extended,
        
        //swifter.getTimeline(for: .screenName("realDonaldTrump"), customParam: ["tweet_mode":"extended"],
        
        success: { json in
            
            let texts = json.array
            

                for next in texts! {
             
                    if var tweetText = next["full_text"].string {
                        
                        
                        if !tweetText.prefix(4).contains("RT") && !tweetText.prefix(4).contains("http"){
                            
                            if(tweetText.contains("http")){
                                
                                for substring in tweetText.components(separatedBy: " ")
                                {
                                    if substring.contains("http"){
                                        tweetText = tweetText.replacingOccurrences(of: substring, with: "",options: [.caseInsensitive,.regularExpression])
                                    }
                                    
                                    for scalar in substring.unicodeScalars {
                                        let isEmoji = scalar.properties.isEmoji
                                        if isEmoji{
                                            tweetText = tweetText.replacingOccurrences(of: substring, with: "",options: [.caseInsensitive,.regularExpression])
                                        }
                                        
                                    }
                                    
                                    
                                }
                            }
                            self.tweets.append(tweetText)
                            print(tweetText + "\n")
                            self.dates.append(next["created_at"].string!)
                            DispatchQueue.main.async(execute:{
                                self.delegate?.updateUI()
                            })
                        }
                    }
                }
 
 
        },
        failure: {_ in
            print()
            
        }
        )
        
        
    }

    
    func getData(_ request: URLRequest)
    {
        let task = session.dataTask(with: request, completionHandler: {
            data, response, downloadError in
            
            if let error = downloadError{
                print(error)
            }
            else{
                
                var result:Any! = nil;
                do{
                    
                    result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                }
                catch{
                    print()
                }
                if let result = result {
                    if let texts = result as? NSArray {
                    
                    for next in texts {
                        let tweet = next as! NSDictionary
                        if var tweetText = tweet["text"] as? String {
                            
                            
                            if !tweetText.prefix(4).contains("RT") && !tweetText.prefix(4).contains("http"){
                                
                                if(tweetText.contains("http")){
                                    
                                    for substring in tweetText.components(separatedBy: " ")
                                    {
                                        if substring.contains("http"){
                                            tweetText = tweetText.replacingOccurrences(of: substring, with: "",options: [.caseInsensitive,.regularExpression])
                                        }
                                        
                                        for scalar in substring.unicodeScalars {
                                            let isEmoji = scalar.properties.isEmoji
                                            if isEmoji{
                                                tweetText = tweetText.replacingOccurrences(of: substring, with: "",options: [.caseInsensitive,.regularExpression])
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                }
                                self.tweets.append(tweetText)
                                self.dates.append(tweet["created_at"] as! String)
                            }
                        }
                    }
                    }else{
                        self.tweets.append("I didn't wite anything today :o")
                        self.dates.append("")
                    }
                }
            }
           
            DispatchQueue.main.async(execute:{
                self.delegate?.updateUI()
            })
            
        })
        task.resume()
        
        
    }
    
    
    
    private init(){};
    
}
