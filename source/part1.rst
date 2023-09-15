.. _part1:

*****************************************************************
Part 1: From Python to Java
*****************************************************************

Your first Java program with IntelliJ
=====================================

Installing IntelliJ
-------------------

In the course LINFO1101, you used the Thonny Integrated Development Environment (IDE) to write your Python programs. In this course, we will do something similar to write Java programs: we will use the free "Community Edition" of Intellij IDEA (we will just call it "IntelliJ" in the following). You can download the installer from  `<https://www.jetbrains.com/idea/download/>`_ (scroll down to find the free Community Edition, you don't need the commercial Ultimate Edition). Start the installer and follow the instructions.

The second thing you will need is a *Java Development Kit* (JDK). A JDK is a software package that contains the tools and libraries that you need to build and run Java programs. Fortunately, IntelliJ can download it for you when you create a new project, so you don't have to take care of that. (We just mention it here, so you know what to do when you want to run your Java application without IntelliJ. The JDK can be downloaded from `<https://openjdk.org/>`_)

Creating a new project
----------------------

Start IntelliJ. A window will open where you can create a new project. Click on the corresponding button and you should see a window like this one:

.. image:: _static/images/part1/new_project_screenshot.png
  :width: 90%
  :alt: Starting a new project

To create a new project, you have to enter a project name (in the field "Name") and a location on your disk where you want to store the project (in the field "Location"). Keep the other fields "Language", "Build system", and "Add sample code" as shown in the above picture. But there is something to do in the field "JDK". As you can see in the picture, there was already JDK version 20 (and some other JDK versions) installed on my computer. If you have not already installed a JDK on your computer, open the dropdown list and choose "Download JDK..." as shown in the picture below:

.. image:: _static/images/part1/select_jdk_screenshot.png
  :width: 90%
  :alt: Selecting a JDK

A small window should appear where you can select which JDK version to download and install:

.. image:: _static/images/part1/download_jdk_screenshot.png
  :alt: Downloading a JDK

Select version 20 from the vendor "Oracle OpenJDK" (actually, any version newer than 12 is fine for this course). You can keep the location proposed by IntelliJ. Click the "Download" button and complete the JDK installation. Once everything is ready, you can finally create your first Java project. IntelliJ will normally automatically open the new project and show you the main window:

.. image:: _static/images/part1/first_project_screenshot.png
  :width: 90%
  :alt: The new project

In the left part of the window, you see the project structure. Since we have select "Add sample code" in the project creation window, IntelliJ has already created a "src" directory with one file in it: "Main.java" (the file ending ".java" is not shown). When you double-click the file, its content is shown in the editor in the right part of the window.

Click on the right triangle in the upper right corner to start the program. A new view should appear at the bottom of the window with the output of the program:

.. image:: _static/images/part1/program_output_screenshot.png
  :width: 90%
  :alt: Output of the program


How do Java programs look like?
===============================

Here is source code of the example program automatically created by IntelliJ in your project:

..  code-block:: java

    public class Main {
        public static void main(String[] args) {
            System.out.println("Hello world!");
        }
    }

And here is how an equivalent Python program would look like:

..  code-block:: python

    print('Hello world!')

Why does the Java code look more complicated than the Python code? First of all, unlike Python, Java doesn't allow to write a statement like :code:`print('Hello world!')` directly in a source code file. In Java, all statements MUST be inside a method and all methods MUST be inside a class. In our example, the statement :code:`System.out.println("Hello world!")` is in the method "main" and this method is in the class "Main". Of course, a class in Java can have more than one method, and a Java program can contain more than one class.

You have already learned about classes and methods in the course LINFO1101 and you might remember that classes are used to describe objects and methods are used to work with those objects. In our simple Java example, we don't need objects and all the complicated things that come with them (constructors, inheritance, etc.). The word :code:`static` in the line :code:`public static void main(String[] args)` indicates that the method "main" behaves more like a traditional function in Python and not like a method for objects. In fact, no object is needed to execute a static method like "main". We will learn more about this later.

The second thing you might have noticed is the word :code:`public` appearing twice in the first two lines of the code:

..  code-block:: java

    public class Main {
        public static void main(String[] args) {
        
The :code:`public` in the first line indicates that the class "Main" can be used by others. It is not strictly necessary for this simple program and, in fact, our program will still work if you remove it (try it!). However, there is something important you have to know about public classes: If a class is marked as public, the source file that contains the class must have the same name as the class. That's the reason why the file is called "Main.java" and the public class in the file is called "Main" (Try to change the name of the class and see what happens!). Apart from that, the name "Main" for a class doesn't have any special meaning in Java. Our program would still work if we renamed the class to "Catweazle" or "Cinderella", as long as we don't forget to rename the file as well.

The :code:`public` in the second line is much more important for our example. A Java program can only be executed if it contains a method "main" that is :code:`public` and :code:`static`. Remove the :code:`public` or :code:`static` from the second line and see what happens when you try to run the program.

In general, **a Java program always starts at the public static main method**. With this knowledge, can you guess what the following program prints?

..  code-block:: java

    public class Main {
        static void printHello() {
            System.out.print("How do ");
            System.out.println("you do, ");
        }
    
        public static void main(String[] args) {
            printHello();
            System.out.println("fellow kids?");
        }
    }
    
(By the way, have you noticed the difference between :code:`System.out.print` and :code:`System.out.println`?)

A .java file can contain more than class, however only one of them can be public. Here is the example from above with two classes:

..  code-block:: java

    class MyOtherClass {
        static void printHello() {
            System.out.print("How do ");
            System.out.println("you do, ");
        }
    }

    public class Main {
        public static void main(String[] args) {
            MyOtherClass.printHello();
            System.out.println("fellow kids?");
        }
    }

You can access the static content of a class from another class by using the name of the class, as demonstrated in the line :code:`MyOtherClass.printHello()` in the example.

Types
=====

You might already know that Python is a *strongly typed* language. That means that all "things" in Python have a specific type. You can see that by entering the following statements in the Python prompt:

..  code-block:: python

    >>> type("hello")
    <class 'str'>
    >>> type(1234)
    <class 'int'>
    >>> type(1234.5)
    <class 'float'>
    >>> type(True)
    <class 'bool'>

Java is a strongly typed language, too. However, there is a big difference to Python: Java is also a *statically typed* language. We will not discuss all the details here, but in Java that means that most of the time you (the programmer) must indicate for *every* variable in your program what type of "things" it can contain.

Here is a simple Python program to calculate and print the area of a square:

..  code-block:: python

    def calculateArea(side):
        return side * side
        
    def printArea(message, side):
        area = calculateArea(side)
        print(message)
        print(area)

    t = 3 + 4
    printArea("Area of square", t)

And here is the equivalent Java program:

..  code-block:: java

    public class Main {
        static int calculateArea(int side) {
            return side * side;
        }
    
        static void printArea(String message, int side) {
            int area = calculateArea(side);
            System.out.println(message);
            System.out.println(area);
        }
    
        public static void main(String[] args) {
            int t = 3 + 4;
            printArea("Area of square", t);
        }
    }

Let's see what's happening with the types in the Java code:

- The line :code:`int calculateArea(int side)` indicates that the method "calculateArea" has a parameter "side" of type :code:`int`. Furthermore, the :code:`int` at the beginning of :code:`int calculateArea(...` specifies that this method returns a value of type :code:`int`. This is called the *return type* of the method.
- The line :code:`void printArea(String message, int side)` defines that the method "printArea" has a parameter "message" of type :code:`String` and a parameter "side" of type :code:`int`. The method does not return anything, therefore it has the special return type :code:`void`.
- Inside the method "printArea", we can see in the line :code:`int area = calculateArea(side)` that the variable "area" has the type :code:`int`.
- (Exercise for you: look at the types that you can see in the "main" method. We will explain later why the "main" method always has a parameter named "args")

Whenever you want to execute a Java program, IntelliJ uses a special tool called the *Java compiler* that carefully verifies that there are no *type errors*  in your program, i.e., that you have not made any mistakes in the types of the variables, parameters, and methods in your program. Unlike Python, this *type checking* is done *before* your program is executed. You cannot even start a Java program that contains type errors!

Here are some examples that contain type errors. Can you find the mistakes?

- :code:`int t = "Hello";`
- :code:`boolean t = calculateArea(3);`
- :code:`printArea(5, "Size of square");` (This example shows why it is easier to find bugs in Java than in Python)


The Java compiler and class files
=================================

In the previous section, we mentioned that a special tool, the *Java compiler*, checks your program for type errors *before* it is executed. This check is part of another fundamental difference between Python and Java.

Python is an *interpreted language*. That means that when you start a program written in Python in an IDE like Thonny or on the command line with

..  code-block:: bash

    > python myprogram.py
    
the Python-Interpreter will do the following things:

1. Load the file "myprogram.py" (and the modules you have imported in your program with the :code:`import` statement),
2. Do some checks to verify that your program doesn't contain syntax errors such as :code:`print('Hello')))))`,
3. Execute your program.

Java, being a *compiled language*, works differently. To execute a Java program, there is another step done before your program can be executed:

1. First, the Java code has to be compiled. This is the job of the Java compiler, a tool that is part of the JDK. The compiler does two things:

   - It verifies that your source code is a well-formed Java program. This verification process includes the type checking described in the previous section.
   - It translates your Java source code into a more compact representation that is easier to process for your computer. This compact representation is called a *class file*. One such file will be created per class in your program. In IntelliJ, you can find the generated class files in the directory "out" in your project.
    
2. If the compilation of your code was successful, the *Java Virtual Machine* (JVM) is started. The JVM is a special program that can load and execute class files. The JVM doesn't need the source code (the .java files) of your program to execute it since the class files contain all the necessary information. When you are developing software for other people, it's usually the class files that you give to them, not the source code.

IntelliJ runs the Java compiler and starts the JVM for you when you press the green start button, but it's perfectly possible to do it by hand on the command line without an IDE:

..  code-block:: bash

    > javac Main.java   # javac is the compiler and part of the JDK. It will generate the file Main.class
    
    > java Main         # this command starts the JVM with your Main class


Primitive Types
===============

Many primitive types...
-----------------------

As explained, Java requires that you specify the type of all variables (including method parameters) and the return types of all methods.
Java differs between *primitive types* and complex types, such as arrays and objects. The primitive types are used for numbers (integers and real numbers), for boolean values (*true* and *false*) and for single characters ('a', 'b', etc.). However, there are several different number types. The below table shows all primitive types:

======== ========================================================= ========================
Type     Possible values                                           Example
======== ========================================================= ========================
int      :math:`-2^{31} .. 2^{31}-1`                               :code:`int a = 3;`
long     :math:`-2^{63} .. 2^{63}-1`                               :code:`long a = 3;`
short    :math:`-2^{15} .. 2^{15}-1`                               :code:`short a = 3;`
byte     :math:`-2^{7} .. 2^{7}-1`                                 :code:`byte a = 3;`
float    :math:`1.4*10^{-45}.. 3.4*10^{38}`                        :code:`float a = 3.45f;`
double   :math:`4.9*10^{-324}.. 1.7*10^{308}`                      :code:`double a = 3.45;`
char     :math:`0 .. 2^{16}-1`                                     :code:`char a = 'X';`
boolean  true, false                                               :code:`boolean a = true;`
======== ========================================================= ========================

As you can see, each primitive type has a limited range of values it can represent. For example, a variable of type :code:`int` can be only used for integer numbers between :math:`-2^{31}` and :math:`2^{31}-1`. If you don't respect the range of a type, very strange things will happen in your program! Try this code in IntelliJ (copy it into the "main" method of your program):

..  code-block:: java

    int a = 123456789;
    int b = a * 100000;     // This is too large for the int type!
    System.out.println(b);  // What will you get here?

For most calculations that we do in this book, it will be sufficient to use :code:`int` (for integer numbers) and :code:`float` (for real numbers). The types :code:`long` and :code:`double` provide a wider value range and more precision, but they are slower and your program will consume more memory when running.

You might wonder why the :code:`char` type is shown in the above table as a type with values between 0 and 65535, although it is used for variables containing single characters, like 'a' or 'X'. This is because Java represents characters by numbers following a standard called *Unicode*. You can find more information about Unicode on `<https://en.wikipedia.org/wiki/Unicode>`_.


Type casting
------------

Java performs automatic conversions between values of different types if the destination type is wide enough to hold the result. This is called a *type cast*. For example, this is allowed:

..  code-block:: java

    float a = 34;             // int 34 is automatically casted to float 34.0f
    float b = 6 * 4.5f;       // int multiplied by float gives float
    
But this is not allowed:

..  code-block:: java

    int a = 4.5f;             // Error! float is not automatically cased to int
    float b = 4.5f * 6.7;     // Error! float * double gives double

You can force the conversion by doing a *manual* type cast, but the result will be less precise or even wrong:

..  code-block:: java

    int a = (int)4.5f;             // this will give 4 
    float b = (float)(4.5f * 6.7); // the result is correct because the values are small

The Java class "Math" provides a large set of methods to work with numbers of different types. It also defines useful constants like :code:`Math.PI`. Here is an example:

..  code-block:: java

    double area = 123.4;
    double radius = Math.sqrt(area / Math.PI);

    System.out.println("Area of disk: " + area);
    System.out.println("Radius of disk: " + radius);

The complete documentation of the "Math" class can be found at `<https://docs.oracle.com/en/java/javase/20/docs/api/java.base/java/lang/Math.html>`_.
 
What is a variable? A mental model
----------------------------------
 
When working with variables of primitive types, you can imagine that every time your program reaches a line in your code where a variable is declared, the JVM will use a small part of the main memory (RAM) of your computer to store the value of the variable.

+-----------------------+-------------------------------------------------+
| Java code             | In memory during execution                      |
+=======================+=================================================+
| .. code::             | .. image:: _static/images/part1/assignment.svg  |
|                       |    :width: 10%                                  |
|    int a = 3;         |                                                 |
|    int b = 4;         |                                                 |
|                       |                                                 |
+-----------------------+-------------------------------------------------+

When you assign the content of a variable to another variable, the value is copied:

+-----------------------+-------------------------------------------------+
| Java code             | In memory during execution                      |
+=======================+=================================================+
| .. code::             | .. image:: _static/images/part1/assignment2.svg |
|                       |    :width: 10%                                  |
|    a = b;             |                                                 |
|                       |                                                 |
+-----------------------+-------------------------------------------------+

The same also happens with the parameters of methods; when you call a method with arguments, for example :code:`printArea("Area of square", t)`, the argument values are copied into the parameter variables of the called method.

Note that it is illegal to use a local variable that doesn't have a value:

..  code-block:: java

    public static void main(String[] args) {
        int a;
        int b;
        b = 3;
        int c = b * 3;    // This is okay. b has a value.
        int d = a * 3;    // Error! a has not been initialized.
    }

Class variables
----------------

In our examples so far, all variables were either parameter variables or local variables of a method. Such variables are only "alive" when the program is inside the method during execution. 
Similar to Python, you can have variables that "live" outside a method. These variables are called *class variables* because they "belong" to the class, not to a specific method. Similar to static methods, we mark them with the keyword :code:`static`:

..  code-block:: java

  public class Main {

    static int a = 3;   // this is a class variable

    static void increment() {
        a += 5;  // this is equivalent to  a = a + 5
    }

    public static void main(String[] args) {
        increment();
        System.out.println(a);
    }
  }
  
In contrast to local variables, class members do not need to be manually initialized. They are automatically initialized to 0 (for number types) or :code:`false` (for the boolean type). This code is accepted by the compiler:

..  code-block:: java

  public class Main {

    static int a;   //  is equivalent to  a = 0

    public static void main(String[] args) {
        System.out.println(a);
    }
  }

Arrays (*fr.* tableaux)
=======================

Working with arrays
-------------------

If you need a certain number of variables of the same primitive type, it can be useful to use an array type instead. Arrays are similar to lists in python. One big difference is that when you create a new array you have to specify its size, i.e., the number of elements in it:

..  code-block:: java

    int[] a = new int[4];  // an array of integers with 4 elements
    
Once the array has been created, you can access its elements :code:`a[0]`, :code:`a[1]`, :code:`a[2]`, :code:`a[3]`. The elements of an array of integers (type :code:`int[]`) are automatically initialized to 0 when the array is created:

..  code-block:: java

    a[2] = 5;
    int b = a[1] + a[2];   // gives 5 because a[1] is automatically initialized to 0

Note that the size of an array is fixed. Once you have created it, you cannot change the number of elements in it. Unlike Python lists , arrays in Java do not have slice() or append() methods to add or remove elements. However, we will see later the more flexible :code:`ArrayList` class.

Mental model for arrays
-----------------------

There is an important difference between array variables and primitive-type variables. An array variable does not directly represent a part of the RAM that contains the values of the array elements. Instead, an array variable represents a "reference" to the array. You can imagine it like this:

+-----------------------+------------------------------------------------------------+
| Java code             | In memory during execution                                 |
+=======================+============================================================+
| .. code::             |  .. image:: _static/images/part1/array.svg                 |
|                       |     :width: 40%                                            |
|  int[] a = new int[4];|                                                            |
+-----------------------+------------------------------------------------------------+

This difference becomes important when you assign an array variable to another array variable: 

+-----------------------+------------------------------------------------------------+
| Java code             | In memory during execution                                 |
+=======================+============================================================+
| .. code::             |  .. image:: _static/images/part1/array2.svg                |
|                       |     :width: 40%                                            |
|  int[] a = new int[4];|                                                            |
|  int[] b = a;         |                                                            |
+-----------------------+------------------------------------------------------------+

In that case, **only the reference to the array is copied, not the array itself**. This means that both variables "a" and "b" are now referencing the same array. This can be shown with the following example:

..  code-block:: java

    int[] a = new int[4];
    int[] b = a;
    b[2] = 5;
    System.out.println(a[2]);   // a[2] and b[2] are the same element


Initializing an array
---------------------

There is a convenient way to create and initialize an array in one step:

..  code-block:: java

    int[] a = new int[]{ 2, 5, 6, -3 };  // an array with four elements

Multi-dimensional arrays
------------------------

Arrays can have more than one dimension. For example two-dimensional arrays are often used to represent matrices:

..  code-block:: java

    int[][] a = new int[3][5];  // this array can be used to represent a 3x5 matrix
    a[2][4] = 5;

You can imagine a two-dimensional array as an array where each element is again a reference to an array:

.. image:: _static/images/part1/arrayarray.svg
   :width: 40%                            

An :code:`int[3][5]` is therefore an array of three arrays containing five elements each. The following code illustrates this:

..  code-block:: java

    int[][] a = new int[3][5];
    int b[] = a[0];  // b is now a reference to the first element of a. This is an int[5] array
    b[3] = 7;
    System.out.println(a[0][3]);  // b[3] and a[0][3] are the same element

Again, there is a convenient way to create and initialize multi-dimensional arrays in one step:

..  code-block:: java

    int[][] a = new int[][] {   // 3x3 unit matrix
        { 1, 0, 0 },
        { 0, 1, 0 },
        { 0, 0, 1 }
    };
    
Incompletely initialized arrays
-------------------------------

It is possible to create an "incompletely initialized" two-dimensional array in Java:
   
..  code-block:: java
   
    int[][] a = new int[3][];
    
Again, this is an array of arrays. However, because we have only specified the size of the first dimension, the elements of this array are initialized to :code:`null`. We can initialize them later:

..  code-block:: java
   
    int[][] a = new int[3][];
    a[0] = new int[5];
    a[1] = new int[5];
    a[2] = new int[2]; // this is allowed!
    System.out.println(a[0][3]);  // Okay. The element a[0][3] exists.
    System.out.println(a[2][3]);  // Error! The element a[2][3] does not exist
    
As shown in the above example, the elements of a multi-dimensional array are all arrays, but they do not need to have the same size.

Arrays and class variables
--------------------------

Array variables can be class variables (with the :code:`static` keyword), too. If you don't provide an initial value, the variable will be initialized with the value :code:`null`:

..  code-block:: java

  public class Main {

    static int[] a;   //  initialized to null

    public static void main(String[] args) {
        // this compiles, but it gives an error during execution,
        // because we have not initialized a
        System.out.println(a[2]);
    }
  }

Loops
=====

The two most common loop constructs in Java are the :code:`while` loop and the :code:`for` loop.

While loops
-----------

The while loop in Java is very similar to its namesake in Python. It repeats one or more statements (we call them the *body* of the loop) as long a condition is met. Here is an example calculating the sum of the numbers from 0 to 9 (again, the surrounding "main" method is not shown):

..  code-block:: java

    int sum = 0;
    int i = 0;
    while(i<10) {
        sum += i;    // this is equivalent to sum = sum + i
        i++;         // this is equivalent to i = i + 1
        System.out.println("Nearly there");
    }
    System.out.println("The sum is " + sum);

**Warning:** The two statements inside the while loop must be put in curly braces :code:`{...}`. If you forget the braces, only the *first* statement will be executed by the loop, independently of how the line is indented:

..  code-block:: java

    int sum = 0;
    int i = 0;
    while(i<10)                              // oops, we forgot to put a brace '{' here!
        sum += i;                            // this statement is INSIDE the loop
        i ++;                                // this statement is OUTSIDE the loop!!!
        System.out.println("Nearly there");  // this statement is OUTSIDE the loop!!!
    
    System.out.println("The sum is " + sum);

This is also true for other types of loops and for if/else statements.

**To avoid "accidents" like the one shown above, it is highly recommended to always use braces for the body of a loop or if/else statement, even if the body only contains one statement.**

Simple For loops
----------------

There are two different ways how for loops can be used. The simple for loop is often used to do something with each element of an array (or list. We will learn more about lists later):

..  code-block:: java

    int[] myArray = new int[]{ 2, 5, 6, -3 };
    int sum = 0;
    for(int elem : myArray) {
        sum += elem;
    }
    System.out.println("The sum is " + sum);

The for loop will do as many iterations as number of elements in the array, with the variable "elem" successively taking the values of the elements.

Complex For loops
-----------------

There is also a more complex version of the for loop. Here is again our example calculating the sum of the numbers from 0 to 9, this time with a for loop:

..  code-block:: java

    int sum = 0;
    for( int i = 0; i<10; i++ ) {
        sum += i;
        System.out.println("Nearly there");
    }
    System.out.println("The sum is " + sum);

The for loop consists of three components:

1. a statement that is executed when the loop starts. In our example: :code:`int i = 0`.
2. an expression evaluated *before* each iteration of the loop. If the expression is :code:`false`, the loop stops. Here: :code:`i<10`.
3. a statement that is executed *after* each iteration of the loop. Here: :code:`i++`.

This version of the for loop is very flexible because it gives you full control over what is happening in each iteration. Here is an example where we calculate the sum of every second element of an array:

..  code-block:: java

        int[] myArray = new int[]{ 2, 5, 6, -3, 4, 1 };
        int sum = 0;
        for( int i = 0; i<myArray.length; i += 2 ) {
            sum += myArray[i];
        }
        System.out.println("The sum is " + sum);

In this example, we have done two new things. We have written `myArray.length` to get the size of the array "myArray". And we have used the statement :code:`i+=2` in the loop to increase :code:`i` by 2 after each iteration.

Stopping a loop and skipping iterations
---------------------------------------

Like in Python, you can leave a loop with the :code:`break` statement:

..  code-block:: java

    int sum = 0;
    for( int i = 0; i<10; i++ ) {
        sum += i;
        if(sum>5) {
            break;
        }
    }

And we can immediately go to the next iteration with the :code:`continue` statement:

..  code-block:: java

    int sum = 0;
    for( int i = 0; i<10; i++ ) {
        if(i==5) {
            continue;
        }
        sum += i;
        
        // Note that you could just write:
        //    for( int i = 0; i<10; i++ ) {
        //       if(i!=5) {
        //          sum += i;
        //       }
        //    }
        // Only use break and continue if they make the code easier to read!
    }

Conditional Statements
======================

If/Else statements
------------------

As you have seen in the examples for :code:`break` and :code:`continue`, Java has an if statement that is very similar to the one in Python. Here is an example that counts the number of negative and positive values in an array:

..  code-block:: java

    int[] myArray = new int[]{ 2, -5, 6, 0, -4, 1 };
    int countNegative = 0;
    int countPositive = 0;
    for( int i = 0; i<myArray.length; i++ ) {
        if(myArray[i]<0) {
            countNegative++;
        }
        else if(myArray[i]>0) {
            countPositive++;
        }
        else {
            System.out.println("Value zero found");
            System.out.println("Let's stop");
            break;
        }
    }
    System.out.println("The number of negative values is " + countNegative);
    System.out.println("The number of positive values is " + countPositive);

Like loops, don't forget using curly braces :code:`{...}` if the body of the if/else statement contains more than one statement. **It is highly recommended to always use braces, even if the body contains only one statement.**

Comparison and logical operators
--------------------------------

Boolean expressions are expressions that are evaluated to :code:`true` or :code:`false`. They are quite similar to the ones you know from Python. 

.. code-block:: java

    boolean b1 = 3 < 4;     // Like <, >, <=, >=, ==, !=  in Python
    boolean b2 = !b1;       // "not" in Python
    boolean b3 = b1 && b2;  // "and" in Python
    boolean b4 = b1 || b2;  // "or" in Python
    
Strings
=======

Working with strings
--------------------

Variables holding string values have the type :code:`String`. Strings can be concatenated with the + operator:

.. code-block:: java

    String s1 = "This is a string";
    String s2 = "This is another string";
    String s3 = s1 + "---" + s2;
    System.out.println(s3);
    
The :code:`String` class defines many interesting methods that you can use to work with strings. If you check the documentation at  `<https://docs.oracle.com/en/java/javase/20/docs/api/java.base/java/lang/String.html>`_, you will notice that some methods of the :code:`String` class are static and some are not.
The static method :code:`valueOf` transforms a number value into a string:

.. code-block:: java

    double x = 1.234;
    String s = String.valueOf(x);
    System.out.println(s);

But most methods of the :code:`String` class are not static; you have to call them on a string. Here are some of them:

.. code-block:: java

    String s = "Hello world";
    int l = s.length();                 // the length of the string
    boolean b = s.isEmpty();            // true if the string has length 0
    char c = s.charAt(3);               // the character in the string at position 3
    boolean b2 = s.startsWith("Hello"); // true if the string starts with "Hello"
    int i = s.indexOf("o");             // gives the position of the character "o" in the string
    String t = s.substring(2);          // the string starting at position 2: "llo world"
    
There are also some methods for strings located in other classes. The most useful ones are the methods to convert strings to numbers. For :code:`int` values, there is for example the static method :code:`parseInt` in the :code:`Integer` class:

.. code-block:: java

    int i = Integer.parseInt("1234");
    
Similar methods exist in the classes :code:`Long`, :code:`Float`, :code:`Double`, etc. for the other primitive types. All these classes are defined in the package :code:`java.lang` for which you can find the documentation at `<https://docs.oracle.com/javase/8/docs/api/java/lang/package-summary.html>`_.


Mental model for strings
------------------------

Like array variables, string variables are references to the content of the string:

+-----------------------+-------------------------------------------------+
| Java code             | In memory during execution                      |
+=======================+=================================================+
| .. code::             | .. image:: _static/images/part1/string.svg      |
|                       |    :width: 60%                                  |
|    String a = "Hello";|                                                 |
|                       |                                                 |
+-----------------------+-------------------------------------------------+


Comparing things
================

Primitive-type values can be tested for equality with the :code:`==` operator:

.. code-block:: java

    int i = 3;
    if( i==3 ) {
        System.out.println("They are the same!");
    }

However, this will not work for array and strings. Since array and string variables only contain references, the :code:`==` operator will compare the *references*, not the *content* of the arrays or strings! The following example shows the difference:

.. code-block:: java
    
    int i = 3;
    System.out.println( i==3 );     // true. Primitive type.
    
    int[] a = {1,2,3};
    int[] b = {1,2,3};
    System.out.println( a==b );     // false. Different arrays.

    int[] c = a;
    System.out.println( a==c );     // true. Same reference.
    
    String s1 = "Hello" + String.valueOf(1234);
    String s2 = "Hello1234";
    System.out.println( s1==s2 );   // false. Different strings.

**Comparing arrays or strings with == is a very common mistake in Java. Be careful!**

To compare the *content* of two strings, you must use their :code:`equals` method:

.. code-block:: java

    String s1 = "Hello" + String.valueOf(1234);
    String s2 = "Hello1234";
    System.out.println( s1.equals(s2) );   // true

There is also an :code:`equals` method to compare the *content* of two arrays, but it is a static method of the class :code:`Arrays` in the package :code:`java.util`. To use this class, you have to import it into your program. Here is the complete code:

.. code-block:: java

    import java.util.Arrays;

    public class Main {
        public static void main(String[] args) {
            int[] a = {1,2,3};
            int[] b = {1,2,3};
            System.out.println( Arrays.equals(a,b) );  // true
        }
    }

You might wonder why we didn't need to write import statements for the classes :code:`Math`, :code:`Integer` or :code:`String` in the other examples. That's because those classes are in the package :code:`java.lang`, which is automatically imported by the Java compiler.


Classes and Objects
===================

Creating your own objects
-------------------------

Writing programs is about organizing and processing data. In some cases the primitive types, arrays and strings are enough, but often you have data that is more complex than that.

Imagine a program to manage employees in a company. We can describe be the fact that each employee has a name (which is a string) and a salary (which is an integer), in a new *class* in our Java program:

.. code-block:: java

    class Employee {
        String name;    // the name of the employee
        int salary;     // the salary of the employee     
    }
    
Classes allow us to create new *objects* from them. In our example, each object of the class "Employee" represents an employee. Here is a complete example with two employees:

.. code-block:: java

    class Employee {
        String name;
        int salary;    
    }

    public class Main {    
        public static void main(String[] args) {
            Employee person1 = new Employee();    // a new object!
            person1.name = "Peter";
            person1.salary = 42000;
            
            Employee person2 = new Employee();    // a new object!
            person2.name = "Anna";
            person2.salary = 45000;

            int salaryDifference = person1.salary - person2.salary;
            System.out.println("The salary difference is " + salaryDifference);
        }
    }

The two objects that we created and put into the local variables "person1" and "person2" are called *instances* of the class "Employee", and the two variables "name" and "age" are called *instance variables* of the class "Employee". Since they are not static, they belong to the instances. As you can see in the example above, each object has its own "name" and "age".

Initializing objects
--------------------

In the above example, we first created the object, and then initialized its instance variables:

.. code-block:: java

    Employee person1 = new Employee();
    person1.name = "Peter";
    person1.salary = 42000;

Like static variables, instance variables are automatically initialized with the value 0 (for number variables), with :code:`false` (for boolean variables), or with :code:`null` (for all other variables). In our example, this is dangerous because we could forget to specify the salary of the employee:

.. code-block:: java

    Employee person1 = new Employee();
    person1.name = "Peter";
    // oops, the salary is 0

To avoid this, you can define a *constructor method* for your class. The constructor method has the same name as the class:

.. code-block:: java

    class Employee {
        String name;
        int salary;
        
        Employee(String n, int s) {   // this is the constructor
            this.name = n;
            this.salary = s;
        }
    }

If you provide such a constructor for your class, you are not allowed anymore to simply create a new Employee instance with :code:`new Employee()`. The Java compiler will verify that you use the constructor to create new objects:

.. code-block:: java

    Employee person1 = new Employee("Peter", 42000);
    // person1.name is now "Peter"
    // person1.salary is 42000

In this example, the constructor takes two parameters "n" and "s" and uses them to initialize the instance variables "name" and "salary" of a new "Employee" object. But how does the constructor know which object to initialize? Do we have to tell the constructor that the new object is in the variable "person1"? Fortunately, it's easier than that. the constructor can always access the object by using the keyword :code:`this`. The line

.. code-block:: java

    this.name = n;

means that the value of the parameter "n" will be used to initialize the instance variable "name" of the new object. We could even use the same names for the parameter variables and for the instance variables:

.. code-block:: java

    class Employee {
        String name;
        int salary;
        
        Employee(String name, int salary) {
            this.name = name;
            this.salary = salary;
        }
    }

When the Java compiler sees a parameter and an instance variable with the same name, it will always assume that you mean the parameter when you just write the variable, like on the right hand side of this assignment:

.. code-block:: java

   // "name" is the parameter
   // "this.name" is the instance variable
   this.name = name;  

Mental model
============

Like array variables and String variables, object variables contain a reference to the object in your computer's main memory:






ArrayLists
==========

Overloading
===========


Organizing Code: Packages
==========================

Visibility Modifiers
====================

Passing Arguments
=================

Exceptions
==========

IO
===

