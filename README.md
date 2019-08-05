#  MuLight test project, for test only. All rights reserved

## How to build

Just change the `Team` to yours under `Signing` section for target `MuLight`. No third-party framework required.

## The Problem

We would like you to build a simplified photo booth application which allows the user to take photos and see previously taken photos.

Provide 2 options in the main screen:

- Take a photo
- View Photos

When user selects “Take a photo”, allow the user to take a photo using the default mobile camera functionality, and then allow the user to give the photo a name. The photo, name and creation time should be stored on the device locally. When done, the app should return to the main screen.

When user selects “View Photos”, show a list view with the thumbnails, name and creation time of all photos in the database. When an item in the list is clicked, show the selected photo in full screen with an option to go back to the list view.

## The Analysis

Basically we can accomplish this with 3 separated components: 
1. Photo picker
2. A table (list) view and a detail view
3. Database, ~~since the code test should not take too much of time, hence we should use `Core Data` as our database instead of build our own.~~ actually `Core Data` is much more convenient than I thought, I used to use `FMDB` to build my own database, but after finish this code test, I will give `Core Data` a shot.

**Photo picker:**
Normally after we take a photo we save it to user's photo library, then we retrive it back. We often resize the original photo, compress it to jpeg then save it to somewhere else.
The reason of doing this is sometime the photo needs to be sent to server (e.g: avatar photo), and uploading a 3-4 mb photo file to server (or someone else) is expensive.
Another case is when user browse a gallery of photos, use oringial photo takes more memory.

*For time saving I don't save the photo to library, only save the photo as jpeg to local disk.*

**A table view and a detail view:**
This should be as simple as possible, but since we are using `Core Data` as our database, we should take advantage of it. Use `NSFetchedResultsController` as a datasource and combine some generic extension, will make it more `Swiftfy` and `Reactive`.
For detail view, I often use a custom transition animation combine with drag down gesture to give user a better *back to list* option. But for time saving I only provide a navigation back option.
*(You can check my app [Baby](https://apps.apple.com/us/app/glow-baby-baby-toddler-log/id1077177456) for custom transition animtion)*

**Database:**
An Image enity (or table) in our database should have:
1. caption (string), photo name
2. date (Date), photo creation date
3. id (string), UUID string. Because when we want to syncing local database with server, an unique identifier for photo is necessary.
4. thumbnail (Data), binary jpeg file. Since the thumbnail data is small, there's no need to put it somewhere else. So when loading a list of `Image` entity for tableView we can easily load thumbnails.

**Image Store:**
Though photos will be compressed to jpeg, it is still a good idea to maintain them in somewhere else (instead of database), and plus it can be easily extended to support third-party framework such as: `KingFisher` or `SDWebImage`.

## The Solution

Check mindmap diagram [here](MuLightDiagram.pdf)

## Possible Improvment

1. Unit Test, I've been using Kiwi (for Objective-C) and Quick (for Swift) for a while, I guided other developer to write unit test code. The reason I haven't written unit test for this project (yet) is because there's not mush cases needs to be covered. Maybe I could write a unit test for `UITextField` that checks name text length or something else.
2. Refactor PhotoDetailViewController to support gallery. So when user go to detail view, it allows user to browse all photos. `MWPhotoBrowser` does a great job, though it is old but a lot of famous gallery browse project are inspired by it.
3. Refactor database to support multi-threading. Currently our database runs on main queue, that is fine. But if the app grows bigger and it needs to access database more frequently, you might consider to move database task from main queue to your custom database queue.
4. Depends on business needs, always prepare for refactor 😂😂😂.
