//
//  CMFilePathTool.swift
//  localService
//
//  Created by 洪绵卫 on 2018/1/24.
//  Copyright © 2018年 洪绵卫. All rights reserved.
//

import UIKit
import CommonCrypto

class MFilePathTool: NSObject {

    /// 判断文件是否存在
    ///
    /// - Parameter filePath: 文件路径
    /// - Returns: BOOL 是否存在
    class func fileIsExist(_ filePath:String)->Bool{
        
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    /// 获取文件沙盒路径
    ///
    /// - Parameters:
    ///   - FolderName: 文件夹名字
    ///   - fileName: 文件名字
    /// - Returns: 文件沙盒路径
    class func getFilePath(folderName:String,fileName:String)->String {
        //Documents 路径
       let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString

        //保存文件的文件夹路径
        let folderPath:String = String(format: "%@/%@", docPath,folderName)
       
        //判断是否存在 不存在就创建一个保存文件的文件夹
        if !FileManager.default.fileExists(atPath: folderPath){
            try? FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        //文件路径
        let filePath:String =  String.init(format: "%@/%@", folderPath,fileName)
        
        return filePath
    }
    
    /// 获取文件夹路径
    ///
    /// - Parameter folderName: 文件夹名字 可以是:"name" 或者可以多级"Level1/Level2Name"
    /// - Parameter allowCreate: 文件夹不存在时候是否允许创建 默认true
    /// - Returns:  文件夹沙盒路径
    func getFolderPath(folderName:String,_ allowCreate:Bool = true)->String {
        //Documents 路径
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        
        //保存文件的文件夹路径
        let folderPath:String = String(format: "%@/%@", docPath,folderName)
        
        //判断是否存在 不存在就创建一个保存文件的文件夹
        if !FileManager.default.fileExists(atPath: folderPath) && allowCreate{
            try? FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        return folderPath
    }
    
    /// 获取Docmente下文件夹路径
    ///
    /// - Parameter folderName: 文件夹名称  可以是:"name" 或者可以多级"Level1/Level2Name"
    /// - Returns: 文件夹路径
    class func getFolderDirectory(_ folderName:String)->(Bool,String){
        //Documents 路径
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        
        //文件夹路径
        let folderPath:String = String.init(format: "%@/%@", docPath,folderName)

        return (self.fileIsExist(folderPath),folderPath)
    }

    /// 读取主资源束下的plist文件路径
    ///
    /// - Parameters:
    ///   - fileName: 文件名字
    ///   - suffix: 后缀
    /// - Returns: 文件路径
    class func mainBundleFile(fileName:String,suffix:String)->String?{
        let filePath:String? = Bundle.main.path(forResource: fileName, ofType: suffix)
        return filePath
    }
    
    /// 创建一个文件
    ///
    /// - Parameter filePath: 指定文件路径
    class func createFile(path filePath:String){
        let fm = FileManager.default
        fm.createFile(atPath: filePath, contents: nil, attributes: nil)
    }
    
    /// 获取文件大小
    ///
    /// - Parameter AtPath: 文件路径
    /// - Returns: Int64 字节 ,Bool 是否存在文件
    class func fileSize(atPath:String)->(isExist:Bool,size:UInt64){
        
        let fm = FileManager.default
        
        if self.fileIsExist(atPath) {
            
            let attr = try? fm.attributesOfItem(atPath: atPath)
            
            let size = attr![FileAttributeKey.size] as! UInt64
            
            return (true,size)
        }else{
            return (false,0)
        }
    }
    
    /// 获取文件夹大小size
    ///
    /// - Parameter atPath: 文件夹路径
    /// - Returns: UInt64 字节
    class func getFolderFileSize(atPath:String)->UInt64{
        
        let fm = FileManager.default
        
        var folderSize:UInt64 = 0
        
        //判断文件是否存在
        if self.fileIsExist(atPath) {
            
            let fileNames = fm.subpaths(atPath: atPath)
            
            for obj in fileNames! {
                
                let filePath = String.init(format: "%@/%@", atPath,obj)
                
                let tuples = self.fileSize(atPath: filePath)
                
                if tuples.isExist{
                    
                    folderSize += tuples.size
                }
            }
            
            return folderSize
        }else{
            return 0
        }
    }
    
    /// 移动文件
    ///
    /// - Parameters:
    ///   - fromURL: 来自哪里
    ///   - toURL: 移动至哪里
    class func moveFile(fromURL:URL,toURL:URL){
        // 获得文件管理对象，
        let fileManager = FileManager.default
       
        do{
            try fileManager.moveItem(at: fromURL, to: toURL)
            NSLog("移动文件成功Succsee to move file.")
        }catch{
            NSLog(" 移动文件失败Failed to move file.")
        }
    }
    
    /// 移除文件
    ///
    /// - Parameter fromURL: 文件的URL
    class func removeFile(fromURL:URL){
        do{
            try FileManager.default.removeItem(at: fromURL)
            NSLog("移除文件成功Succsee remove file.")
        }catch{
            NSLog("移除文件失败Failed remove file.")
        }
    }
    
    /// 获取文件的MD5值
    ///
    /// - Parameter url: 文件的URL
    /// - Returns: MD5值
    class func md5File(url: URL) -> String? {
        
        let bufferSize = 1024 * 1024
        
        do {
            //打开文件
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }
            
            //初始化内容
            var context = CC_MD5_CTX()
            CC_MD5_Init(&context)
            
            //读取文件信息
            while case let data = file.readData(ofLength: bufferSize), data.count > 0 {
                data.withUnsafeBytes {
                    _ = CC_MD5_Update(&context, $0, CC_LONG(data.count))
                }
            }
            
            //计算Md5摘要
            var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            digest.withUnsafeMutableBytes {
                _ = CC_MD5_Final($0, &context)
            }
            
            return digest.map { String(format: "%02hhx", $0) }.joined()
            
        } catch {
            NSLog("Cannot open file:\(error.localizedDescription)")
            return nil
        }
    }
}







