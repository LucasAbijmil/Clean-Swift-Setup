# Clean Swift Setup

A shell script to setup a project with a container, pre-built files & pods.

## Details
This script automates the setup of a project that uses a container for dependency injection.
It creates the podfile and pre-built files : 
- **Podfile** : 
  - App target : [Swinject](https://github.com/Swinject/Swinject) & [SwinjectAutoregistration](https://github.com/Swinject/SwinjectAutoregistration).
  - Tests target : [InstantMock](https://github.com/pirishd/InstantMock) & [OHHTTPStubs/Swift](https://github.com/AliSoftware/OHHTTPStubs).
- **Clean Swift Setup**
  - **Commons** 
    - ApiRoute.swift : an enum that contains all API routes.
    - URLBuilder.swift : a struct that builds URL using a `ApiRoute`.
  - **Networks** 
    - NetworkClient.swift : a client that allows you to make API requests using a `ApiRoute`.
  - **Services** : 
    - DecoderService.swift : a generic and reusable `JSONDecoder` using `convertFromSnakeCase` as a `keyDecodingStrategy`.
  - Container.swift : an extension on `Container` to setup all the dependencies.

## Installation
1. Open Xcode and create a new project.
2. Run the following commands : 
``` sh
$ cd MyProject
$ git clone git@github.com:LucasAbijmil/Clean-Swift-Setup.git
$ cd Clean-Swift-Setup
$ ./clean_swift_setup.sh
```
3. Then follow the instructions of the script.

## Improvements
- Create async await functions for the `NetworkClient`.
- Find the file that contains the `@main` to add this line : `let container = Container().setup()`.
- Check the app cycle :
  - If UIKit > Add the possibiilty to remove the Storyboard.

## Author

Lucas Abijmil, lucas.abijmil@gmail.com. 

You can also reach me on [Twitter](https://twitter.com/lucas_abijmil).
