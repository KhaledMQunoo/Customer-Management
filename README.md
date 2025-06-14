# Customer Management App


<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1yuvrfFrt0TQPzoKQfN1aJQaC-DTRPP62" width="150" alt="Image 1" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://drive.google.com/uc?export=view&id=1p3pm0y6dPtuss_zhBQMxCzExzbpIpwAv" width="150" alt="Image 2" />
</p>

## About the App

This app allows users to view, add, edit, and delete customer records. 
It provides a smooth and responsive user experience with offline support and modern iOS features.

## Compatibility & Features

- 🛠️ Built using Swift and SwiftUI
- 🌗 Fully supports Dark Mode and Light Mode, each with distinct color themes
- ✅ Works on iOS 17.6 and above
- 📱 Supports iPhone and iPad devices
- 🔄 Supports landscape (left, right) and portrait (upside down) orientations
- 🔌 Includes full API integration (async/await)
- 💾 Caches customer data locally using Core Data for offline support
- 🧱 Built using MVVM architecture
- 🧪 Includes Unit Testing and UI Testing

## Api integration

- The app uses Swift's async/await for asynchronous WebService calls.
- Integration is done with the mock API endpoint: https://gorest.co.in
- this my access token generated after registration in https://gorest.co.in : 9126cf21be511d6e6a17c1598a5108357c622e16517e6aa074258ccee0ea7b72
- The user list in my app supports pagination, displaying 10 users per page


## App UI and Functionality 

## Splash Screen

<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1SO_YKoK8ljDfTtGRJB7fZtC9AUcPH3dc" width="100" alt="Image 1" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://drive.google.com/uc?export=view&id=1U5fa-XjtDSLHeGXn1TXqJTFsgwVvjQvs" width="100" alt="Image 2" />
</p>

 - When the app launches, the splash screen appears displaying the app name with a simple animation. This screen is shown for 2 seconds before transitioning to the main interface.

## Home

<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1yuvrfFrt0TQPzoKQfN1aJQaC-DTRPP62" width="100" alt="Image 1" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://drive.google.com/uc?export=view&id=1p3pm0y6dPtuss_zhBQMxCzExzbpIpwAv" width="100" alt="Image 2" />
    &nbsp;&nbsp;&nbsp;
  <img src="https://drive.google.com/uc?export=view&id=1D9wWO07SU5NfSQCUg7U9J_1azaDG12Cz" width="100" alt="Image 3" />

</p>

- This screen displays the list of the customer.
- If there is no internet connection or a server issue, the app loads cached customer data from Core Data.
- You can delete a customer by swiping left on the cell.
- Pull down to refresh the customer list.
- To add customer press the bottom button 
- To see the customer details press on the cell

## Customer Details + Edit the customer Details

<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1u4hKGIFm8Y-vcc7_sYhVCfhz-IGDhOyQ" width="100" alt="Image 1" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://drive.google.com/uc?export=view&id=11fszLmYRb2KKH7ufpAqFiN6g53iXZqSl" width="100" alt="Image 2" />
</p>

- This screen displays the customer Details.
- If there is no internet connection or a server issue, the app loads cached customer data from Core Data.
- You can delete a customer by pressing the Delete Button.
- To edit a customer's details, modify any field in the form. Once a change is detected, the Edit button becomes enabled, allowing you to save the updates.
- The form includes validation to ensure user input is correct and not left empty.

## Add Customer

<p align="center">
  <img src="https://drive.google.com/uc?export=view&id=1a-fPCU5EfF2ODRzfwB-kyXOAAfiP_IzW" width="100" alt="Image 1" />
  &nbsp;&nbsp;&nbsp;
  <img src="https://drive.google.com/uc?export=view&id=1RDxWXTzsUHpRAp1tuxITgbeWQatmyXMd" width="100" alt="Image 2" />
</p>

- You can add a new Customer by fill the Form and press Add.
- The form includes validation to ensure user input is correct and not left empty.


## Author

Khaled Qunoo
