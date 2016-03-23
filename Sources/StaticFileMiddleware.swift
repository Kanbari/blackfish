import Foundation

struct StaticFileMiddleware: Middleware {
    func handle(request: Request, response: Response, next: (() -> ())) {
        //check in file system
        let filePath = "Public" + request.path
        
        let fileManager = NSFileManager.defaultManager()
        var isDir: ObjCBool = false
        
        if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
            // File exists
            if let fileBody = NSData(contentsOfFile: filePath) {
                var array = [UInt8](repeating: 0, count: fileBody.length)
                fileBody.getBytes(&array, length: fileBody.length)
                
                response.status = .OK
                response.body = array
                response.contentType = .Text
                response.send()
            } else {
                next()
            }
        } else {
        
            next()
        }
    }
}
