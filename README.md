# MTSlideToOpen
A simple SlideToUnlock iOS UI component

A simple SlideToUnlock iOS UI component. Support both **Left-To-Right** and **Right-To-Left** languages.

<p float="left">
  <a href="url"><img src="https://raw.githubusercontent.com/lemanhtien/MTSlideToOpen/master/Screenshot.png" align="center" height="500" ></a>
  <a href="url"><img src="https://raw.githubusercontent.com/lemanhtien/MTSlideToOpen/master/Right-To-Left.png" align="center" height="500" ></a>
</p>

## Requirements
* Swift 5.0
* iOS 9.0 or later

## Installation

#### Using CocoaPod
Just add to your Pod file
> pod 'MTSlideToOpen'

#### Manual install

Drag and drop folder `Source` to your project. Drag and drop to folder.



## Usage
```
  let slide = MTSlideToOpenView(frame: CGRect(x: 26, y: 400, width: 317, height: 56))
  slide.sliderViewTopDistance = 6
  slide.sliderCornerRadius = 22
  slide.delegate = self
  slide.labelText = "Slide To Unlock"
  slide.thumnailImageView.image = ic_arrow
```

## SwiftUI version

I built another version using SwiftUI. You can check it here [MTSlideToOpen-SwiftUI](https://github.com/lemanhtien/MTSlideToOpen-SwiftUI).

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
