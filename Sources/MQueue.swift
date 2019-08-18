//
//  MQueue.swift
//  swiftNSOpertionQueue
//
//  Created by 洪绵卫 on 2017/12/1.
//  Copyright © 2017年 洪绵卫. All rights reserved.
//

import UIKit

typealias usualBlock = ()->()

class MQueue: NSObject {
    
    /// 创建一个操作任务队列
    ///
    /// - Returns: 操作任务队列
    public class func createOperationQueue() -> OperationQueue {
        return OperationQueue()
    }
 
    /// 创建一个操作任务
    ///
    /// - Returns: 操作任务
    public class func createOperation() -> Operation {
        return Operation ()
    }
    
    /// 开一个分线程
    ///
    /// - Parameter block: 闭包回调执行返回Code
    public class func asyncQueueCompleteBlock(block:@escaping usualBlock){
        
        //创建操作队列
        let queue = OperationQueue()
        
        //创建操作任务
        let operation = BlockOperation()
                
        //优先级
        operation.queuePriority = .normal
        
        //执行内容
        operation.addExecutionBlock {
            block()
        }
        
        //将操作任务加入操作队列
        queue.addOperation(operation)
    }
    
    /// 返回主线程
    ///
    /// - Parameter block: 闭包回调执行返回Code
    public class func getMainQueque(block:@escaping usualBlock){
        
        //获取主线程操作队列
        OperationQueue.main.addOperation {
            block()
        }
    }
    
    /// 设置队列中的最大并发数(队列最多执行多少个操作)
    ///
    /// (最大并发数（5以内），不要开太多，一般以2~3为宜)
    ///
    /// - Parameters:
    ///   - max: 并发数
    ///   - targetQueue: 目标队列
    public class func setQueueMaxConcurrentOperationCount(max:Int,targetQueue:OperationQueue){
        targetQueue.maxConcurrentOperationCount = max
    }
    
    /// 添加依赖关系
    ///
    /// 描述： operation 必须得等 toOperation 执行完成 再执行
    ///
    /// - Parameters:
    ///   - operation1: 依赖者
    ///   - targetOperation: 被依赖的操作
    public class func  adddependencyToOperation(operation1:Operation,targetOperation:Operation){
        operation1.addDependency(targetOperation)
    }
    
    /// 堵塞一个线程 等待某个任务执行完毕
    ///
    /// - Parameter targetOperation: 等待的目标任务
    public class func waitUntilFinishedWithOperation(targetOperation:Operation){
        targetOperation.waitUntilFinished()
    }
    
    /// 阻塞当前线程，等待queue的所有操作执行完毕
    ///
    /// - Parameter targetQueue: 目标队列
    public class func waitUntilAllOperationsAreFinished(targetQueue:OperationQueue){
        targetQueue.waitUntilAllOperationsAreFinished()
    }
    
    
    /// 获取该队列中所有的操作
    ///
    /// - Parameter targetQueue: 目标队列
    /// - Returns: [Operation] 操作任务元组
    public class func getQueueAllOperations(targetQueue:OperationQueue)->[Operation]{
        return targetQueue.operations
    }
    
    /// 暂停/继续一个队列
    ///
    /// - Parameters:
    ///   - targetQueue: 目标队列
    ///   - isSuspended: true 暂停 false 继续
    public class func setSuspended(targetQueue:OperationQueue,isSuspended:Bool){
        targetQueue.isSuspended = isSuspended
    }
    
    
    /// 取消单个操作任务
    ///
    /// - Parameter targetOper: 目标操作任务
    public class func cancelOperation(targetOper:Operation){
        targetOper.cancel()
    }
    
    /// 取消该操作队列中的所有操作
    ///
    /// - Parameter targetQueue: 目标操作任务队列
    public class func cancelQueueAllOperations(targetQueue:OperationQueue){
        targetQueue.cancelAllOperations()
    }
    
    /// 在多少秒之后加入主线程队列中
    ///
    /// - Parameters:
    ///   - seconds: 距离时间(秒)
    ///   - block: 执行内容
    public class func asyncAfter(seconds:Float,block:@escaping usualBlock){
    DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + .milliseconds(Int(seconds * 1000.0))) {
           block()
        }
    }
}







