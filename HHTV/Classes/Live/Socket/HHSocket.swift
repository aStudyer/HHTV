//
//  HHSocket.swift
//  SocketClient
//
//  Created by aStudyer on 2019/10/3.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import Foundation
import SwiftSocket

protocol HHSocketDelegate : class {
    func socket(_ socket: HHSocket, joinRoom user: UserInfo)
    func socket(_ socket: HHSocket, leaveRoom user: UserInfo)
    func socket(_ socket: HHSocket, chatMsg: ChatMessage)
    func socket(_ socket: HHSocket, giftMsg: GiftMessage)
}

class HHSocket {
    weak var delegate: HHSocketDelegate?
    fileprivate var tcpClient: TCPClient
    fileprivate var timer : Timer?
    fileprivate var userInfo: UserInfo.Builder = {
        let userInfo = UserInfo.Builder()
        userInfo.name = "hh_\(arc4random_uniform(100) + 100)"
        userInfo.level = Int32(Int64(arc4random_uniform(20)))
        userInfo.iconUrl = "icon_\(userInfo.name)"
        return userInfo
    }()
    init(address: String, port: Int32){
        tcpClient = TCPClient(address: address, port: port)
    }
    deinit {
        timer?.invalidate()
        timer = nil
    }
}

extension HHSocket {
    @discardableResult
    func connectServer() -> Bool {
        switch tcpClient.connect(timeout: 5) {
        case .success:
            print("connect success, ready to read message from server!")
            startReadMessage()
            timer = Timer(timeInterval: 9, repeats: true, block: { [weak self] (_) in
                self?.sendHeartBeat()
            })
            RunLoop.current.add(timer!, forMode: .common)
            return true
        case .failure(let error):
            print("connect failure：\(error)")
            return false
        }
    }
    func startReadMessage() {
        DispatchQueue.global(qos: .background).async {
            while true {
                guard let lMsg = self.tcpClient.read(4) else {
                    sleep(1)
                    continue
                }
                // 1.读取长度的data
                let headerData = Data(bytes: lMsg, count: 4)
                var length: Int = 0
                (headerData as NSData).getBytes(&length, length: 4)

                // 2.读取类型
                guard let typeMsg = self.tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type: Int = 0
                (typeData as NSData).getBytes(&type, length: 2)

                // 3.根据长度和类型，读取真实消息
                guard let msg = self.tcpClient.read(length) else {
                    return
                }
                let data = Data(bytes: msg, count: length)

                // 4.处理消息
                DispatchQueue.main.async {
                    print("receive a new message of type \(type)")
                    self.handleMessage(type: type, data: data)
                }
            }
        }
    }
    fileprivate func handleMessage(type: Int, data: Data) {
        switch type {
        case 0, 1:
            if let user = try? UserInfo.parseFrom(data: data) {
                type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
            }
        case 2:
            if let chatMsg = try? ChatMessage.parseFrom(data: data) {
                delegate?.socket(self, chatMsg: chatMsg)
            }
        case 3:
            if let giftMsg = try? GiftMessage.parseFrom(data: data) {
                delegate?.socket(self, giftMsg: giftMsg)
            }
        default:
            print("未知类型")
        }
    }
}

extension HHSocket {
    func sendJoinRoom() {
        // 1.获取消息的长度
        if let msgData = try? userInfo.build().data() {
            // 2.发送消息
            sendMsg(data: msgData, type: 0)
        }
    }
    
    func sendLeaveRoom() {
        // 1.获取消息的长度
        if let msgData = try? userInfo.build().data() {
            // 2.发送消息
            sendMsg(data: msgData, type: 1)
        }
    }
    
    func sendTextMsg(message: String) {
        // 1.创建TextMessage类型
        let chatMsg = ChatMessage.Builder()
        chatMsg.text = message
        chatMsg.user = try! userInfo.build()
        // 2.获取对应的data
        if let chatData = try? chatMsg.build().data() {
            // 3.发送消息到服务器
            sendMsg(data: chatData, type: 2)
        }
    }
    
    func sendGiftMsg(giftName: String, giftURL: String, giftCount: Int) {
        // 1.创建GiftMessage
        let giftMsg = GiftMessage.Builder()
        giftMsg.giftname = giftName
        giftMsg.giftUrl = giftURL
        giftMsg.giftcount = Int32(giftCount)
        giftMsg.user = userInfo.buildPartial()
        // 2.获取对应的data
        if let giftData = try? giftMsg.build().data() {
            // 3.发送礼物消息
            sendMsg(data: giftData, type: 3)
        }
    }
    
    fileprivate func sendMsg(data: Data, type: Int) {
        // 1.将消息长度, 写入到data
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
        
        // 2.消息类型
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)
        
        // 3.发送消息
        let totalData = headerData + typeData + data
        switch tcpClient.send(data: totalData) {
        case .success:
            print("send success")
        case .failure(let error):
            print("send error：\(error)")
        }
    }
}

extension HHSocket {
    @objc fileprivate func sendHeartBeat() {
        print("💓💓💓💓💓💓💓💓💓")
        // 1.获取心跳包中的数据
        let heartString = "I am a heart beat"
        let heartData = heartString.data(using: .utf8)!
        
        // 2.发送数据
        sendMsg(data: heartData, type: 100)
    }
}
