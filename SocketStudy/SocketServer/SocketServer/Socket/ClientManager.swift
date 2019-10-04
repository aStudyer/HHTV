//
//  ClientManager.swift
//  SocketServer
//
//  Created by aStudyer on 2019/10/2.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import Cocoa
import SwiftSocket

protocol ClientManagerDelegate : class {
    func sendMessageToClient(_ data: Data)
}

class ClientManager: NSObject {
    var tcpClient: TCPClient
    
    weak var delegate: ClientManagerDelegate?
    
    fileprivate var isClientConnected: Bool = false
    
    init(_ client: TCPClient) {
        self.tcpClient = client
    }
}
extension ClientManager {
    func startReadMessage() {
        isClientConnected = true
        while isClientConnected {
            if let lMsg = tcpClient.read(4) {
                // 1.读取长度的data
                let headerData = Data(bytes: lMsg, count: 4)
                var length: Int = 0
                (headerData as NSData).getBytes(&length, length: 4)
                
                // 2.读取类型
                guard let typeMsg = tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type: Int = 0
                (typeData as NSData).getBytes(&type, length: 2)
                
                // 3.根据长度和类型，读取真实消息
                guard let msg = tcpClient.read(length) else {
                    return
                }
                let data = Data(bytes: msg, count: length)
                
                delegate?.sendMessageToClient(headerData + typeData + data)
            } else {
                isClientConnected = false
                print("client [\(tcpClient.address):\(tcpClient.port)] is closed")
                tcpClient.close()
            }
        }
    }
}
