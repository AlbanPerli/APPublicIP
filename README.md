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

# Installation 
As for now please clone the repository and drag the source folder into your project to use APPublicIP

###### This project uses https://github.com/radex/SwiftyTimer from Radek Pietruszewski

