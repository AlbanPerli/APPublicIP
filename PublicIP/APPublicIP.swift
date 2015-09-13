//
//  APPublicIP
//
//  Copyright (c) 2015 Alban Perli.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//



import Foundation

class APPublicIP {

    private
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    private
    var previousIP : NSString!
    
    private
    var timer : NSTimer!
    
    
    init(){
        previousIP = nil
        timer = nil
    }
    
    
    func getCurrentIP(completion:((ip : NSString?) -> Void)){
        
        if let checkedUrl = NSURL(string: "https://api.ipify.org?format=json") {
            getDataFromUrl(checkedUrl, completion: { (data) -> Void in
               
                var parseError: NSError?
                
                let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.AllowFragments,
                    error:&parseError)
                
                if let jsonIP = parsedObject as? NSDictionary{
                
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        completion(ip: jsonIP["ip"] as? NSString)
                        
                    }
                }
                
            })
        }
        
    }
    
    func checkForCurrentIP(completion:((ip : NSString?) -> Void), interval: NSTimeInterval){
        
        if self.timer != nil { self.stopChecking() }
        
        self.timer = NSTimer.new(every: interval) { () -> Void in
         
            self.getCurrentIP({ (ip) -> Void in
                
                if (self.previousIP != nil){
                    
                    if self.previousIP != ip {
                        
                        self.previousIP = ip
                        completion(ip: ip)
                        
                    }
                    
                }else{
                    self.previousIP = ip
                    completion(ip: ip)
                }
                
                
            })
            
        }

        // Execute timer immediately (don't wait for first interval)
        self.timer.fire()
        
        // Start the timer
        self.timer.start()
    }
    
    
    func stopChecking(){
        
        self.timer.invalidate()
        self.timer = nil
        
    }
}


