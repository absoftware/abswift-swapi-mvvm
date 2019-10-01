
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

### Factory

Factory is set of static methods which create whole module. Naming convention is following:

* `Factory.create` creates view controller.
* `Factory.pushIn` creates and pushes view controller into navigation controller.
* `Factory.showIn` creates and displays view controller as modal controller.
* `Factory.rootIn` creates and sets view controller as root view controller in navigation controller.

You may create more methods like these described here depending on needs. So usually one factory contains just two methods like `Factory.create` and `Factory.pushIn` for screen which will be used only as page in navigation controller.

Example of simple factory is file [MainScreenFactory.swift](SwapiMVVM/Modules/MainScreen/MainScreenFactory.swift):
```
import UIKit

class MainScreenFactory {

    static func rootIn(navigationController: UINavigationController, dependencyManager: DependencyManager) {

        // View controller
        let viewController = MainScreenFactory.create(
            navigationController: navigationController,
            dependencyManager: dependencyManager)

        // Root controller
        navigationController.viewControllers = [viewController]
    }

    static func create(navigationController: UINavigationController, dependencyManager: DependencyManager) -> MainScreenViewController {

        // View controller
        let viewController = MainScreenViewController()
        viewController.title = localizedString("Star Wars API")

        // Flow controller
        let flowController = MainScreenFlowController(
            navigationController: navigationController,
            viewController: viewController,
            dependencyManager: dependencyManager)

        // View model
        let viewModel = MainScreenViewModel(
            flowController: flowController,
            swapi: dependencyManager.swapi)
        viewModel.delegate = viewController
        viewController.viewModel = viewModel

        // Return controller
        return viewController
    }
}
```

Factories may be used there where you need to create MVVM modules. First screen is created in application delegate. Other factories should be used in flow controllers only.
