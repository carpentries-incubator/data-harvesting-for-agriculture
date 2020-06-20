# Glossary

## R programming

Note that many of these are common computer science terms, but to avoid confusion
we are providing R-centric definitions.

* **argument**

    Also known as "parameter", this is input that you give to a
function to show it what data to process or to control its behavior.  We often
say that objects are "passed" to arguments.

    (Example:) Arguments are what you feed into a program in order for it to
make the thing you want the way you want it. Using the omelet-machine analogy for
programming, an omelet-making function could receive arguments like 2 eggs, 2 Tbsp chives, and so forth.

* **class**

    A type of object in R, defining both the structure of the data in the object and what kinds of computation can be done with the
object.

    (Example:) Classes group similar types of things together, and help distinguish what's appropriate
to do with them. "Ingredients" could be a class including "eggs," "cheese," etc. "Pets" could be a class
involving "dogs," "cats," etc. You would use things from an "ingredients" class with the omelet-making
function, but not things from a "pets" class.

* **comment**

    A line or section of code that will be ignored by the interpreter.
In R the `#` symbol is used to indicate a comment.  Comments are useful for
explaining in human terms what your code is doing.

* **data frame**

    Spreadsheet-like data in R.  Each column must be all one data
type, although different columns can be different data types from each other.
We will also encounter **tibbles**, which are essentially data frames that are
designed to be a little more user-friendly.

    (Example:) You could have a data frame for your omelet-making program which had columns like "Ingredient," "Number," and "Measurement,"  and the rows could include "Eggs, 2, whole" and "Cheese, 3, Tbsp". \

* **environment**

    Part of your computer's RAM (memory) that contains all the
objects that you are working with in R, and the names pointing to them. \

    (Example:) You might have installed different software on a work computer than on a home computer, with more professional software at work and more games at home. Each of those computers would give you a different environment to work in. \

* **function**

    A named command that performs some sort of computation.
Functions often (but not always) take arguments as input and return a value as
output.

    (Example:) Think of a function as a part of an assembly line system. Let's imagine an omelet-making function. The inputs (arguments) you give to your function might include eggs, cheese, chives, etc. The outputs could be eggshells to the trash can and an omelet to your plate.

* **interpreter**

    The program that takes the code that you write and converts
it to machine instructions, then performs the requested computation.  You can
think of the "Console" in the lower left of RStudio as your interpreter (or at
least the interface to it).

* **indexing**

    A means of retrieving a particular value or set of values from
an object by name or numerical position.  In R we perform indexing using
square brackets `[]`.

    (Example:) From the data frame description above, you could grab the second item from the ingredients list by asking for `[cheese`].

* **method**

    A version of a function that is specific to a particular class.

    (Example: If you have a give_medicine() function, the method recommended for objects of the "humans" class might involve drinking a glass of water, but the method recommended for the "dogs" class might involve sticking the pill in a piece of cheese.)

* **object**

    Sometimes used interchangeably with "variable".  A simple or
complex piece of data with a name pointing to it, so that it can be referred to
by that name in your code.

    (Example: Objects are digital representations of things. If your program deals with tracking prescriptions across species, you could have objects that correspond to people, to pets, or to livestock, with different interactions for each class of object.)

* **operator**

    A symbol, like `<-`, `+`, or `$` that performs some sort of
operation involving one or two objects.

* **script**

    A plain text file containing a series of R commands. Ideally you
can reproduce your analysis by simply rerunning the script.

* **vector**

    A one-dimensional collection of values, all of the same data type.
Every column of a data frame is a vector.

    (Example: In the imagined Ingredients data frame, "Ingredient," "Number," and "Measurement" are vectors. Your data won't make sense if you put "Cheese" in the "Measurement" field; that's the wrong type of data for that column / vector.) \

## Geospatial analysis

* **bounding box**
* **coordinate reference system (CRS)**
* **ellipsoid**
* **ESPG**
* **polygon**: An area of land with distinct boundaries represented by a series
of points.
* **projection**
* **UTM zone**

## Agriculture

* **seeding rate** is reported in seeds per acre (ballpark value of 33,000 spa)
* **nitrogen application rate** is reported in pounds per acre (ballpark value of 200 lbs nitrogen per acre, _not_ urea or ammonia per acre)
* **yield** is reported in bushels per acre
