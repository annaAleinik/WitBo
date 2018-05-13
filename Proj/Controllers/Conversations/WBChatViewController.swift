//
//  WBChatViewController.swift
//  Proj
//
//  Created by  Anita on 4/22/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import NoChat

protocol WBChatViewControllerDelegate {
    func sendMessage(msg:Message)
}


class WBChatViewController: NOCChatViewController, SocketManagerDelegate {

    var delegate: WBChatViewControllerDelegate?
    var layoutQueue = DispatchQueue(label: "com.little2s.nochat-example.mm.layout", qos: DispatchQoS(qosClass: .default, relativePriority: 0))
    
    override func loadView() {
        super.loadView()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isInverted = false

    }
    
    override func viewDidLoad() {
        SocketManager.sharedInstanse.delegate = self
        self.registerChatItemCells()
        self.collectionView?.backgroundView = UIView(frame: CGRect.zero)
        self.collectionView?.backgroundColor = UIColor.clear
        self.containerView?.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }
    
    override func registerChatItemCells() {
        var nibName = UINib(nibName: "IncomingMessageCell", bundle:nil)
        collectionView?.register(nibName, forCellWithReuseIdentifier: "IncomingTextCell")
        
        nibName = UINib(nibName: "OutgoingMessageCell", bundle:nil)
        collectionView?.register(nibName, forCellWithReuseIdentifier: "OutgoingTextCell")
    }
    

    
    override class func cellLayoutClass(forItemType type: String) -> Swift.AnyClass? {
        if type == "Text" {
            return MessageCellLayout.self
        } else {
            return nil
        }
    }
    
    override class func inputPanelClass() -> Swift.AnyClass? {
        return СhatInputTextPanel.self
    }

    //MARK: InputPanelDelegate
    func didInputTextPanelStartInputting(_ inputTextPanel: СhatInputTextPanel) {
        if isScrolledAtBottom() == false {
            scrollToBottom(animated: true)
        }
    }
    
    func inputTextPanel(_ inputTextPanel: СhatInputTextPanel, requestSendText text: String) {
        let msg = Message()
        msg.text = text
        if (delegate != nil) {
            delegate?.sendMessage(msg: msg)
        }
    }

    
    
    //MARK: SocketManagerDelegate
    func didReciveMessages(messages: Message) {
        print(messages)
        addMessages([messages], scrollToBottom: true, animated: true)
    }
    
    func conversationStopped() {
        
    }
    
    
    
    private func addMessages(_ messages: [Message], scrollToBottom: Bool, animated: Bool) {
        layoutQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            let count = strongSelf.layouts.count
            let indexes = IndexSet(integersIn: count..<count+messages.count)
            
            var layouts = [NOCChatItemCellLayout]()
            DispatchQueue.main.async {
                for message in messages {
                    let layout = strongSelf.createLayout(with: message)!
                    layouts.append(layout)
                }
            }
            
            DispatchQueue.main.async {
                strongSelf.insertLayouts(layouts, at: indexes, animated: animated)
                if scrollToBottom {
                    strongSelf.scrollToBottom(animated: animated)
                }
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            for layout in self.layouts {
                if let castLayout = layout as? NOCChatItemCellLayout {
                    castLayout.calculate()
                }
            }
            
            self.collectionView?.reloadData()
            self.collectionView?.setNeedsLayout()
            self.collectionView?.layoutIfNeeded()
        }
    }

}

