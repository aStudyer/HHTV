//
//  ServerManager.swift
//  SocketServer
//
//  Created by aStudyer on 2019/10/2.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import Cocoa
import SwiftSocket

class ServerManager: NSObject {
    fileprivate lazy var server: TCPServer = TCPServer(address: "0.0.0.0", port: 9999)
    fileprivate var isServerRunning: Bool = false
    fileprivate lazy var clientManagers: [ClientManager] = [ClientManager]()
}
extension ServerManager {
    func startRunning() {
        isServerRunning = true
        // 1.开启监听
        switch server.listen() {
        case .success:
            // 2.开始接受客户端
            DispatchQueue.global().async {
                while self.isServerRunning {
                    if let client = self.server.accept() {
                        print("newclient from：\(client.address)[\(client.port)]")
                        DispatchQueue.global().async {
                            self.handleClient(client)
                        }
                    } else {
                        print("accept error")
                    }
                }
            }
        case .failure(let error):
            print("listen error：\(error)")
        }
    }
    func stopRunning() {
        isServerRunning = false
        server.close()
    }
}
extension ServerManager {
    fileprivate func handleClient(_ client: TCPClient) {
        // 1.用一个ClientManager管理TCPClient
        let manager = ClientManager(client)
        manager.delegate = self
        // 2.保存客户端
        clientManagers.append(manager)
        // 3.client开始接收消息
        manager.startReadMessage()
    }
}
extension ServerManager: ClientManagerDelegate {
    func sendMessageToClient(_ data: Data) {
        for manager in clientManagers {
            switch manager.tcpClient.send(data: data) {
            case .failure(let error):
                print("send failure：\(error)")
            default:
                break
            }
        }
    }
    func removeClient(_ client: ClientManager) {
        guard let index = clientManagers.firstIndex(of: client) else {
            return
        }
        clientManagers.remove(at: index)
    }
}
