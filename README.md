**Basic Features:**
a. On launch of the app load the date, title, image and the explanation for the current day's APOD (Astronomy Picture of the Day). On some days the image is replaced by an embedded video. The app handle this scenario as well. (Example 24th June 2020 APOD)
b. App enable the user to load the NASA APOD for any day that they want. 
c. Last service call including image should be cached and loaded if any subsequent service call fails.

**Universal app**
*App works on both iPhone and iPad and different orientations*


**Minimum iOS deployment target is 14.0**

**App shows use of:-**
a. Code structure and software architecture and design - using MVVM CLEAN architecture.
b. Combine used to bind VieModel to View
d. Unit test cases - With Mock APi call and with Test Core data stack using NSInMemoryStoreType
e. Coding best practice - Using of Protocol, extension, codable, Dependency injection for better Testability, modularity,readability and scalability.
f. YouTubeiOSPlayerHelper - Third party Swift package manager is used to support Youtube video within the App.
g. Support dark mode - as all the color are by default system color.

**Future enhancement**
 a. Dynamic Type Accessibility.
 b. On tap navigate to next screen and Play the video on full screen and view image on full screen.
 c. Implement search from and to date to see the lists of all the APOD between the seleted dates. 
 d. Enable the app for iPad to cover more screen for Video and Image.
 
