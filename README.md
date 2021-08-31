## DWTagList support for iOS 14.5

DWTagList
=========

Create a list of tags from an NSArray to be show in a view with customisable fonts, colors etc.
Can show remove tag icon and add tag button

![preview](http://f.cl.ly/items/3N3g2f1g0n053i0A3g0K/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%2028%20%D1%84%D0%B5%D0%B2%D1%80.%202014%20%D0%B3.,%2022.31.59%20%D1%81%20%D0%A1%D0%B8%D0%BC%D1%83%D0%BB%D1%8F%D1%82%D0%BE%D1%80%D0%B0%20iOS.png "Preview")

## Installation

Simple copy over `DWTagList.h` and `DWTagList.m` into your project and make sure you have linked the framework `QuartzCore.framework`.

You may then add tags to your view by the following lines of code:

    // Initalise and set the frame of the tag list
    tagList = [[DWTagList alloc] initWithFrame:CGRectMake(20.0f, 70.0f, 280.0f, 300.0f)];

    // Add the items to the array
    NSArray *array = [[NSArray alloc] initWithObjects:@"Foo", @"Tag Label 1", @"Tag Label 2", @"Tag Label 3", @"Tag Label 4", @"Tag Label 5", nil];
    [tagList setTags:array];

    // Add the taglist to your UIView
    [self.view addSubview:tagList];

## Customisation

In `DWTagList.m` there are a number of customisable options to change the layout and the aesthetics of the tags. These can be done via @properties, not all of them are there yet.

NOTE: In the future, these will be added as methods that can be used to customise the tags after initialisation.

## License

I have included the license in the `LICENSE` file. I've got it as the MIT license, mainly because I want people to do what they want with this library.

If you do something cool, or find any problems, please create a pull request and I will look at including any of your changes into this project.
