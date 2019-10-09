//
//  ViewController.swift
//  SocketClient
//
//  Created by aStudyer on 2019/10/3.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import UIKit
import SwiftSocket

/*
 1> 获取到服务器对应的IP/端口号
 2> 使用Socket, 通过IP/端口号和服务器建立连接
 3> 开启定时器, 实时让服务器发送心跳包
 4> 通过sendMsg, 给服务器发送消息: 字节流 --> headerData(消息的长度) + typeData(消息的类型) + MsgData(真正的消息)
 5> 读取从服务器传送过来的消息(开启子线程)
 */

class ViewController: UIViewController {
    private lazy var socket: HHSocket = HHSocket(address: "192.168.1.4", port: 9999)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func connectServer() {
        if socket.connectServer() {
            socket.delegate = self
        }
    }
    /*
     进入房间 = 0
     离开房间 = 1
     文本 = 2
     礼物 = 3
     */
    @IBAction func joinRoom() {
        socket.sendJoinRoom()
    }
    
    @IBAction func leaveRoom() {
        socket.sendLeaveRoom()
    }
    
    @IBAction func sendText() {
        socket.sendTextMsg(message: "这是一个文本消息")
    }
    
    @IBAction func sendGift() {
        socket.sendGiftMsg(giftName: "火箭", giftURL: "http://www.baidu.com", giftCount: 1000)
    }
}

extension ViewController: HHSocketDelegate {
    func socket(_ socket: HHSocket, joinRoom user: UserInfo) {
        print("\(String(describing: user.name))进入了房间")
    }
    func socket(_ socket: HHSocket, leaveRoom user: UserInfo) {
        print("\(String(describing: user.name))离开了房间")
    }
    func socket(_ socket: HHSocket, chatMsg: ChatMessage) {
        print("\(String(describing: chatMsg.user.name))说：\(String(describing: chatMsg.text))")
    }
    func socket(_ socket: HHSocket, giftMsg: GiftMessage) {
        print("\(String(describing: giftMsg.user.name))送出了\(String(describing: giftMsg.giftname))")
    }
}
