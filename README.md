# MFMediaView

[![CI Status](https://img.shields.io/travis/NealWills/MFMediaView.svg?style=flat)](https://travis-ci.org/NealWills/MFMediaView)
[![Version](https://img.shields.io/cocoapods/v/MFMediaView.svg?style=flat)](https://cocoapods.org/pods/MFMediaView)
[![License](https://img.shields.io/cocoapods/l/MFMediaView.svg?style=flat)](https://cocoapods.org/pods/MFMediaView)
[![Platform](https://img.shields.io/cocoapods/p/MFMediaView.svg?style=flat)](https://cocoapods.org/pods/MFMediaView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MFMediaView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MFMediaView'
```

For pag player 

```objectivec
NSString *localPath =[NSBundle.mainBundle pathForResource:@"2_0080" ofType:@"pag"];
MFMediaViewModel *mediaViewModel =[MFMediaViewModel modelWithStyle:MFMediaViewModelStylePag localPath:localPath];
mediaViewModel.pagConfig.repeatCount = 0;
mediaViewModel.pagConfig.scaleMode = MFMediaViewModelPAGConfigStyleScaleModeAspectToFit;
mediaViewModel.pagConfig.maxFrameRate = 60;

self.mediaView =[[MFMediaView alloc] initWithFrame:CGRectMake(60, 100, 250, 250)];
[self.view addSubview:self.mediaView];


dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.mediaView.model = mediaViewModel;
});
```
<img src = @"https://github.com/NealWills/MFMediaView/blob/main/ReadMeAssets/ezgif.com-gif-maker.gif?raw=true" width = 30% height = 30%/>
![image](https://github.com/NealWills/MFMediaView/blob/main/ReadMeAssets/ezgif.com-gif-maker.gif?raw=true)

## Author

NealWills, NealWills93@gmail.com

## License

MFMediaView is available under the MIT license. See the LICENSE file for more info.
