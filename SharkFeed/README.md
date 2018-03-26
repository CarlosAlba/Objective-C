#  Yahoo CodeChallenge - Shark Feed

## Instructions

Using the Flickr search API create an infinite scrolling list of shark photos. Tapping on any of the photos in the shark feed should open a full screen photo lightbox with a button to download the original photo and to open the photo on Flickr.

* Use Objective-C.
* Use a UICollectionView for the infinite scrolling feed.
* Use NSURLSession to fetch responses from the Flickr search API.
* Use Auto Layout (OK to use third-party wrappers)
* Support iOS 9.

## API

Full Flickr public API documentation: h ttps://www.flickr.com/services/api/
* Flickr Search API documentation: https://www.flickr.com/services/api/flickr.photos.search.html
Use the following to get a JSON response of the first page of shark search results and URLs to thumbnail, medium, large and original (if available) images. https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=949e987787 55d1982f537d56236bbb42&text=shark&format=json&nojsoncallback=1&page=1&extras =url_t,url_c,url_l,url_o

* Flickr Photo Info documentation: https://www.flickr.com/services/api/flickr.photos.getInfo.html
Use the following to get a JSON response of information about a photo with a photo id. https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=949e987787 55d1982f537d56236bbb42&photo_id=22337474460&format=json&nojsoncallback=1

## Addendums

### Instructions.
* Open xcworkspace and compile.

### Dependency manager
* Cocoapods

```source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'SharkFeed' do
pod 'AFNetworking', '~> 2.0'
end
```

### Dependencies
* AFNetworking 2.0
UIImageView+AFNetworking.h
Asynchronously downloads an image from the specified URL, and sets it once the request is finished.


### Xcode
* 9.2


### Carlos Alfredo Alba
