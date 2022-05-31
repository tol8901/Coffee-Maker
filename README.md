# Coffee-Maker
This project is a task for Sprint-2 at Zoola Academy (Ruby)

# Description
It is an application that provides a process for making coffee. This app is launched in console, where the user has to select menu items. Via entering a key by keyboard and confirming its selection ("Enter" key).
The main logical components are coffee machines of different vendors, and a control application (which is represented in the main menu).
In this application the user follows the next steps: choose a vendor of coffee machine -> choose the main menu item -> initial checks -> choose a drink -> the drink preparation -> go to the main menu.

# User interaction scenario
First of all, it is necessary to select a vendor of the coffee machine from the list, via printing a number. If an option was not selected, the app will use a default value (first from the list).

![1  Vendor-selection](https://user-images.githubusercontent.com/39213432/171286562-d64f7d60-9601-4437-bf76-ff9922406250.png)

Then, after the selection of the vendor, the user goes to the main menu.
First of all, it is necessary to turn on the machine.

![2  Main-menu](https://user-images.githubusercontent.com/39213432/171286565-7e035f8e-4b85-4f86-9ef3-44ccb8f935ed.png)

After system loading, it requires to prepare the coffee machine to work. The app executes consecutive checks: the state of coffee beans in the Beans Can, check of the state of the Trash Can (for already used grinded coffee beans), and the volume of water in the Water Tank. It is expected that the user enters required resources (coffee beans and water) or does required actions (to empty the Trash Can). It is recommended to enter values of resources to the correct limits, which are printed in the prompt.

![3  Initial-checks](https://user-images.githubusercontent.com/39213432/171286567-4b21a1cc-b51e-492b-b8d8-d7c06ac91d8f.png)

Then the user needs to select a drink from the available drinks list.

![4  Available-drinks](https://user-images.githubusercontent.com/39213432/171286571-e5dd04c9-5cab-4bba-9222-892a9d0b8b29.png)

Next, the user can see the stages of the drink preparation, and when the drink is ready. When the drink is ready, the main menu appears again. Where the user can make another drink, turn off the machine, and quit by shutting down the machine (and finish the application).

![5  Preparing-a-drink](https://user-images.githubusercontent.com/39213432/171286572-bc32d470-0957-4226-bb34-ccd6a14a941a.png)

When the user finished dealing with the coffee machine, it selects to shut down it. After some delay, the user will see that machine is turned off. After that user sees the main menu, where it is possible to turn on it again.

![6  Shutting down](https://user-images.githubusercontent.com/39213432/171286574-e6d33828-579c-42fe-aadf-ca1dc2f22b6d.png)

If the user wants not only to shut down the machine but to finish working with the application, it is necessary to select the last menu item to quit. Then the application will be closed.

![7  Quit](https://user-images.githubusercontent.com/39213432/171286575-e9bfa3d5-10a7-4cf6-a9eb-0615d44217f0.png)


# Additional details of application work:
1) According to the logic of the working process of the coffee machine, it consumes resources (water and coffee beans) and produces except for coffee - the trash. When a lack of resources appeared, which are needed for the drink preparation, the application will require to enter them or clean the trash cup accordingly.
2) The technical characteristics are different for all of the provided vendors of coffee machines. The parameters, that are different: max/min amount of water, max/min amount of coffee beans, the volume of the Trash Can, and time delays (loading and drink preparation).
3) If the user inputs more resources than required (maximum limits), the system will ask to remove some amount of them.
4) If the user inputs values that do not coincide with one of the menu items, the system will inform about incorrect input. And asks the user again the same question.
5) If the user tries to prepare a coffee before turning on the machine, the system will notify the user, that first of all it is needed to turn on the machine. And execute resource checks.
6) If the user tries to turn on the already working machine, or turn off an already shut down machine, the system will notify the user about its incorrect actions.

# Implementation details
1 - Basic behavior of the application is based on the class CoffeeMaker. Where described actions from the main menu and implemented all necessary checks.
2 - Class CoffeeMachine inherits the CoffeeMaker class and adds additional drinks to the "Available drinks" menu.
3 - Three classes Delonghi, Philips, and Redmond represent three different vendors, and inherit the CoffeeMachine class. Also, these coffee machines have vendor-determined technical characteristics (max/min amount of water, max/min amount of coffee beans, the volume of the Trash Can, and time delays (loading and drink preparation).
4 - The class Cup interacts with the appropriate running coffee-machine class, where it takes vendor-related cup volume, and switches to true when the drink is already prepared.



