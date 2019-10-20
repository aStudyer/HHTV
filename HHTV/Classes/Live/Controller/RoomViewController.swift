//
//  RoomViewController.swift
//  HHTV
//
//  Created by aStudyer on 2019/9/17.
//  Copyright © 2019 aStudyer. All rights reserved.
//

import UIKit

private let kChatToolsViewHeight : CGFloat = 44
private let kGiftlistViewHeight : CGFloat = kScreenH * 0.5

class RoomViewController: UIViewController, Emitterable {
    
    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    
    fileprivate lazy var chatToolsView: ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftListView: GiftListView = GiftListView.loadFromNib()
    private lazy var socket: HHSocket = HHSocket(address: "192.168.1.4", port: 9999)
    
    // MARK: 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UITextView.keyboardWillChangeFrameNotification, object: nil)
        
        if socket.connectServer() {
            socket.delegate = self
            socket.sendJoinRoom()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        socket.sendLeaveRoom()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- 设置UI界面内容
extension RoomViewController {
    fileprivate func setupUI() {
        setupBlurView()
        setupBottomView()
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    
    fileprivate func setupBottomView() {
        // 1.设置chatToolsView
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        
        // 2.设置giftListView
        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(giftListView)
        giftListView.delegate = self
    }
}

// MARK:- 事件监听
extension RoomViewController {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.giftListView.frame.origin.y = kScreenH
        })
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("点击了聊天")
            chatToolsView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            print("点击了礼物")
            UIView.animate(withDuration: 0.25, animations: {
                self.giftListView.frame.origin.y = kScreenH - kGiftlistViewHeight
            })
        case 3:
            print("点击了更多")
        case 4:
            print("点击了粒子")
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? startEmittering(point) : stopEmittering()
        default:
            fatalError("未处理按钮")
        }
    }
}

// MARK:- 监听键盘的弹出
extension RoomViewController {
    @objc fileprivate func keyboardWillChangeFrame(_ note : Notification) {
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        let curve = note.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: curve)!)
            let endY = inputViewY == (kScreenH - kChatToolsViewHeight) ? kScreenH : inputViewY
            self.chatToolsView.frame.origin.y = endY
        })
    }
}

// MARK:- 给服务器发送消息
extension RoomViewController : ChatToolsViewDelegate, GiftListViewDelegate {
    func chatToolsView(toolView: ChatToolsView, message: String) {
        socket.sendTextMsg(message: message)
    }
    
    func giftListView(giftView: GiftListView, giftModel: GiftModel) {
        socket.sendGiftMsg(giftName: giftModel.subject, giftURL: giftModel.img2, giftCount: 1)
    }
}

// MARK: - 接收服务器返回的消息
extension RoomViewController: HHSocketDelegate {
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
