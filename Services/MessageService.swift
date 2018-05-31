//
//  MessageService.swift
//  Smack
//
//  Created by Rafał Chołody on 22/05/2018.
//  Copyright © 2018 Rafał Chołody. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    //Singleton
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel : Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).response { (response) in
            //In AuthSerive we use response.result.error
            //Work without?
            if response.error == nil {
                guard let data = response.data else { return }
                //JSON parsing using JSONDecoder with Swift 4.0
                //To use it you need to use variables with the same names as in Postman file JSON
                //Also you need to extend your Channel struct with Decodable
                //Also comment the otherway without JSONDecoder
                
//                do {
//                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
//                } catch let error {
//                    debugPrint(error as Any)
//                }
//                print(self.channels)
                //Without using JSONDecoder
                do {
                if let json = try JSON(data: data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                    //print(self.channels[0].channelTitle)
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                }
                } catch  {
                    debugPrint(error)
                }
            } else {
                completion(false)
                debugPrint(response.error as Any)
            }
        }
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseData { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else { return }
                do{
                if let json = try JSON(data: data).array {
                    for item in json {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)
                       
                    }
                    print(self.messages)
                     completion(true)
                }
                
                }
                catch  {
                    debugPrint(error)
                }
            }else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
        
        
        
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
    
}
