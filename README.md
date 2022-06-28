# Patagonian Challenge

This is an application build for Patagonian. It shows an art gallery and a historical record of seen arts.


## Arquitecture
The code is structured used a variation of MVVM-C
- Coordinators: Takes care of navigation, decouples viewControllers
- ViewController: The main glue to connect views with their data source
- View: Contains all the subviews and handles user input
- ViewModelFactory: Each view has a viewModel, those viewModels are built by the ViewModelFactory. Takes as an input, a
  Director state.
- Director: A state machine, takes user input, process the data and then switches the state to a new one.
- Repository: A data source

## Requirements
* Swift 5
* iOS 13.0+
* Xcode 13.0+

## Author
Franco Risma (emilio.risma@gmail.com)
