//
//  MessageController.swift
//  spot
//
//  Created by Hikaru on 2014/11/28.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class MessageController: UITableViewController, UITableViewDataSource, UITableViewDelegate,WebSocketHelperDelegate{
    
    var msg: [MessageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketHelper.instance.delegate = self
        
        //var img:UIImage = UIImage(named: "background")!
        //self.tableView.backgroundColor = UIColor(patternImage: img);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        var tableFrame = self.tableView.frame;
        
        tableFrame.size.height = self.tableView.frame.size.height - 44 ;
        
        self.tableView.frame = tableFrame;
        
        self.msg = TestData.instance.messageData(2)
        
        self.tableView.reloadData()
        self.tableView.scrollToRowAtIndexPath(
            NSIndexPath(forRow: self.msg.count-1, inSection: 0),
            atScrollPosition:.Bottom, animated:false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Section
    override func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msg.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let datarow = self.msg[indexPath.row];
        var cell = tableView.dequeueReusableCellWithIdentifier("cell_chat") as CellChat!
        if cell == nil {
            cell = CellChat(style: .Default, reuseIdentifier: "cell_chat")
        }
        let message = datarow.text
        var imageName = "user" + String(datarow.userid) + ".jpg"
        if(datarow.userid > 15){
            imageName = "user1.jpg"
        }
        cell.configureWithMessage(datarow.userid < 16,imageUrl: imageName,message: message)
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let datarow = self.msg[indexPath.row];
        
        return CommonHelper.instance.getFitHeight(tableView.bounds.size.width - 100, text: datarow.text, fontSize: messageFontSize)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let view:MessageController = segue.destinationViewController as MessageController;
        if let cell = sender as? MessageCell{
            view.title = cell.titleLable.text
        }else if let text = sender as? NSString{
            view.title = text
        }else{
            view.title = "詳細"
        }
        view.hidesBottomBarWhenPushed = true;
    }
    
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    //web socket
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    func whenError(errMessage:String){
        CommonHelper.instance.showDegInfo("errormessage: \(errMessage)")
    }
    func whenSuccess(ReceiveMessage:String){
        if "" != ReceiveMessage {
            let res = ReceiveMessage.match("(?<=\")(.*)(?=\")")//self.socketEvent
            if(res.count>0){
                self.msg.append(MessageModel(ID: self.msg.count, userid: TestData.instance.getIntRand(14) + 1, text: res[0], sentDate: NSDate()))
            }
        }
        self.tableView.reloadData()
        self.tableView.scrollToRowAtIndexPath(
            NSIndexPath(forRow: self.msg.count-1, inSection: 0),
            atScrollPosition:.Bottom, animated:false)
    }
    
    
}
