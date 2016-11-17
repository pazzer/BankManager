## Bank Manager

This is a small project written to enable me to experiment with some of the ideas discussed by Kugler and Eggert in their book *objc Core Data*. It's a simple database app that allows employees of NHS Lothian's Staff Bank to keep track of the work they've done, and the money they're owed. Shifts are added via a simple form (a cocoa *sheet*), and displayed in a spreadsheet-style interface. 

![Alt text](BankManagerUI?raw=true "Bank Manager User Interface")

In addition to being of use to developers looking for a Core Data playground, the project showcases a number of other cocoa technologies that will be of interest to anyone interested in developing for the cocoa/cocoa-touch platforms; here's a rundown:


- **Bindings**: The project uses array controllers to populate all available table-views and pop-up buttons. In addition, there are two master-detail set-ups - where the content of table-view/pop-up button is dependent on the selection from a second table-view or pop-up button.
- **Formatters**: The project uses a number of customised date and number formatters - some specified in Interface Builder, others created in code.
- **Key-Value Coding/Key Value Observing**: The project has a number of *dependent* properties whose values are recomputed following changes to other specified properties.
- **Core Data**: The project has an easy to follow data model, and a number of classes have manually-typed ``NSManagedObject`` subclasses.
- **Runtime Attributes**: The project uses Interface Builder's *Runtime Attributes* panel (available on the Identity inspector) to set property values on specific objects.
- **Value Transformers**
- **Sheets**
- **Storyboards**

The jumping-off point for exploration is the commit tagged ``1.0``. This is the app in its most basic functioning form. If you want to experiment with something simply branch off from this commit.

- - -

#### Next Steps

###### Code Improvements

1. ``NewShiftViewController`` has three computed properties whose value is dependent on ``startDate`` and ``stopDate``. As it stands three separate ``keyPathsForValuesAffecting...`` functions describe this relationship; does the KVO-KVC API provide a way to specify this relationship in a single class-level function?

2. Sites can have a mixture of numbered wards (e.g. 201, 106) and named wards (e.g. Day Surgery, AMU); because of this when wards are sorted by ``name`` the ordering can be unexpected. Set about remedying this so sorting is both intuitive and predictable.

3. When shifts are chunked into blocks according to the pay structure for a given date, no account is taken of unworked hours. Instead, this is deduced and deducted in the ``Shift`` class once it has received the shift components. It makes more sense for the ``PayStructure`` class to encode the breaks policy and make the necessary ammendments to the shift components during the chunking process. Refactor to reflect this.

###### New Features

1. The point of this project was to allow me to explore Core Data, and in particular experiment with complex predicates. Create a *Reports* option which runs a number of different predicates on the data and produces a PDF file with the results. (Hint: try using XSL-FO as part of the report generation toolchain.)