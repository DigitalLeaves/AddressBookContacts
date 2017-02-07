# AddressBookContacts

This is the sample project for the article on contacts management in swift found here: http://digitalleaves.com/blog/2016/04/managing-contacts-in-swift-addressbook-and-contacts-frameworks/

Accessing contacts in swift is not as hard as dealing with cryptography on iOS, but the AddressBook framework has never been specially developer-friendly, and the strongly typed nature of Swift and its deliberated distance to C makes it even tedious to use. Luckily for us, Apple introduced the Contacts framework with iOS 9, but there's still many chances that you will need to support iOS 8 and prior.

In this project, we are going to delve into both frameworks and compare them in terms of convenience and ease of use in swift. At the end of the day, both frameworks work in quite a similar way, and both will allow us to access and modify the same information, so it's a matter of whether you need to support iOS 8 devices or not.

## Our sample application

Our sample application it's a really simple app with three main screens. The first one will allow us to choose between using the AddressBook or Contacts frameworks. The second screen will retrieve our device's contacts and show them in a (more or less) fancy way, and the third one will allow us to create a new contact.

![](http://digitalleaves.com/wp-content/uploads/2016/04/contactsApp.jpg)

We will set our application for targeting iOS 8+ devices, and we will use the #available(...) directive to

```
if #available(iOS 9, *) {
   callContactFrameworkRelatedFunctions(parameters)
} else {
   self.showAlertMessage("Sorry, you can only use the Contacts framework from iOS 9.")
}
```

The first screen is just two buttons that will take us to either our AddressBookViewController (that will use the old, C-Style AddressBook framework) or the ContactsViewController (that will use the new Contacts framework). Both of them will have a "Create" button to create a new contact, that will take us to the CreateContactViewController. This contact will handle the creation in both frameworks.

![](http://digitalleaves.com/wp-content/uploads/2016/04/appStructure-1024x524.png)

# License
The MIT License (MIT)
Copyright (c) 2016 Ignacio Nieto Carvajal (https://digitalleaves.com).

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
