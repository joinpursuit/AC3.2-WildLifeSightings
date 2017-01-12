# AC3.2-WildLifeSightings

**WildLifeSightings** is a subject-tracking app that utilizies Core Data to store meaningful, persistant mutable entries (including storing pointers to external images as binary data). 

This app mainly utilizes Core Location and Core Data to store client-side photos & information, which is fetched and displayed onto a mapView. 

API's used:
- [Dark Skys Weather](https://darksky.net/dev/) (No Auth): A no-nonsense forecast API to attach current weather conditions to our Sighting entity.
- [Fieldbook](https://fieldbook.com/) (Basic Auth): While an object is saved into Core Data, a portion of the information can be POST'ed for external review.
- ~~[Twitter API](https://dev.twitter.com/overview/api) (OAuth 1.1)~~: Requires HMAC-SHA1 client-side encoding, signature building, and very specific, ordered Header parameters. We will never speak of this again.
- ~~[Imgur API](https://api.imgur.com/) (No Auth OR OAuth 2.0)~~: Anon image uploading via Base64 encoding always ends up in a connection lost error. Attempts to convert Core Data binary data to JPG takes up way too much space.

CocoaPods used: 
- [SwiftSpinner](https://github.com/icanzilb/SwiftSpinner): During data-transfer sessions, a visually-appealing spinning icon appears to show the end-user that a process is underway.
- [ImagePicker](https://github.com/hyperoslo/ImagePicker): A UI pod that replaces the UIImagePickerController, it allows the user to take photos and/or choose gallery shots to append, simultaneously.


| The First Screen        | Add Sighting Screen in Action           | 
| ------------- |:-------------:| 
| ![](http://i.imgur.com/HHf8cPRl.jpg)      | ![](http://i.imgur.com/TxjG55Tl.jpg) | 

| The ImagePicker View        | SwiftSpinner while Transfering Data           | 
| ------------- |:-------------:| 
| ![](http://i.imgur.com/5kL7YKgl.jpg)      | ![](http://i.imgur.com/cPOzingl.jpg) | 
