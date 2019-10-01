
# SWAPI MVVM

Example of architecture MVVM-FC (flow controllers) in iOS project based on Star Wars API. Flow controllers are alternative for coordinators.

## Universal structure of folders

* [Library/](Library/) - custom libraries and local extensions which can be reused in whole app. This code cannot use sources from other folders in this project. So it must contain very generic functionality which can be reused in any other project.
    * [ApiSession/](Library/ApiSession/) - library which delivers easy in use interface to make network requests with custom retry count, timeouts and settings for thread and decoding of response.
    * [Extensions/](Library/Extensions/) - generic extensions.
    * [Tools/](Library/Tools/) - tools for localized strings and logs. Any other diagnostic code and debugging helpers.
    * [UIKit+Layout/](Library/UIKit+Layout/) - extensions for UIKit supporting easy creation of constraints for views in clean source code. It's used in almost every view and view controller.
* [SwapiMVVM/](SwapiMVVM/) - source code of our application with MVVM modules and business logic.
    * [Application/](SwapiMVVM/Application/) - folder with delegate of the application and configuration files.
    * [Common/](SwapiMVVM/Common/) - code which can be reused in MVVM modules but it's related strictly to this application.
    * [Modules/](SwapiMVVM/Modules/) - MVVM modules. Most of modules consist of view model, view controller, flow controller and factory. There can be located also custom views or data structures for specific modules.
    * [Resources/](SwapiMVVM/Resources/) - assets and localized strings.
    * [Services/](SwapiMVVM/Services/) - services which can be used in view models.
        * [SwapiService/](SwapiMVVM/Services/SwapiService/) - implemented specification of SWAPI using `ApiSession` class. It delivers request methods and decoded responses.

## Basic rules of MVVM-FC

Almost every module consists of view controller, view model, flow controller and factory. They can be optional in some specific cases like [Alert](SwapiMVVM/Modules/Alert/) module.

Example of simple module is [MainScreen](SwapiMVVM/Modules/MainScreen/) module.

### Factory

Factory is set of static methods which create whole module. Naming convention is following:

* `Factory.create` creates view controller.
* `Factory.pushIn` creates and pushes view controller into navigation controller.
* `Factory.showIn` creates and displays view controller as modal controller.
* `Factory.rootIn` creates and sets view controller as root view controller in navigation controller.

You may create more methods like these described here depending on needs. So usually one factory contains just two methods like `Factory.create` and `Factory.pushIn` for screen which will be used only as page in navigation controller.

Factories may be used there where you need to create MVVM modules. First screen is created in application delegate. Other factories should be used in flow controllers only.

All factories should take `DependencyManager` as input argument. It delivers dependencies to view models like `SwapiService`.

### View controller

* View controller owns view model.
* View controller implements view model's delegate or closures.
* View controller informs view model about user actions without making decisions.
* View controller listens to changes from view model.
* View controller reads view model's properties and displays content.
* View controller must implement closures from view model with `[weak self]` to not create memory leaks.

### View model

**View model prepares data for view controller and handles user actions.** However view model doesn't organize specific views. View model doesn't know view layer. So it knows nothing about views, text fields, labels, first responders, buttons, scroll areas, constraints, frames, table views, cells, etc. **So `import UIKit` is forbidden in view model.**

Dependencies for initializer:

* Flow controller
* Model's structures and classes
* Services like `SwapiService` to make network requests or interfaces for local databases like `CoreData` or `UserDefaults`
* Use cases - reusable code for view models with similar dependencies as view models
* Use cases and services are delivered by dependency manager in factories.

Notifications for view controller:

* View model exposes `weak` delegate to not create memory leaks.
* View model may expose closures as alternative for delegate.

Output (exposed properties for view controller):

* View model exposes readonly properties for view controller like `items`, `isLoading` or `searchText`. They are marked very often as `private(set)` properties.
* Wrong names for view model's properties are like `showSpinner`, `searchFieldText` or `footerLabelText`.
* Good names for view model's properties are like `isLoading`, `searchText` or `summaryText`.

Input (user actions):

* View model exposes functions to handle user actions.
* Wrong names for actions are like `searchButtonClicked(text:)` or `cellSelected(index:)`.
* Good names for actions are like `search(text:)` and `selectedItem(index:)`.

### Flow controller

Flow controller can be used only from view model. It handles navigation actions.

Dependencies:

* View controller from current module
* Navigation controller (optional)
* Parent controller (optional)
* Tab bar controller (optional)
* Other view controllers (optional)
* Dependency manager that it could be passed to the next modules

**All references to view controllers must be `weak` to not create memory leaks.**

Flow controller implements actions like:

* `show(apiError:)`
* `showAlert`
* `showAnotherModule`
* `goToNextController` (specific controller)
* `goBackToPreviousController`
* `showImagePicker`
* etc.

These methods are allowed to use factories and they can be called from view model because only view model owns flow controller.
