# MTSlideToOpen
A simple SlideToUnlock iOS UI component

<a href="url"><img src="https://raw.githubusercontent.com/lemanhtien/MTSlideToOpen/master/Screenshot.png" align="center" height="500" ></a>


## Requirements
* Swift 4 
* iOS 9.0 or later

## Installation

#### Using CocoaPod
Just add to your Pod file
> Pod 'MTSlideToOpen'

#### Manual install

Drag and drop folder `Source` to your project. Drag and drop to folder.



## Usage
```
  let slide = MTSlideToOpenView(frame: CGRect(x: 26, y: 400, width: 317, height: 56))
  slide.sliderViewTopDistance = 6
  slide.sliderCornerRadious = 22
  slide.delegate = self
  slide.defaultLabelText = "Slide To Unlock"
  slide.thumnailImageView.image = ic_arrow
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
