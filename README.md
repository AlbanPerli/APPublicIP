# APPublicIP

Get the device's current public IP Address.

# One shot
```swift
let ipChecker = APPublicIP();
        ipChecker.getCurrentIP { (ip) -> Void in
            println(ip)
        }
```

# Listen to any IP Address change.
```swift
 let ipChecker = APPublicIP();
        ipChecker.checkForCurrentIP({ (ip) -> Void in
            
            println(ip)
            
        }, interval: 0.5.second)
```


