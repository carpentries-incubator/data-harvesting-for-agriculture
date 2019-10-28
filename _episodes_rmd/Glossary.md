# Glossary

## R programming

Note that many of these are common computer science terms, but to avoid confusion
we are providing R-centric definitions.

* **argument**: Also known as "parameter", this is input that you give to a
function to show it what data to process or to control its behavior.  We often
say that objects are "passed" to arguments.
* **class**: A type of object in R, defining both the structure of the data in
the object and what kinds of computation can be done with the object.
* **comment**: A line or section of code that will be ignored by the interpreter.
In R the `#` symbol is used to indicate a comment.  Comments are useful for
explaining in human terms what your code is doing.
* **data frame**: Spreadsheet-like data in R.  Each column must be all one data
type, although different columns can be different data types from each other.
We will also encounter **tibbles**, which are essentially data frames that are
designed to be a little more user-friendly.
* **environment**: Part of your computer's RAM (memory) that contains all the
objects that you are working with in R, and the names pointing to them.
* **function**: A named command that performs some sort of computation.
Functions often (but not always) take arguments as input and return a value as
output.
* **interpreter**: The program that takes the code that you write and converts
it to machine instructions, then performs the requested computation.  You can
think of the "Console" in the lower left of RStudio as your interpreter (or at
least the interface to it).
* **indexing**: A means of retrieving a particular value or set of values from
an object by name or numerical position.  In R we perform indexing using
square brackets `[]`.
* **method**: A version of a function that is specific to a particular class.
* **object**: Sometimes used interchangeably with "variable".  A simple or
complex piece of data with a name pointing to it, so that it can be referred to
by that name in your code.
* **operator**: A symbol, like `<-`, `+`, or `$` that performs some sort of
operation involving one or two objects.
* **script**: A plain text file containing a series of R commands. Ideally you
can reproduce your analysis by simply rerunning the script.
* **vector**: A one-dimensional collection of values, all of the same data type.
Every column of a data frame is a vector.

## Geospatial analysis

* **bounding box**
* **coordinate reference system (CRS)**
* **ellipsoid**
* **ESPG**
* **polygon**: An area of land with distinct boundaries represented by a series
of points.
* **projection**
* **UTM zone**
