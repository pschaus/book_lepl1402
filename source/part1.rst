.. _part1:

*****************************************************************
Part 1: From Python to Java
*****************************************************************

Part 1 of this book is intended for students and hobbyists who are already familiar with the basics of Python programming, i.e., they know how to use variables, lists, functions, and plain data objects.
A deeper knowledge of object-oriented programming is not required.

The goal of the following sections is to make you quickly familiar with the important differences between Python and Java and with the basic object oriented mechanisms of Java. More advanced topics, such as interfaces, abstract classes, or lambda functions, will be seen in the other parts of the book.


Your first Java program with IntelliJ
=====================================

.. _jdk:

Installing IntelliJ
-------------------

You might have already used an Integrated Development Environment (IDE) to write Python programs. In this course, we will do the same for programming in Java: We will use the free "Community Edition" of IntelliJ IDEA (we will just call it "IntelliJ" in the following). You can download the installer from  `<https://www.jetbrains.com/idea/download/>`_ (scroll down to find the free Community Edition, you don't need the commercial Ultimate Edition). Start the installer and follow the instructions.

The second thing you will need for Java programming is a *Java Development Kit* (JDK). A JDK is a software package that contains the tools that you need to build and run Java programs. The JDK also includes a *very, very  large* library of useful classes for all kinds of programming tasks. You can see the content of the library here: `<https://docs.oracle.com/javase/8/docs/api/index.html>`_.

Fortunately, IntelliJ can automatically download the JDK for you when you create a new project, so you don't have to worry about the JDK now. But if one day you want to write a Java application on a computer without IntelliJ, you have to manually download the JDK from `<https://openjdk.org/>`_ and install it.

Creating a new project
-----------------------

Start IntelliJ. A window will open where you can create a new project. Click on the corresponding button and you should see a window like this one:

.. image:: _static/images/part1/new_project_screenshot.png
  :width: 90%
  :alt: Starting a new project

To create a new project, you have to enter a project name (in the field ``Name``) and a location on your disk where you want to store the project (in the field ``Location``). Keep the other fields ``Language``, ``Build system``, and ``Add sample code`` as shown in the above picture. But there is something to do for the field ``JDK``: As you can see in the picture, there was already JDK version 20 (and some other JDK versions) installed on my computer. If you have not already installed a JDK on your computer, open the dropdown list and choose ``Download JDK...`` as shown in the picture below:

.. image:: _static/images/part1/select_jdk_screenshot.png
  :width: 90%
  :alt: Selecting a JDK

A small window should appear where you can select which JDK version to download and install:

.. image:: _static/images/part1/download_jdk_screenshot.png
  :alt: Downloading a JDK

Select version 20 from the vendor ``Oracle OpenJDK`` (actually, any version newer than 17 is fine for this book). You can keep the location proposed by IntelliJ. Click the ``Download`` button and complete the JDK installation. Once everything is ready, you can finally create your first Java project. IntelliJ will normally automatically open the new project and show you the main window:

.. image:: _static/images/part1/first_project_screenshot.png
  :width: 90%
  :alt: The new project

In the left part of the window, you see the project structure. Since we have selected ``Add sample code`` in the project creation window, IntelliJ has already created a ``src`` directory with one file in it: ``Main.java`` (the file ending ``.java`` is not shown). When you double-click the file, its content is shown in the editor in the right part of the window.

Click on the right triangle in the upper right corner to start the program. A new view should appear at the bottom of the window with the output of the program:

.. image:: _static/images/part1/program_output_screenshot.png
  :width: 90%
  :alt: Output of the program


.. _java_main:

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

Why does the Java code look more complicated than the Python code? First of all, unlike Python, Java doesn't allow to write a statement like :code:`print('Hello world!')` directly in a source code file. In Java, all statements MUST be inside a method and all methods MUST be inside a class. In our example, the statement :code:`System.out.println("Hello world!")` is in the method ``main()`` and this method is in the class ``Main``. Of course, a class in Java can have more than one method, and a Java program can contain more than one class.

You probably have already learned about classes and methods in Python and you might remember that classes are used to describe objects and methods are used to work with those objects. In our simple Java example, we don't need objects and all the complicated things that come with them (constructors, inheritance, etc.). The word :code:`static` in the line :code:`public static void main(String[] args)` indicates that the method :code:`main()` behaves more like a traditional function in Python and not like a method for objects. In fact, no object is needed to execute a static method like :code:`main()`. We will learn more about this later.

The second thing you might have noticed is the word :code:`public` appearing twice in the first two lines of the code:

..  code-block:: java

    public class Main {
        public static void main(String[] args) {
        
The word :code:`public` in the first line indicates that the class :code:`Main` can be used by others. It is not strictly necessary for this simple program and, in fact, our program will still work if you remove it (try it!). However, there is something important you have to know about public classes: If a class is marked as public, the source file that contains the class must have the same name as the class. That's the reason why the file is called ``Main.java`` and the public class in the file is called ``Main`` (Try to change the name of the class and see what happens!). Apart from that, the name ``Main`` for a class doesn't have any special meaning in Java. Our program would still work if we renamed the class to ``Catweazle`` or ``Cinderella``, as long as we don't forget to rename the file as well. But note that **all class names in Java (public or not) start with an uppercase letter**.

The :code:`public` in the second line is much more important for our example. A Java program can only be executed if it contains a method :code:`main()` that is :code:`public` *and* :code:`static`. Remove the :code:`public` or :code:`static` from the second line and see what happens when you try to run the program.
In general, **a Java program always starts at the public static main method**. If your program contains multiple classes with a main method, you have tell IntelliJ which one you want to start.

With this knowledge, can you guess what the following program prints?

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

A ``.java`` file can contain more than one class, however only one of these classes can be public. Here is the example from above with two classes:

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

Java is a strongly typed language, too. However, there is a big difference to Python: Java is also a *statically typed* language. We will not discuss all the details here, but in Java that means that most of the time you must indicate for *every* variable in your program what type of "things" it can contain.

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

Let's see what's going on with the types in the Java code:

- The line :code:`int calculateArea(int side)` indicates that the method :code:`calculateArea()` has a parameter :code:`side` of type :code:`int`. Furthermore, the :code:`int` at the beginning of :code:`int calculateArea(...` specifies that this method can only return a value of type :code:`int`. This is called the *return type* of the method.
- The line :code:`void printArea(String message, int side)` defines that the method :code:`printArea()` has a parameter :code:`message` of type :code:`String` and a parameter :code:`side` of type :code:`int`. The method does not return anything, therefore it has the special return type :code:`void`.
- Inside the method :code:`printArea()`, we can see in the line :code:`int area = calculateArea(side)` that the variable :code:`area` has the type :code:`int`.
- (Exercise for you: Look at the types that you can see in the :code:`main()` method. We will explain later why that method always has a parameter :code:`args`)

IntelliJ uses a special tool called the *Java compiler* that carefully verifies that there are no *type errors*  in your program, i.e., that you have not made any mistakes in the types of the variables, method parameters, and return types in your program. Unlike Python, this *type checking* is done *before* your program is executed. You cannot even start a Java program that contains type errors!

Here are some examples that contain type errors. Can you find the mistakes?

- :code:`int t = "Hello";`
- :code:`boolean t = calculateArea(3);`
- :code:`printArea(5, "Size of square");` (This example shows why it is easier to find bugs in Java than in Python)


The Java compiler and class files
=================================

In the previous section, we mentioned that a special tool, the *Java compiler*, checks your program for type errors. This check is part of another fundamental difference between Python and Java.
Python is an *interpreted language*. That means that when you start a program written in Python in an IDE or on the command line with

..  code-block:: bash

    > python myprogram.py
    
the Python-Interpreter will do the following things:

1. Load the file ``myprogram.py``,
2. Do some checks to verify that your program doesn't contain syntax errors such as :code:`print('Hello')))))`,
3. Execute your program.

Java, being a *compiled language*, works differently. To execute a Java program, there is another step done before your program can be executed:

1. First, the Java code has to be compiled. This is the job of the Java compiler, a tool that is part of the JDK. The compiler does two things:

   - It verifies that your source code is a well-formed Java program. This verification process includes the type checking described in the previous section.
   - It translates your Java source code into a more compact representation that is easier to process for your computer. This compact representation is called a *class file*. One such file will be created per class in your program. In IntelliJ, you can find the generated class files in the directory ``out`` in your project.
    
2. If the compilation of your code was successful, the *Java Virtual Machine* (JVM) is started. The JVM is a special program that can load and execute class files. The JVM doesn't need the source code (the ``.java`` files) of your program to execute it since the class files contain all the necessary information. When you are developing software for other people, it's usually the class files that you give to them, not the source code.

IntelliJ runs the Java compiler and starts the JVM for you when you press the green start button, but it's perfectly possible to do it by hand on the command line without an IDE:

..  code-block:: bash

    > javac Main.java   # javac is the compiler and part of the JDK.
                        # It will generate the file Main.class
    
    > java Main         # this command starts the JVM with your Main class


Primitive Types
===============

Many primitive types...
-----------------------

As explained, Java requires that you specify the type of all variables (including method parameters) and the return types of all methods.
Java differs between *primitive types* and complex types, such as arrays and objects. The primitive types are used for numbers (integers and real numbers), for Boolean values (``true`` and ``false``) and for single characters (``a``, ``b``, etc.). However, there are several different number types. The below table shows all primitive types:

============ ========================================================= ========================
Type         Possible values                                           Example
============ ========================================================= ========================
``int``      :math:`-2^{31} .. 2^{31}-1`                               :code:`int a = 3;`
``long``     :math:`-2^{63} .. 2^{63}-1`                               :code:`long a = 3;`
``short``    :math:`-2^{15} .. 2^{15}-1`                               :code:`short a = 3;`
``byte``     :math:`-2^{7} .. 2^{7}-1`                                 :code:`byte a = 3;`
``float``    :math:`1.4*10^{-45}.. 3.4*10^{38}`                        :code:`float a = 3.45f;`
``double``   :math:`4.9*10^{-324}.. 1.7*10^{308}`                      :code:`double a = 3.45;`
``char``     :math:`0 .. 2^{16}-1`                                     :code:`char a = 'X';`
``boolean``  ``true``, ``false``                                       :code:`boolean a = true;`
============ ========================================================= ========================

As you can see, each primitive type has a limited range of values it can represent. For example, a variable of type :code:`int` can be only used for integer numbers between :math:`-2^{31}` and :math:`2^{31}-1`. If you don't respect the range of a type, very strange things will happen in your program! Try this code in IntelliJ (copy it into the :code:`main()` method of your program):

..  code-block:: java

    int a = 123456789;
    int b = a * 100000;     // This is too large for the int type!
    System.out.println(b);  // What will you get here?

For most examples in this book, it will be sufficient to use :code:`int` (for integer numbers) and :code:`float` (for real numbers). The types :code:`long` and :code:`double` provide a wider value range and more precision, but they are slower and your program will consume more memory when running.

Java supports the usual arithmetic operations with number types, that is :code:`+` (addition), :code:`-` (subtraction), :code:`*` (multiplication), :code:`/` (division), and :code:`%` (modulo). There is also a group of operators that can be used to manipulate integer values on bit level (for example, left shift :code:`<<`  and bitwise and :code:`&`), but we will not discuss them further here.

The :code:`char` type is used to work with individual characters (letters, digits,...):

..  code-block:: java

    char c = 'a';

You might wonder why this type is shown in the above table as a type with values between 0 and 65535. This is because Java represents characters by numbers following a standard called *Unicode*. Consequently, you can do certain simple arithmetic operations with characters:

.. code-block:: java

    char c = 'a';
    c++;
    System.out.println(c);  // prints 'b'

You can find more information about Unicode on `<https://en.wikipedia.org/wiki/Unicode>`_.


Type casting
------------

Java performs automatic conversions between values of different types if the destination type is "big" enough to hold the result. This is called *automatic type casting*. For this reason, these two statements are allowed:

..  code-block:: java

    float a = 34;             // the int value 34 is casted to float 34.0f
    float b = 6 * 4.5f;       // int multiplied by float gives float
    
But this is not allowed:

..  code-block:: java

    int a = 4.5f;             // Error! float is not automatically casted to int
    float b = 4.5f * 6.7;     // Error! float * double gives double

You can force the conversion by doing a *manual type cast*, but the result will be less precise or, in some situations, even wrong:

..  code-block:: java

    int a = (int) 4.5f;             // this will give 4 
    float b = (float) (4.5f * 6.7);

The Java class :code:`Math` provides a large set of methods to work with numbers of different types. It also defines useful constants like :code:`Math.PI`. Here is an example:

..  code-block:: java

    double area = 123.4;
    double radius = Math.sqrt(area / Math.PI);

    System.out.println("Area of disk: " + area);
    System.out.println("Radius of disk: " + radius);

The complete documentation of the :code:`Math` class can be found at `<https://docs.oracle.com/javase/8/docs/api/java/lang/Math.html>`_.
 
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

The same also happens with the parameters of methods; when you call a method with arguments, for example :code:`calculateArea(side)`, the argument values are copied into the parameter variables of the called method. Look at the following program and try to understand what it does:

..  code-block:: java

    public class Main {
        static void f(int x) {
            x = x + 1;
        }

        public static void main(String[] args) {
            int i = 3;
            f(i);
            System.out.println(i);
        }
    }

The above program will print ``3`` because when you call the method :code:`f`, the content of the variable :code:`i` will be copied into the parameter variable :code:`x` of the method. Even if the method changes the value of :code:`x` with :code:`x = x + 1`, the variable :code:`i` will keep its value 3.



Note that it is illegal to use a local variable, i.e., a variable declared inside a method, before you have assigned a value to it:

..  code-block:: java

    public static void main(String[] args) {
        int a = 2;
        int b;
        int c;
           
        int d = a * 3;    // This is okay
        
        b = 3;
        int e = b * 3;    // This is okay
        
        int f = c * 3;    // Error! "c" has not been initialized.
    }

Class variables
----------------

In our examples so far, all variables were either parameter variables or local variables of a method. Such variables are only "alive" when the program is inside the method during execution. 
However, you can also have variables that "live" outside a method. These variables are called *class variables* because they belong to a class, not to a method. Similar to static methods, we mark them with the keyword :code:`static`:

..  code-block:: java

    public class Main {

        static int a = 3;   // this is a class variable

        static void increment() {
            a += 5;         // this is equivalent to  a = a + 5
        }

        public static void main(String[] args) {
            increment();
            System.out.println(a);
        }
    }
  
In contrast to local variables, class variables do not need to be manually initialized. They are automatically initialized to 0 (for number types) or :code:`false` (for the ``boolean`` type). Therefore, this code is accepted by the compiler:

..  code-block:: java

    public class Main {

        static int a;   //  is equivalent to  a = 0

        static void increment() {
            a += 5;
        }

        public static void main(String[] args) {
            increment();
            System.out.println(a);
        }
    }
      
Be careful when you have class variables and parameter or local variables with the same name:

..  code-block:: java

    public class Main {

        static int a = 3;

        static void increment(int a) {
            a += 5;     // this is the parameter variable
        }

        public static void main(String[] args) {
            increment(10);
            System.out.println(a);
        }
    }
  
In the method ``increment``, the statement :code:`a += 5` will change the value of the parameter variable :code:`a`, **not** of the class variable. We say that the parameter variable *shadows* the class variable because they have the same name. Inside the method :code:`increment`, the parameter variable :code:`a` has priority over the class variable :code:`a`. We say that the method is the *scope* of the parameter variable.

In general, you should try to avoid shadowing because it is easy to make mistakes, but if you really need to do it for some reason, you should know that it is still possible to access the class variable from inside the scope of the parameter variable:

..  code-block:: java

    public class Main {

        static int a = 3;

        static void increment(int a) {
            Main.a += 5;   // we want the class variable!
        }

        public static void main(String[] args) {
            increment(10);
            System.out.println(a);
        }
    }
  

Arrays (*fr.* tableaux)
=======================

Working with arrays
-------------------

If you need a certain number of variables of the same primitive type, it can be useful to use an array type instead. Arrays are similar to lists in Python. One big difference is that when you create a new array you have to specify its size, i.e., the number of elements in it:

..  code-block:: java

    int[] a = new int[4];  // an array of integers with 4 elements
    
Another big difference is that all the elements of a Java array must have the same type, whereas a Python list can store elements of different types. In the example above, the Java array can only store ``int`` values.

Once the array has been created, you can access its elements :code:`a[0]`, :code:`a[1]`, :code:`a[2]`, :code:`a[3]`. Like class variables, the elements of an array are automatically initialized when the array is created:

..  code-block:: java

    int[] a = new int[4];   // all elements of the array are initialized to 0
    a[2] = 5;
    int b = a[1] + a[2];   
    System.out.println(b);  // prints "5" because a[1] is 0

Note that the size of an array is fixed. Once you have created it, you cannot change the number of elements in it. Unlike Python lists, arrays in Java do not have ``slice()`` or ``append()`` methods to add or remove elements. However, we will see later the more flexible :code:`ArrayList` class.

Mental model for arrays
-----------------------

There is an important difference between array variables and primitive-type variables. An array variable does not directly represent the array elements. Instead, an array variable can be seen as a *reference* to the content of the array. You can imagine it like this:

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

In that case, **only the reference to the array is copied, not the array itself**. This means that both variables :code:`a` and :code:`b` are now referencing the same array. This can be shown with the following example:

..  code-block:: java

    int[] a = new int[4];
    int[] b = a;              // a and b are now references to the same array
    b[2] = 5;
    System.out.println(a[2]); // prints "5"

This also works when you give an array as an argument to a method:

..  code-block:: java

    public class Main {

        static void five(int[] x) {
            x[2] = 5;
        }

        public static void main(String[] args) {
            int[] a = new int[4];
            five(a);
            System.out.println(a[2]);  // prints "5"
        }
    }

In this example, the method ``five()`` receives a *reference* to the array ``a`` (i.e., not a copy of it), which allows the method to modify the content of the array ``a``.

Initializing an array
---------------------

There is a convenient way to create and initialize an array in one single step:

..  code-block:: java

    int[] a = { 2, 5, 6, -3 };  // an array with four elements

This is equivalent to the longer code:
    
..  code-block:: java

    int[] a = new int[4];  // Creation of the array
    
    // Initialization of the array
    a[0] = 2;
    a[1] = 5;
    a[2] = 6;
    a[3] = -3;

But note that this short form is only allowed when you initialize a newly declared array variable. If you want to create a new array and assign it to an existing array variable, you have to use a different syntax:

..  code-block:: java

    int[] a = { 2, 5, 6, -3 }  
    a = new int[]{ 1, 9, 3, 4 };


Multi-dimensional arrays
------------------------

Arrays can have more than one dimension. For example, two-dimensional arrays are often used to represent matrices in mathematical calculations:

..  code-block:: java

    int[][] a = new int[3][5];  // this array can be used to represent a 3x5 matrix
    a[2][4] = 5;

You can imagine a two-dimensional array as an array where each element is again a reference to an array:

.. image:: _static/images/part1/arrayarray.svg
   :width: 40%                            

An :code:`int[3][5]` is therefore an array of three arrays containing five elements each. The following code illustrates this:

..  code-block:: java

    int[][] a = new int[3][5];
    int b[] = a[0];  // b is now a reference to an int array with 5 elements
    b[3] = 7;
    System.out.println(a[0][3]);  // b[3] and a[0][3] are the same element

Again, there is a convenient way to create and initialize multi-dimensional arrays in one step:

..  code-block:: java

    // 3x3 Identity matrix from the Linear Algebra course
    int[][] a = {       
        { 1, 0, 0 },
        { 0, 1, 0 },
        { 0, 0, 1 }
    };
    
Partially initialized arrays
-------------------------------

It is possible to create a "partially initialized" two-dimensional array in Java:
   
..  code-block:: java
   
    int[][] a = new int[3][];
    
Again, this is an array of arrays. However, because we have only specified the size of the first dimension, the elements of this array are initialized to :code:`null`. We can initialize them later:

..  code-block:: java
   
    int[][] a = new int[3][];
    a[0] = new int[5];            // 5 elements
    a[1] = new int[5];            // 5 elements
    a[2] = new int[2];            // 2 elements. That's allowed!
    
As shown in the above example, the elements of a multi-dimensional array are all arrays, but they do not need to have the same size.

Arrays and class variables
--------------------------

Array variables can be class variables (with the :code:`static` keyword), too. If you don't provide an initial value, the array variable will be initialized with the value :code:`null`:

..  code-block:: java

  public class Main {

    static int[] a;   //  automatically initialized to null

    public static void main(String[] args) {
        // this compiles, but it gives an error during execution,
        // because we have not initialized a
        System.out.println(a[2]);
    }
  }

You can think of the value :code:`null` as representing an invalid reference.


Loops
=====

The two most common loop constructs in Java are the :code:`while` loop and the :code:`for` loop.

"While" loops
-------------

The :code:`while` loop in Java is very similar to its namesake in Python. It repeats one or more statements (we call them the *body* of the loop) as long a condition is met. Here is an example calculating the sum of the numbers from 0 to 9 (again, the surrounding :code:`main()` method is not shown):

..  code-block:: java

    int sum = 0;
    int i = 0;
    while (i<10) {
        sum += i;    // this is equivalent to sum = sum + i
        System.out.println("Nearly there");
        i++;         // this is equivalent to i = i + 1
    }
    System.out.println("The sum is " + sum);

**Warning:** The two statements inside the :code:`while` loop must be put in curly braces :code:`{...}`. If you forget the braces, only the *first* statement will be executed by the loop, independently of how the line is indented:

..  code-block:: java

    int sum = 0;
    int i = 0;
    while (i<10)                             // oops, we forgot to put a brace '{' here!
        sum += i;                            // this statement is INSIDE the loop
        System.out.println("Nearly there");  // this statement is OUTSIDE the loop!!!
        i++;                                 // this statement is OUTSIDE the loop!!!
    
    System.out.println("The sum is " + sum);

This is also true for other types of loops and for if/else statements.

**To avoid "accidents" like the one shown above, it is highly recommended to always use braces for the body of a loop or if/else statement, even if the body only contains one statement.**

.. _simple_for_loops:

Simple "for" loops
------------------

There are two different ways how :code:`for` loops can be used. The simple :code:`for` loop is often used to do something with each element of an array or list (We will learn more about lists later):

..  code-block:: java

    int[] myArray = new int[]{ 2, 5, 6, -3 };
    int sum = 0;
    for (int elem : myArray) {
        sum += elem;
    }
    System.out.println("The sum is " + sum);

The :code:`for` loop will do as many iterations as number of elements in the array, with the variable :code:`elem` successively taking the values of the elements. 

Complex "for" loops
-------------------

There is also a more complex version of the :code:`for` loop. Here is again our example calculating the sum of the numbers from 0 to 9, this time with a :code:`for` loop:

..  code-block:: java

    int sum = 0;
    for (int i = 0; i<10; i++) {
        sum += i;
        System.out.println("Nearly there");
    }
    System.out.println("The sum is " + sum);

The first line of the :code:`for` loop consists of three components:

1. a statement that is executed when the loop starts. In our example: :code:`int i = 0`.
2. an expression evaluated *before* each iteration of the loop. If the expression is :code:`false`, the loop stops. Here: :code:`i<10`.
3. a statement that is executed *after* each iteration of the loop. Here: :code:`i++`.

The complex :code:`for` loop is more flexible than the simple version because it gives you full control over what is happening in each iteration. Here is an example where we calculate the sum of every second element of an array:

..  code-block:: java

        int[] myArray = new int[]{ 2, 5, 6, -3, 4, 1 };
        int sum = 0;
        for (int i = 0; i<myArray.length; i += 2) {
            sum += myArray[i];
        }
        System.out.println("The sum is " + sum);

In this example, we have done two new things. We have used :code:`myArray.length` to get the size of the array :code:`myArray`. And we have used the statement :code:`i+=2` to increase :code:`i` by 2 after each iteration.

Stopping a loop and skipping iterations
---------------------------------------

Like in Python, you can leave any loop with the :code:`break` statement:

..  code-block:: java

    int sum = 0;
    for (int i = 0; i<10; i++) {
        sum += i;
        if (sum>5) {
            break;
        }
    }

And we can immediately go to the next iteration with the :code:`continue` statement:

..  code-block:: java

    int sum = 0;
    for (int i = 0; i<10; i++) {
        if (i==5) {
            continue;
        }
        sum += i;
    }
    
But you should only use :code:`break` and :code:`continue` if they make your program easier to read. In fact, our above example was not a good example because you could just write:

..  code-block:: java

    for (int i = 0; i<10; i++) {
        if (i!=5) {     // easier to understand than using "continue"
            sum += i;
        }
    }


Conditional Statements
======================

"If/else" statements
--------------------

As you have seen in some of the examples above, Java has an :code:`if` statement that is very similar to the one in Python. Here is an example that counts the number of negative and positive values in an array:

..  code-block:: java

    int[] myArray = new int[]{ 2, -5, 6, 0, -4, 1 };
    int countNegative = 0;
    int countPositive = 0;
    for(int elem : myArray) {
        if(elem<0) {
            countNegative++;
        }
        else if(elem>0) {
            countPositive++;
        }
        else {
            System.out.println("Value zero found");
        }
    }
    System.out.println("The number of negative values is " + countNegative);
    System.out.println("The number of positive values is " + countPositive);

As with loops, be careful not to forget to use curly braces :code:`{...}` if the body of the if/else statement contains more than one statement. **It is highly recommended to always use braces, even if the body contains only one statement.**

Comparison and logical operators
--------------------------------

The :code:`if` statement requires a Boolean expression, i.e., an expression that evaluates to :code:`true` or :code:`false`. There are several operators for Boolean values that are quite similar to the ones you know from Python:

.. code-block:: java

    boolean b1 = 3 < 4;     // we also have <, >, <=, >=, ==, !=
    boolean b2 = !b1;       // "not" in Python
    boolean b3 = b1 && b2;  // "and" in Python
    boolean b4 = b1 || b2;  // "or" in Python

"Switch" statement
------------------

Imagine a program where you test a variable for different values:

..  code-block:: java

    // two integer variables that represent our position on a map
    int x = 0, y = 0;
    
    // the directions in which we want to go
    char[] directions = new char[]{'N', 'S', 'S', 'E', 'E', 'W'};
    
    // let's go!
    for (char c : directions) {
        if(c=='N') {
            y++;            // we go North
        }
        else if(c=='S') {
            y--;            // we go South
        }
        else if(c=='W') {
            x--;            // we go West
        }
        else if(c=='E') {
            x++;            // we go East
        }
        else {
            System.out.println("Unknown direction");
        }
        System.out.println("The new position is " + x + " , " + y);
    }

Java has a :code:`switch` statement that allows you to write the above program in a clearer, more compact way:

.. code-block:: java

    int x = 0, y = 0;
    
    char[] directions = new char[]{'N', 'S', 'S', 'E', 'E', 'W'};

    for (char c : directions) {
        switch (c) {
            case 'N' -> { y++; }     // we go North
            case 'S' -> { y--; }     // we go South
            case 'W' -> { x--; }     // we go West
            case 'E' -> { x++; }     // we go East
            default -> { System.out.println("Error! Unknown direction"); }
        }
        System.out.println("The new position is " + x + " , " + y);
    }

Note that the above code only works with Java version 14 or newer. In older Java versions, the :code:`switch` statement is a bit more complex as it necessitates to separate the cases using the :code:`break` statement:

.. code-block:: java

    switch (c) {
        case 'N':
            y++;
            break;  // if you forget the "break", very bad things will happen!
        case 'S':
            y--;
            break;
        case 'W':
            x--;
            break;
        case 'E':
            x++;
            break; 
        default:
            System.out.println("Error! Unknown direction");        
    }

Since Java 8 is still widely used, you should familiarize yourself with both versions of the :code:`switch` statement.

 
Strings
=======

Working with strings
--------------------

Variables holding string values have the type :code:`String`. Strings can be concatenated to other strings with the + operator. This also works for primitive types:

.. code-block:: java

    String s1 = "This is a string";
    String s2 = "This is another string";
    String s3 = s1 + "---" + s2 + 12345;
    System.out.println(s3);
    
The :code:`String` class defines many interesting methods that you can use to work with strings. If you check the documentation at  `<https://docs.oracle.com/javase/8/docs/api/java/lang/String.html>`_, you will notice that some methods of the :code:`String` class are static and some are not.
For example, the static method :code:`valueOf` transforms a number value into a string:

.. code-block:: java

    double x = 1.234;
    String s = String.valueOf(x);
    System.out.println(s);

But most methods of the :code:`String` class are not static, i.e., you have to call them on a string value or string variable. Here are some frequently used methods:

.. code-block:: java

    String s = "Hello world";
    int l = s.length();                 // the length of the string
    boolean b = s.isEmpty();            // true if the string has length 0
    char c = s.charAt(3);               // the character in the string at position 3
    boolean b2 = s.startsWith("Hello"); // true if the string starts with "Hello"
    int i = s.indexOf("wo");            // gives the position of "wo" in the string
    String t = s.substring(2);          // the string starting at position 2
    
There are also some methods for strings that are located in other classes. The most useful ones are the methods to convert strings to numbers. For :code:`int` values, there is for example the static method :code:`parseInt` in the :code:`Integer` class:

.. code-block:: java

    int i = Integer.parseInt("1234");
    
Similar methods exist in the classes :code:`Long`, :code:`Float`, :code:`Double`, etc. for the other primitive types. All these classes are defined in the package :code:`java.lang`, for which you can find the documentation at `<https://docs.oracle.com/javase/8/docs/api/java/lang/package-summary.html>`_.


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


.. _enumerations:

Enumerations
============

Enums in Java are a type that represents a group of constants (unchangeable variables, like final variables). 
They are a powerful mechanism for defining a set of named values, which you can use in a type-safe way. 
Enums are a feature that enhances code readability and maintainability by allowing you to declare collections of constants with their own namespace.

Using a ``switch`` statement is very convenient for reacting according to the value of an enum variable. 
Alternatively, since they are constants and there's only one instance of each enum constant in the JVM, you can use the ``==`` operator to compare them for equality.

We revisit the direction instruction example but using an ``enum`` instead of ``char`` to encode the directions.
Note that this code is safer since it is impossible to have a direction that is not in the list of the ones defined in the enum.
Therefore we don't have to deal with the possibility of an unknown direction in the ``switch`` statement.


.. code-block:: java



    public class DirectionFollower {

        public enum Direction {
            NORTH, EAST, SOUTH, WEST;
        }
        
        /**
         * Computes the final coordinates after applying a series of movements to a starting position.
         *
         * @param start The starting coordinates as an array of size two, where start[0] is the x-coordinate and start[1] is the y-coordinate.
         * @param directions An array of {@code Direction} enums that represent the sequence of movements to apply to the starting coordinates.
         * @return A new array of size two representing the final coordinates.
         * 
         * Example:
         * {@code
         * int[] start = {0, 0};
         * Direction[] directions = {Direction.NORTH, Direction.EAST, Direction.NORTH, Direction.WEST};
         * int[] finalCoordinates = followDirections(start, directions);
         * // This will yield final coordinates of [0, 2]
         * }
         */
         public static int[] followDirections(int[] start, Direction[] directions) {
            int[] result = new int[]{start[0], start[1]};
            
            for (Direction direction : directions) {
                switch (direction) {
                    case NORTH:
                        result[1]++;
                        break;
                    case EAST:
                        result[0]++;
                        break;
                    case SOUTH:
                        result[1]--;
                        break;
                    case WEST:
                        result[0]--;
                        break;
                }
            }
            return result;
        }

        public static void main(String[] args) {
            int[] start = {0, 0};
            Direction[] directions = {
                    Direction.NORTH,
                    Direction.EAST,
                    Direction.EAST,
                    Direction.SOUTH,
                    Direction.WEST,
                    Direction.NORTH,
                    Direction.NORTH
            };

            int[] finalCoordinates = followDirections(start, directions);
            System.out.println("The final coordinates are: [" + finalCoordinates[0] + ", " + finalCoordinates[1] + "]");
        }
    }


Comparing things
================

Primitive-type values can be tested for equality with the :code:`==` operator:

.. code-block:: java

    int i = 3;
    if( i==3 ) {
        System.out.println("They are the same!");
    }

However, **this will not work for arrays or strings**. Indeed, since array and string variables only contain references, the :code:`==` operator will compare the *references*, not the *content* of the arrays or strings! The following example shows the difference:

.. code-block:: java
    
    int i = 3;
    System.out.println( i==3 );     // true. Primitive type.
    
    int[] a = {1,2,3};
    int[] b = {1,2,3};
    System.out.println( a==b );     // false. Two different arrays.

    int[] c = a;
    System.out.println( a==c );     // true. Same reference.
    
    String s1 = "Hello" + String.valueOf(1234);
    String s2 = "Hello1234";
    System.out.println( s1==s2 );   // false. Two different strings.

**Comparing arrays or strings with == is a very common mistake in Java. Be careful!**

To compare the *content* of two strings, you must use their :code:`equals()` method:

.. code-block:: java

    String s1 = "Hello" + String.valueOf(1234);
    String s2 = "Hello1234";
    System.out.println( s1.equals(s2) );   // true

There is also an :code:`equals()` method to compare the content of two arrays, but it is a static method of the class :code:`Arrays` in the package :code:`java.util`. To use this class, you have to import it into your program. Here is the complete code:

.. code-block:: java

    import java.util.Arrays;

    public class Main {
        public static void main(String[] args) {
            int[] a = {1,2,3};
            int[] b = {1,2,3};
            System.out.println( Arrays.equals(a,b) );  // true
        }
    }

The :code:`Arrays` class contains many useful methods to work with arrays, such as methods to set all elements of an array to a certain value, to make copies of arrays, or to transform an array into a string. See the documentation at `<https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html>`_.

You might wonder why we need the line :code:`import java.util.Arrays` but we didn't need to import the classes :code:`Math`, :code:`Integer` or :code:`String` in our other examples. That's because those classes are in the package :code:`java.lang`, which is the only package that is automatically imported by the Java compiler.



..
    TODO - Create a new chapter entitled "Object-oriented programming" at this point?


Classes and Objects
===================

Creating your own objects
-------------------------

*Computer programs are about organizing data and working with that data*. In some applications, the primitive types, arrays, and strings are enough, but often you have data that is more complex than that.
For example, imagine a program to manage employees in a company. We can describe the fact that each employee has a name and a salary, by defining a new *class* in our Java program:

.. code-block:: java

    class Employee {
        String name;    // the name of the employee
        int salary;     // the salary of the employee     
    }
    
Classes allow us to create new *objects* from them. In our example, each object of the class :code:`Employee` represents an employee, which makes it easy to organize our data:

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

The two objects that we created and put into the local variables :code:`person1` and :code:`person2` are called *instances* of the class :code:`Employee`, and the two variables :code:`name` and :code:`age` are called *instance variables* of the class :code:`Employee`. Since they are not static, they belong to the instances, and each instance has its own :code:`name` and :code:`age`.

Initializing objects
--------------------

In the above example, we first created the object, and then set the values of its instance variables:

.. code-block:: java

    Employee person1 = new Employee();
    person1.name = "Peter";
    person1.salary = 42000;

Like static variables, instance variables are automatically initialized with the value 0 (for number variables), with :code:`false` (for Boolean variables), or with :code:`null` (for all other types). In our example, this is dangerous because we could forget to specify the salary of the employee:

.. code-block:: java

    Employee person1 = new Employee();
    person1.name = "Peter";
    // oops, the salary is 0

There are several ways to avoid this kind of mistake. One way is to initialize the variable in the class definition:

.. code-block:: java

    class Employee {
        String name;
        int salary = 10000;
    }
    
Of course, this is only useful if you want that all employees start with a salary of 10000. The other way is to define a *constructor* in your class. The constructor is a special method that has the same name as the class. It can have parameters but it has no return type:

.. code-block:: java

    class Employee {
        String name;
        int salary;
        
        // the constructor
        Employee(String n, int s) {   
            this.name = n;
            this.salary = s;
        }
    }

If you provide a constructor for your class, the Java compiler will verify that you use it to create new objects:

.. code-block:: java

    Employee person1 = new Employee("Peter", 42000);
    // Okay. We have now a new employee with
    //    person1.name "Peter"
    //    person1.salary 42000
    
    Employee person2 = new Employee();   // not allowed. You must use the constructor!

In our example, the constructor took two parameters :code:`n` and :code:`s` and used them to initialize the instance variables :code:`name` and :code:`salary` of a new :code:`Employee` object. But how does the constructor know which object to initialize? Do we have to tell the constructor that the new object is in the variable :code:`person1`? Fortunately, it's easier than that. The constructor can always access the object being constructed by using the keyword :code:`this`. Therefore, the line

.. code-block:: java

    this.name = n;

means that the instance variable :code:`name` of the new object will be initialized to the value of the parameter variable :code:`n`. We could even use the same names for the parameter variables and for the instance variables:

.. code-block:: java

    class Employee {
        String name;
        int salary;
        
        Employee(String name, int salary) {
            this.name = name;
            this.salary = salary;
        }
    }

Like for class variables, we have to be careful with shadowing. Without :code:`this.` in front of the variable name, the Java compiler will assume that you mean the parameter variable. It's a common mistake to write something like:

.. code-block:: java

    class Employee {
        String name;
        int salary;

        Employee(String name, int salary) {
            name = name;       //  oops, this.name is not changed here!
            salary = salary;   //  oops, this.salary is not changed here!
        }
    }



Mental model
============

Like array variables and ``String`` variables, object variables contain a reference to the object in your computer's main memory. The object itself contains the instance variables. Note that an instance variable can be again a reference. For our employee ``Peter``, we get the following structure:

+------------------------------------------+-------------------------------------------------+
| Java code                                | In memory during execution                      |
+==========================================+=================================================+
| .. code::                                | .. image:: _static/images/part1/object.svg      |
|                                          |    :width: 70%                                  |
|    Employee person1 =                    |                                                 |
|       new Employee("Peter", 42000);      |                                                 |
|                                          |                                                 |
+------------------------------------------+-------------------------------------------------+

Because of this, what we have already said about array variables and ``String`` variables also holds for object variables: Assigning an object variable to another object variable only copies the reference. Comparing two object variables will only compare the references, not the content of the objects:

.. code-block:: java

    Employee person1 = new Employee("Peter", 42000);
    Employee person2 = new Employee("Peter", 42000);
    System.out.println( person1==person2 );      // false. Two different objects.
    
    Employee person3 = person1;
    System.out.println( person1==person3 );      // true. Same object.

Working with objects
====================

Many things that you can do with primitive types and strings, you can also do them with objects. For example, you can create arrays of objects. The elements of a new array of objects are automatically initialized to :code:`null`, as shown in this example:


.. code-block:: java

    Employee[] myTeam = new Employee[3];
    myTeam[0] = new Employee("Peter", 42000);
    myTeam[1] = new Employee("Anna", 45000);
    System.out.println(myTeam[0].name);       // is "Peter"
    System.out.println(myTeam[1].name);       // is "Anna"
    System.out.println(myTeam[2].name);       // Error! myTeam[2] is null
    

You can also have class variables and instance variables that are object variables. Again, they will be automatically initialized to :code:`null`, if you don't provide an initial value. In the following example, we have added a new instance variable :code:`boss` to our :code:`Employee`:

.. code-block:: java

    class Employee {
        String name;
        int salary;
        Employee boss;
        
        Employee(String name, int salary, Employee boss) {
            this.name = name;
            this.salary = salary;
            this.boss = boss;
        }
    }

    public class Main {
        public static void main(String[] args) {
            // Anna has no boss
            Employee anna = new Employee("Anna", 45000, null);
        
            // Anna is the boss of Peter        
            Employee peter = new Employee("Peter", 42000, anna);            
        }
    }
    
Exercise for you: Take a sheet of paper and draw the mental model graph for the object representing Peter.

Question: In the above example, what value do we give to the :code:`boss` instance variable of an employee who has no boss?

Methods
=======

In the following example, we define a static method :code:`increaseSalary()` to increase the salary of an employee:

.. code-block:: java

    class Employee {
        String name;
        int salary;
        
        Employee(String name, int salary) {
            this.name = name;
            this.salary = salary;
        }
    }

    public class Main {
        static void increaseSalary(Employee employee, int raise) {
            // we only raise the salary if the raise is less than 10000
            if (raise<10000) {
                employee.salary += raise;
            }
        }
    
        public static void main(String[] args) {
            Employee anna = new Employee("Anna", 45000);
            Employee peter = new Employee("Peter", 45000);

            // Anna and Peter get a salary raise
            increaseSalary(anna, 2000);
            increaseSalary(peter, 3000);
            
            System.out.println("New salary of Anna is "+anna.salary);
            System.out.println("New salary of Peter is "+peter.salary);
        }
    }

The above code works. But in Object-Oriented Programming (OOP) languages like Java, we generally prefer that all methods that modify instance variables of an object are put inside the class definition. In a large program, this makes it easier to understand who is doing what with an object. To implement this, we replace the static method :code:`increaseSalary()` of the :code:`Main` class by a non-static method in the :code:`Employee` class:

.. code-block:: java

    class Employee {
        String name;
        int salary;
        
        Employee(String name, int salary) {
            this.name = name;
            this.salary = salary;
        }
        
        void increaseSalary(int raise) {
            if (raise<10000) {
                this.salary += raise;
            }
        }
    }

    public class Main {
        public static void main(String[] args) {
            Employee anna = new Employee("Anna", 45000);
            Employee peter = new Employee("Peter", 45000);
            
            // Anna and Peter get a salary raise
            anna.increaseSalary(2000);
            peter.increaseSalary(3000);
            
            System.out.println("New salary of Anna is "+anna.salary);
            System.out.println("New salary of Peter is "+peter.salary);
        }
    }

Because :code:`increaseSalary()` is now a non-static method of :code:`Employee`, we can directly call it on an Employee object. No parameter :code:`employee` is needed because, inside the method, the :code:`this` keyword is a reference to the object on which the method has been called. Therefore, we just write :code:`anna.increaseSalary(2000)` to change the salary of Anna.

Restricting access
------------------

The nice thing about our :code:`increaseSalary()` method is that we can make sure that raises are limited to 10000 Euro :) However, nobody stops the programmer to ignore that method and manually change the salary:

.. code-block:: java

    Employee anna = new Employee("Anna", 45000, null);
    anna.salary += 1500000;   // ha!

This kind of mistake can quickly happen in a large program with hundreds of classes.    
We can prevent this by declaring the instance variable :code:`salary` as :code:`private`:

.. code-block:: java

    class Employee {
        String name;
        private int salary;
        
        Employee(String name, int salary) {
            this.name = name;
            this.salary = salary;
        }
        
        void increaseSalary(int raise) {
            if (raise<10000) {
                this.salary += raise;
            }
        }
    }

A private instance variable is only accessible *inside* the class. So the access :code:`anna.salary += 150000` in the :code:`Main` class doesn't work anymore. Mission accomplished...

Unfortunately, that's a bit annoying because it also means that we cannot access anymore Anna's salary in :code:`System.out.println("New salary of Anna is "+anna.salary)`. To fix this, we can add a method :code:`getSalary()` whose only purpose is to give us the value of the private :code:`salary` variable. Here is the new version of the code:

.. code-block:: java

    class Employee {
        String name;
        private int salary;
        
        Employee(String name, int salary) {
            this.name = name;
            this.salary = salary;
        }
        
        void increaseSalary(int raise) {
            if (raise<10000) {
                this.salary += raise;
            }
        }
        
        int getSalary() {
            return this.salary;
        }
    }

    public class Main {
        public static void main(String[] args) {
            Employee anna = new Employee("Anna", 45000);
            
            anna.increaseSalary(2000);
            
            System.out.println("New salary of Anna is "+anna.getSalary());
        }
    }


.. _inheritance:
    
Inheritance
===========

Creating subclasses
-------------------

Let's say we are writing a computer game, for example an RPG (role-playing game). We implement weapons as objects of the class :code:`Weapon`. The damage that a weapon can inflict depends on its level. The price of a weapon also depends on its level. The code could look like this:

.. code-block:: java

    class Weapon {
        private int level;
        private String name;

        Weapon(String name, int level) {
            this.name = name;
            this.level = level;
        }

        int getPrice() {
            return this.level * 500;
        }

        int getSimpleDamage() {
            return this.level * 10;
        }
        
        int getDoubleDamage() {
            return this.getSimpleDamage() * 2;
        }
    }
    
    public class Main {   
        public static void main(String[] args) {
            Weapon weapon;
            
            weapon = new Weapon("Small dagger", 2);            
            System.out.println("Price is " + weapon.getPrice());
            System.out.println("Simple damage is " + weapon.getSimpleDamage());
            System.out.println("Double damage is " + weapon.getDoubleDamage());
        }
    }
    
**Before you continue, carefully study the above program and make sure that you understand what it does. Run it in IntelliJ. Things are about to get a little more complicated in the following!**
    
In our game, there is also a special weapon type, the *Mighty Swords*. These swords always deal a damage of 1000, independently of their level. In Java, we can implement this new weapon type like this:

.. code-block:: java

    class MightySword extends Weapon {
        MightySword(String name, int level) {
            super(name,level);
        }

        @Override
        int getSimpleDamage() {
            return 1000;
        }
    } 
 
According to the first line of this code, the class :code:`MightySword` *extends* the class :code:`Weapon`. We say that :code:`MightySword` is *a subclass* (or *subtype*) of :code:`Weapon`, or we can say that :code:`Weapon` is a *superclass* of :code:`MightySword`. In practice, this means that everything we can do with objects of the class :code:`Weapon` we can also do with objects of the class :code:`MightySword`:

.. code-block:: java

    public static void main(String[] args) {
        Weapon weapon;

        weapon = new MightySword("Magic sword", 3);
        System.out.println("Price is " + weapon.getPrice());
        System.out.println("Simple damage is " + weapon.getSimpleDamage());
        System.out.println("Double damage is " + weapon.getDoubleDamage());
    }

At first glance, there seems to be a mistake in the above ``main()`` method. Why is the line

.. code-block:: java

    weapon = new MightySword("Magic sword", 3);
    
not a type error? On the left, we have the variable :code:`weapon` of type :code:`Weapon` and on the right we have a new object of :code:`MightySword`. But this is acceptable for the compiler because, Java has the following rule:

**Rule 1: A variable of type X can hold a reference to an object of class X or to an object of a subclass of X**.

Because of rule 1, the compiler is perfectly happy with putting a reference to a :code:`MightySword` object in a variable declared as type :code:`Weapon`. For Java, MightySword instances are just special Weapon instances.

The next line of the ``main()`` method looks strange, too:

.. code-block:: java

    System.out.println("Price is " + weapon.getPrice());

Our class :code:`MightySword` has not defined a method :code:`getPrice` so why can we call :code:`weapon.getPrice()`? This is another rule in Java:

**Rule 2: The subclass inherits the methods of its superclass. Methods defined in a class X can be also used on objects of a subclass of X.**

Let's look at the next line. It is:

.. code-block:: java

    System.out.println("Simple damage is " + weapon.getSimpleDamage());
    
Just by looking at this line and the line :code:`Weapon weapon` at the beginning of the :code:`main()` method, you might expect that :code:`weapon.getSimpleDamage()` calls the :code:`getSimpleDamage()` method of the :code:`Weapon` class. However, if you check the output of the program, you will see that the method :code:`getSimpleDamage()` of the class :code:`MightySword` is called. Why? Because :code:`weapon` contains a reference to a :code:`MightySword` object. The rule is:

**Rule 3: Let x be a variable of type X (where X is a class) and let's assign an object of class Y (where Y is a subclass of X) to x. When you call a method on x and the method is defined in X and in Y, the JVM will execute the method defined in Y.**

For instances of the class :code:`MightySword`, calling :code:`getSimpleDamage()` will always execute the method defined in that class. We say that the method :code:`getSimpleDamage()` in :code:`MightySword`  *overrides* the method definition in the class ``Weapon``. For that reason, we have marked the method in :code:`MightySword` with the so-called :code:`@Override` annotation.

With the above three rules, can you guess what happens in the next line?

.. code-block:: java

    System.out.println("Double damage is " + weapon.getDoubleDamage());

According to rule 2, the class :code:`MightySword` inherits the method :code:`getDoubleDamage()` of the class :code:`Weapon`. So, let's check how that method was defined in the class :code:`Weapon`:

.. code-block:: java

    int getDoubleDamage() {
        return this.getSimpleDamage() * 2;
    }
    
The method calls :code:`this.getSimpleDamage()`. Which method :code:`getSimpleDamage()` will be called? The one defined in :code:`Weapon` or the one in :code:`MightySword`? To answer this question, you have to remember rule 3! The :code:`this` in :code:`this.getSimpleDamage()` refers to the object on which the method was called. Since our method is an object of the class :code:`MightySword`, the method :code:`getSimpleDamage()` of :code:`MightySword` will be called. The fact that ``getDoubleDamage`` is defined in the class :code:`Weapon` does not change rule 3.

Super
-----

There is one thing left in our :code:`MightySword` class that we have not yet explained. It's the constructor:

.. code-block:: java

    class MightySword extends Weapon {

        MightySword(String name, int level) {
            super(name,level);
        }

        ...
     }
     
In the constructor, the keyword :code:`super` stands for the constructor of the superclass of :code:`MightySword`, that is :code:`Weapon`. Therefore, the line :code:`super(name,level)` simply calls the constructor as defined in :code:`Weapon`.

:code:`super` can be also used in methods. Imagine we want to define a new weapon type *Expensive Weapon* that costs exactly 100 more than a normal weapon. We can implement it as follows:

.. code-block:: java

    class ExpensiveWeapon extends Weapon {

        ExpensiveWeapon(String name, int level) {
            super(name,level);
        }

        @Override
        int getPrice() {
            return super.getPrice() + 100;
        }
    } 

The expression :code:`super.getPrice()` calls the method :code:`getPrice()` as defined in the superclass :code:`Weapon`. That means that the keyword :code:`super` can be used to call methods of the superclass, which would normally not be possible for overridden methods because of rule 3.

The @Override annotation
------------------------

The :code:`@Override` annotation is not strictly necessary in Java (the compiler doesn't need it for itself), but it helps you to avoid mistakes. For example, imagine you made a spelling error when you wrote the name of :code:`getSimpleDamage()`:

.. code-block:: java

    class MightySword extends Weapon {
        MightySword(String name, int level) {
            super(name,level);
        }

        @Override
        int getSimpleDamag() {  //  oops, we forgot the "e" in "getSimpleDamage()"
            return 1000;
        }
    } 

Because of your spelling error, the code above actually does not override anything. It just introduces a new method :code:`getSimpleDamag()`. But thanks to the :code:`@Override` annotation, the Java compiler can warn us that there is a problem.


Extending, extending,...
------------------------

A subclass cannot only override methods of its superclass, it can also add new instance variables and new methods. For example, we can define a new type of Mighty Swords that can do magic damage:

.. code-block:: java

    class MagicSword extends MightySword {
        private int magicLevel;

        MagicSword(String name, int level, int magicLevel) {
            super(name,level);  // call the constructor of MightySword
            this.magicLevel = magicLevel;
        }

        int getMagicDamage() {
            return this.magicLevel * 5;
        }
    } 

As you can see, you can create subclasses of subclasses. Note that the constructor uses again :code:`super` to first call the constructor of the superclass and then initializes the new instance variable :code:`magicLevel`.

How can we call the method :code:`getMagicDamage()`? Can we do this:

.. code-block:: java

    Weapon weapon = new MagicSword("Elven sword", 7, 3);
    System.out.println(weapon.getMagicDamage());
    
The answer is no! Rule 3 is only applied to methods that are defined in the subclass *and* in the superclass. This is not the case for :code:`getMagicDamage()`.
In this situation, the Java compiler will not accept the call :code:`weapon.getMagicDamage()` because, just by looking at the variable declaration :code:`Weapon weapon`, it cannot tell that the object referenced by the variable :code:`weapon` really has a method :code:`getMagicDamage`. You might think that the compiler is a bit stupid here, but remember that this is just a simple example and the programmer could try to do some strange things that are difficult to see for the compiler:

.. code-block:: java

    Weapon weapon = new MagicSword("Elven sword", 7, 3);
    weapon = new Weapon("Dagger", 1);    
    System.out.println(weapon.getMagicDamage());  // does not compile, fortunately!

To be able to call :code:`getMagicDamage()`, you have to convince the compiler that the variable contains a reference to a Magic Sword object. For example, you could change the type of the variable:

.. code-block:: java

    MagicSword weapon = new MagicSword("Elven sword", 7, 3);
    System.out.println(weapon.getMagicDamage());

In this way, it's 100% clear for the compiler that the variable definitely refers to a :code:`MagicSword` object (or to an object of a subclass of :code:`MagicSword`; remember rule 1).

Alternatively, you can do a type cast:

.. code-block:: java

    Weapon weapon = new MagicSword("Elven sword", 7, 3);
    System.out.println(((MagicSword) weapon).getMagicDamage());

However, be careful with type casts. The compiler will accept them but if you do a mistake, you will get an error during program execution:

.. code-block:: java

    Weapon weapon = new Weapon("Dagger", 1);   
    System.out.println(((MagicSword) weapon).getMagicDamage());  // oh oh...

Polymorphism
============

The three rules make it possible to write code and data structures that can be used with objects of different classes. For example, thanks to rule 1, you can define an array that contains different types of weapons:

.. code-block:: java

    Weapon[] inventory = new Weapon[3];
    inventory[0] = new Weapon("Dagger", 2);
    inventory[1] = new MagicSword("Elven sword", 7, 3);
    inventory[2] = new ExpensiveWeapon("Golden pitchfork", 3);

And thanks to rule 2 and 3, you can write methods that work for different types of weapons:

.. code-block:: java

    int getPriceOfInventory(Weapon[] inventory) {
        int sum = 0;
        for (Weapon weapon : inventory) {
            sum += weapon.getPrice();
        }
        return sum;
    }

Although the above method :code:`getPriceOfInventory()` looks like it is only meant for objects of class :code:`Weapon`, it also works for all subclasses of :code:`Weapon`. This is called *Subtype Polymorphism*. If you have for example an object of class :code:`ExpensiveWeapon` in the array, rule 3 will guarantee that :code:`weapon.getPrice()` will call the method defined in :code:`ExpensiveWeapon`.

The conclusion is that there is a difference between what the compiler sees in the source code and what actually happens when the program is executed. When the compiler sees a method call like :code:`weapon.getPrice()` in your source code it only checks whether the method exists in the declared type of the variable. But during program execution, what is important is which object is actually referenced by the variable. We say that **type checking by the compiler is static**, but **method calls by the JVM are dynamic**.


The class hierarchy
===================

If we take all the different weapon classes that we created in the previous examples, we get a so-called "class hierarchy" that shows the subclass-superclass relationships between them:

.. image:: _static/images/part1/classhierarchy.svg
   :width: 35%                                 

The class :code:`Object` that is above our :code:`Weapon` class was not defined by us. It is automatically created by Java and is the superclass of *all* non-primitive types in Java, even of arrays and strings! A variable of type :code:`Object` therefore can refer to any non-primitive value:

.. code-block:: java

    Object o;
    o = "Hello";                                // okay
    o = new int[]{1,2,3};                       // okay, too
    o = new MagicSword("Elven sword", 7, 3);    // still okay!

The documentation of :code:`Object` can be found at `<https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html>`_.
The class defines several interesting methods that can be used on all objects.
One of them is the :code:`toString()` method. This method is very useful because it is called by frequently used methods like :code:`String.valueOf()` and :code:`System.out.println()` when you call them with an object as parameter. Therefore, if we override this method in our own class, we will get a nice output:

.. code-block:: java

    class Player {
        private String name;
        private int birthYear;

        Player(String name, int birthYear) {
            this.name = name;
            this.birthYear = birthYear;
        }

        @Override
        public String toString() {
            return "Player " + this.name + " born in " + this.birthYear;
        }
    }
    
    public class Main {   
        public static void main(String[] args) {
            Player peter = new Player("Peter", 1993);
            System.out.println(peter);   // this will call toString() of Player
        }
    }

The method :code:`toString()` is declared as :code:`public` in the class :code:`Object` and, therefore, when we override it we have to declare it as public, too. We will talk about the meaning of :code:`public` later.

Another interesting method defined by :code:`Object` is :code:`equals()`. We have already learned that we have to use the method :code:`equals()` when we want to compare the content of two strings because the equality operator :code:`==` only compares references. This is also recommended for your own objects. However, comparing objects is more difficult than comparing strings. For our class :code:`Player` shown above, when are two players equal? The Java language cannot answer this question for us, so we have to provide our own implementation of :code:`equals()`. For example, we could say that two :code:`Player` objects are equal if they have the same name and the same birth year:

.. code-block:: java

    import java.util.Objects;
    
    class Player {
        private String name;
        private int birthYear;

        Player(String name, int birthYear) {
            this.name = name;
            this.birthYear = birthYear;
        }
      
        @Override
        public boolean equals(Object obj) {
            if (this==obj) {
                return true;    // same object!
            }
            else if (obj==null) {
                return false;   // null parameter
            }
            else if (this.getClass()!=obj.getClass()) {
                return false;   // different types
            }
            else {
                Player p = (Player) obj;
                return p.name.equals(this.name) && p.birthYear==this.birthYear;
            }
        }
        
        @Override
        public int hashCode() {
            return Objects.hash(this.name, this.birthYear);
        }
    }

    public class Main {   
        public static void main(String[] args) {
            Player peter1 = new Player("Peter", 1993);
            Player peter2 = new Player("Peter", 1993);
            System.out.println( peter1.equals(peter2) );    // true
            System.out.println( peter1.equals("Hello") );   // false
            System.out.println( peter1.equals(null) );      // false
        }
    }

What's happening in the above code? One difficulty with :code:`equals()` is that it can be called with a :code:`null` argument or with an object that is not an instance of :code:`Player`. 
So, before we can compare the name and the birth year of a :code:`Player` object with another :code:`Player` object, we first have to do some tests. One of them is whether the object on which :code:`equals()` was called (:code:`this`) and the other object (:code:`obj`) have the same type:

.. code-block:: java 

    else if (this.getClass()!=obj.getClass()) {
    
If all those tests pass we can finally compare the name and birth year of :code:`this` and the other Player object.

Note that there are some other difficulties with :code:`equals()` that we will not discuss here. They are related to the :code:`hashCode()` method that you have to always override together with :code:`equals()`, as shown above.


ArrayList and Boxing 
====================

ArrayList
---------

Using the class :code:`Object` can be useful in situations where we want to write methods that work with all types of objects. For example, we have seen before that a disadvantage of arrays in Java over lists in Python is that arrays cannot change their size. In the package :code:`java.util`, there is a class :code:`ArrayList` that can do that:

.. code-block:: java

    import java.util.ArrayList;

    public class Main {
        public static void main(String[] args) {
            ArrayList list = new ArrayList();

            // add two elements to the end of the list
            list.add("Hello");
            list.add(new int[]{1,2,3});

            System.out.println( list.size() );    // number of elements
            System.out.println( list.get(0) );    // first element    
        }
    }

As you can see in the above example, the method :code:`add()` of :code:`ArrayList` accepts any reference (including to arrays and strings) as argument. Very simplified, you can imagine that the :code:`ArrayList` class looks like this:

.. code-block:: java

    public class ArrayList {
        // the added elements        
        private Object[] elements;
        
        public void add(Object obj) {
            // this method adds "obj" to the array
            // ...
        }
    
        public Object get(int index) {
            // this method returns the object at position "index"
            // ...
        }
    }

For loops on ArrayList
----------------------

:code:`for` loops also work on "ArrayList":

.. code-block:: java

    ArrayList list = new ArrayList();
    list.add("Hello");
    list.add("World");
    
    // simple for loop
    for (Object obj : list) {
        System.out.println(obj);
    }

    // complex for loop
    for (int i=0; i<list.size(); i++) {
        System.out.println( list.get(i) );
    }


.. _boxing:

Boxing and unboxing
-------------------

Unfortunately, primitive types are not subclasses of :code:`Object`. Therefore, we cannot simple add an :code:`int` value to an ArrayList, at least not without the help of the compiler:

.. code-block:: java

    list.add(3);  // does that work?
        
One way to solve this problem is to write a new class with the only purpose to store the :code:`int` value in an object that we can then add to the list:

.. code-block:: java

    class IntObject {
        int value;
        
        IntObject(value) {
            this.value = value;
        }
    }
    
    public class Main {
        public static void main(String[] args) {
            ArrayList list = new ArrayList();
            
            list.add(new IntObject(3));
        }
    }
    
This trick is called *boxing* because we put the primitive-type value 3 in a small "box" (the :code:`IntObject` object). Fortunately, we actually don't have to write our own class :code:`IntObject`, because the :code:`java.lang` package already contains a class that does exactly that:

.. code-block:: java

    // Integer is a class defined in the java.lang package
    Integer value = Integer.valueOf(3);
    list.add(value);

The :code:`java.lang` package also contains equivalent classes :code:`Long`, :code:`Float`, etc. for the other primitive types.

Note that boxing is quite cumbersome and it is only needed in Java because primitive types are not subclasses of :code:`Object`. However, we get a little bit of help from the compiler. In fact, the compiler can do the boxing for you. This is called **autoboxing**. You can just write:

.. code-block:: java

    list.add(3);  // this automatically calls "Integer.valueOf(3)"

Autoboxing is not limited to the :code:`ArrayList` class. It works for all situations where you assign a primitive-type value to a variable that has a matching class type. The opposite direction, unboxing, is also done automatically by the compiler:

.. code-block:: java

    // autoboxing
    // this is identical to:
    //    Integer value = Integer.valueOf(3);
    Integer value = 3;  
    
    // auto-unboxing
    // this is identical to:
    //    int i = value.intValue();
    int i = value;

.. _generics:
    
ArrayList and Generics
----------------------

The way :code:`ArrayList` uses :code:`Object` to be able to store all kinds of objects has a big disadvantage. Since the :code:`get` method has the return type :code:`Object`, we have to do a type cast if we want again the original type of the object that we added to the list:

.. code-block:: java
    
    ArrayList list = new ArrayList();
    
    list.add("Hello");
    list.add("World");
    
    int len = ((String) list.get(0)).length();
    
Although *we* know that the list only contains strings, the compiler needs the type cast before we can call the method :code:`length()`. This is not only cumbersome, but can also lead to errors that only appear when the program is executed.

Fortunately, Java has a feature called *Generics* that allows us to simplify the above code as follows:

.. code-block:: java

    ArrayList<String> list = new ArrayList<String>();
    
    list.add("Hello");
    list.add("World");
    
    int len = list.get(0).length();

The syntax :code:`ArrayList<String>` tells the compiler that the :code:`add()` method of our list will only accept ``String`` objects as arguments and that the :code:`get()` method will only return ``String`` objects. In that way, the type cast is not needed anymore (actually, the type cast is still done but you don't see it because the compiler automatically adds it in the class file).

You will see more examples of *Generics* later in this book. To give you a first taste, let's see what the :code:`ArrayList` class looks like in reality:

.. code-block:: java

    public class ArrayList<E> {    // type parameter E
        private Object[] elements;
        
        public void add(E obj) {
            // ...
        }
    
        public E get(int index) {
            // ...
        }
    }

The :code:`E` that you can see in the first line and in the method definitions is a *type parameter*. It represents the type of the element that we want to store in the list. By creating our list with

.. code-block:: java

    ArrayList<String> list = new ArrayList<String>();

we are telling the compiler that it should assume that :code:`E = String`, and accordingly the methods :code:`add()` and :code:`get()` will be understood as :code:`void add(String obj)` and :code:`String get(int index)`.


Method overloading
==================

Overloading with different parameters
-------------------------------------

In Java, it is allowed to have two methods with the same name as long as they have different parameters. This is called *method overloading*. Here is an example:

.. code-block:: java

    class Player {
        private String name;
        private int birthYear;

        Player(String name, int birthYear) {
            this.name = name;
            this.birthYear = birthYear;
        }

        public void set(String name) {
            this.name = name;
        }

        public void set(String name, int birthYear) {
            this.name = name;
            this.birthYear = birthYear;
        }
    }

If we call the :code:`set()` method, the Java compiler knows which of the two methods you wanted to call by looking at the parameters:

.. code-block:: java

    Person person = new Person("Peter", 1993);
    person.set("Pierre", 1993);     // this is the set method with parameters String and int

Overloading with subclass parameters
------------------------------------

You have to be careful when you write overloaded methods where the parameters are classes and subclasses. Here is a minimal example of a :code:`Player` class with such an overloaded method:

.. code-block:: java

    class Weapon {
        // ...
    }

    class MightySword extends Weapon {
        // ...
    }

    class Player {
        Weapon weapon;
        int power;

        void giveWeapon(Weapon weapon) {
            this.weapon = weapon;
            this.power = 0;
        }

        void giveWeapon(MightySword weapon) {
            this.weapon = weapon;
            this.power = 10;   // a Mighty Sword increases the power of the player
        }
    }

    public class Main {
        public static void main(String[] args) {
            Player player = new Player();

            Weapon weapon = new MightySword();
            player.giveWeapon(weapon);
            
            System.out.println(player.power);
        }
    }

What will :code:`System.out.println(player.power)` print after we gave a Mighty Sword to the player?

Surprisingly, it will print ``0``. The method :code:`void giveWeapon(MightySword weapon)` is **not** called although we called :code:`giveWeapon()` with a ``MightySword`` object! The explanation for this is that the Java compiler only looks at the type of the variable *as declared in the source code* when deciding which method to call. In our example, the type of the variable :code:`weapon` is :code:`Weapon`, therefore the method :code:`void giveWeapon(Weapon weapon)` is called. The compiler cannot know that the variable will contain a reference to a ``MightySword`` object during program execution.

Lesson learned: **Method calls in Java are only dynamically decided for the object on which the method is called (remember rule 3!). They are not dynamic for the arguments of the method.**

The correct way to call :code:`giveWeapon()` for Mighty Swords is:

.. code-block:: java

    MightySword weapon = new MightySword();
    player.giveWeapon(weapon);
    
or just:

.. code-block:: java

    player.giveWeapon(new MightySword());

Overloading with closest match
------------------------------

What happens if we call an overloaded method but there is no version of the method that exactly matches the type of the argument? Here is the same example as above, but with a third class :code:`MagicSword` that is a subclass of :code:`MightySword`:

.. code-block:: java

    class Weapon {
        // ...
    }

    class MightySword extends Weapon {
        // ...
    }

    class MagicSword extends MightySword {
        // ...
    }

    class Player {
        Weapon weapon;
        int power;

        void giveWeapon(Weapon weapon) {
            this.weapon = weapon;
            this.power = 0;
        }

        void giveWeapon(MightySword weapon) {
            this.weapon = weapon;
            this.power = 10;
        }
    }

    public class Main {
        public static void main(String[] args) {
            Player player = new Player();

            player.giveWeapon(new MagicSword());

            System.out.println(player.power);
        }
    }

Which one of the two :code:`giveWeapon()` will be called if the argument is a :code:`MagicSword` object? In this situation, the compiler will choose the method with the closest type to :code:`MagicSword`, that is :code:`void giveWeapon(MightySword weapon)`.


.. _multiple_inheritance:

Multiple Inheritance
====================

If we look back at our examples with the Weapon subclasses :code:`ExpensiveWeapon` and :code:`MightySword`, we might be tempted to create a new class :code:`ExpensiveMightySword` that inherits from both subclasses:

.. image:: _static/images/part1/multi_inheritance.svg
   :width: 35%  

Unfortunately, inheriting from two (or more) classes is **not allowed** in Java. The reason for this is the *diamond problem* that occurs when a class inherits from two classes that are subclasses of the same class (the problem is named after the diamond shape of the resulting class hierarchy). The following illegal Java program illustrates the problem:

.. code-block:: java

    class Weapon {
        int level;
    
        int getPrice() {
            return 100;
        }
    }

    class ExpensiveWeapon extends Weapon {
        @Override
        int getPrice() {
            return 1000;
        }
    }

    class MightySword extends Weapon {
        @Override
        int getPrice() {
            return 500 * level;
        }
    }

    // Not allowed in Java!
    // You cannot extend TWO classes.
    class ExpensiveMightySword extends ExpensiveWeapon, MightySword {
    }

    public class Main {
        public static void main(String[] args) {
            Weapon weapon = new ExpensiveMightySword();
            System.out.println(weapon.getPrice());        // ???
        }
    }

Which :code:`getPrice` implementation should be called in the :code:`println()` statement? The one from :code:`ExpensiveWeapon` or the one from :code:`MightySword`? Because it is not clear in this situation what the programmer wanted, multiple inheritance is forbidden in Java. Other programming languages allow multiple inheritance under specific circumstances, or have additional rules to decide which method to call. For example, the C# language would require for our example that the :code:`ExpensiveMightySword` class overrides the :code:`getPrice()` method. In Python, the :code:`getPrice()` method of the :code:`ExpensiveWeapon` class would be called because that class appears first in the line

.. code-block:: java

    class ExpensiveMightySword extends ExpensiveWeapon, MightySword {

If you want to know more about how other programming languages handle multiple inheritance and the diamond problem, you can check `<https://en.wikipedia.org/wiki/Multiple_inheritance>`_.

However, Java has another concept, the :code:`interface`, which can be used as a substitute for multiple inheritance in many situations. You will learn more about interfaces later.


.. _final_keyword:

The final keyword
=================

Like the :code:`private` keyword, the :code:`final` keyword does not change the behavior of your program. Its job is to prevent you from making mistakes in your code (you will later see other situations where the :code:`final` keyword is important).

Its meaning depends on where you use it.

Final parameter variables
-------------------------

If you declare a parameter variable as ``final``, its value cannot be changed inside the method. This prevents accidents like the following:

.. code-block:: java

    // calculate the sum of the numbers 1 to n
    int calculateSum(final int n) {   // <--- did you see the "final" ?
        int sum = 0;
        for (int i=1; i<n; i++) {
            n += i;      // oops, I wanted to write sum += i
        }
        return sum;
    }

In the above example, the statement :code:`n+=i` will not be accepted by the compiler because the parameter :code:`n` was declared as ``final``.

Note that if a variable contains a reference to an array or an object, declaring it as ``final`` does not prevent the contents of the array or object from being changed. This is also true for the other usages of :code:`final` explained in the next sections. Here is an example:

.. code-block:: java

    void increment(final int[] a) {
        a[0]++;         // this still works
    }

Final local variables
---------------------

Local variables declared as ``final`` cannot change their value after they have been initialized. The following code will not be accepted by the compiler:

.. code-block:: java

    // calculate the sum of the numbers 1 to n*n
    int calculateSumSquare(int n) {
        final int n2 = n * n;       // <--- did you see the "final" ?
        int sum = 0;
        for (int i=1; i<n2; i++) {
            n2 += i;      // oops, I wanted to write sum += i
        }
        return sum;
    }

Final methods
-------------

Methods declared as ``final`` cannot be overridden in a subclass. Declaring a method as ``final`` is useful in situations where you think that the method contains important code and you fear that a subclass could break the class by overriding it. The following code will not be accepted by the compiler:

.. code-block:: java

    class Person {
        String name, firstname;

        final String getFullName() {
            return firstname + " " + name;
        }
    }

    class Employee extends Person {
        @Override
        String getFullName() {      // not allowed. Method is "final" in "Person" class
            return "Wolverine";
        }
    }

However, you should think carefully about whether you should declare a method as ``final``, as this would drastically limit the flexibility of subclasses.

Final classes
-------------

Classes declared as ``final`` cannot be subclassed. The motivation to do this is similar to ``final`` methods.
For example, the :code:`String` class is final because all Java programs rely on its specific behavior as described in the documentation. Creating a subclass of it would cause a lot of problems.

Final class variables
---------------------

Like ``final`` local variables, class variables declared as ``final`` cannot be changed after initialization. A typical use case is the declaration of a constant. Here is an example:

.. code-block:: java

    class Physics {
        static final double SPEED_OF_LIGHT = 299792458; //  meters per second
    }

The naming convention in Java recommends writing the names of constants in capital letters.

Final instance variables
------------------------

Instance variables declared as ``final`` cannot be changed after initialization. However, unlike class variables, you will usually initialize them in the constructor. The following code demonstrates this:

.. code-block:: java

    class Person {
        final String socialSecurityNumber;

        Person(String ssn) {
            this.socialSecurityNumber = ssn;
        }
    }

    public class Main {
        public static void main(String[] args) {
            Person person = new Person("123-456-789");
            person.socialSecurityNumber = "12";        // error!
        }
    }

An important reason to declare an instance variable as ``final`` is when it is part of the "identity" of an object, i.e., something that should never change once the object has been created.

Note that a variable that cannot be modified after initialization can be also achieved without declaring it as ``final``. In the above example, we could implement the immutable social security number also like this:

.. code-block:: java

    class Person {
        private String socialSecurityNumber;

        Person(String ssn) {
            this.socialSecurityNumber = ssn;
        }
        
        final String getSSN() {  // "final" prevents overriding
            return this.socialSecurityNumber;
        }
    }


Organizing your classes
=======================

.. _packages:

Creating packages
-----------------

In all our small examples so far, we have put all classes in one single ``.java`` file. This is not very practical in larger projects consisting of dozens or hundreds of classes.

**The general rule (or recommendation) in Java is that you should put each class in a separate .java file with the same name as the class.**

In addition, Java allows you to group classes into *packages* by writing a package statement in the first line of your ``.java`` file. For example, the following two ``.java`` files define two classes that are in the package :code:`lepl402.week3`:

.. code-block:: java

    // **********************************
    // ****     File Person.java     ****
    // **********************************

    package lepl1402.week3;

    class Person {
        final String socialSecurityNumber;

        Person(String ssn) {
            this.socialSecurityNumber = ssn;
        }
    }
    
    // **********************************
    // ****      File Main.java      ****
    // **********************************
    
    package lepl1402.week3;

    public class Main {
        public static void main(String[] args) {
            Person person = new Person("123-456-789");
        }
    }


If you put your classes into packages, the Java compiler expects that you organize the source code files in your project in a directory structure that corresponds to the package names. In our example with the package :code:`lepl402.week3`, the .java files **must** be put in a directory ``week3`` inside a directory ``lepl402`` in the ``src`` directory of your project. Here is what IntelliJ shows for the above project:

.. image:: _static/images/part1/project_with_packages.png
  :width: 40%

And here is how the directory structure of the project looks like in the file browser of Microsoft Windows:

.. image:: _static/images/part1/package_directories.png
  :width: 60%

If you do not write a :code:`package` statement in your ``.java`` file (that's what we always did so far in our examples), the compiler puts your classes in the *unnamed package*. In that case, you don't need a special directory structure and you can put all your files directly into the ``src`` directory.

How to use multiple packages
----------------------------

In Java, packages are independent of each other. Classes that are in the same package can be used together, as shown in the example in the previous section with the :code:`Person` class and the :code:`Main` class.

However, classes that are in *different* packages do not "see" each other by default. For example, if we put the class :code:`Person` into the package :code:`lepl1402.week3.example` and we keep the class :code:`Main` in the package :code:`lepl402.week3`, we have to change our code:

.. code-block:: java

    // **********************************
    // ****     File Person.java     ****
    // **********************************

    package lepl1402.week3.example;

    public class Person {
        final String socialSecurityNumber;

        public Person(String ssn) {
            this.socialSecurityNumber = ssn;
        }
    }
    
    // **********************************
    // ****      File Main.java      ****
    // **********************************
    
    package lepl1402.week3;
    
    import lepl1402.week3.example.Person;

    public class Main {
        public static void main(String[] args) {
            Person person = new Person("123-456-789");
        }
    } 

In our example, we have made three modifications:

1. We have declared the class :code:`Person` as :code:`public`. Only classes that are public can be used by classes in other packages! If a class is not declared as public, it can only be used by classes of the same package.

2. We have declared the constructor method of :code:`Person` as :code:`public`. Again, only public methods can be used by classes in other packages.

3. We have added an :code:`import` statement to our file ``Main.java`` file. This statement tells the compiler (and the JVM) in which package the class :code:`Person` is located that the :code:`Main class` wants to use. The identifier :code:`lepl1402.week3.example.Person` is called the *fully qualified name* of the class :code:`Person`.

As an alternative to the ``import`` statement, you could directly use the fully qualified name of the :code:`Person` class in the main method, but this makes the code a bit harder to read:

.. code-block:: java

    // **********************************
    // ****      File Main.java      ****
    // **********************************
    
    package lepl1402.week3;

    public class Main {
        public static void main(String[] args) {
            lepl1402.week3.example.Person person
                  = new lepl1402.week3.example.Person("123-456-789");
        }
    }

Why are packages useful?
------------------------

Packages have two advantages. First of all, with the :code:`public` keyword, you can control for each class and each method in your package whether it can be used by classes in other packages. For example, we have already talked several times about the :code:`java.lang` package that contains useful classes such as :code:`String` or :code:`Integer`. Those classes are declared as public, so everybody can use them. However, that package also contains classes like :code:`CharacterData0E` that are only used internally by some classes in :code:`java.lang` and that are therefore *not* declared as public.

The second advantage of packages is that they provide separate *namespaces*. This means that a package X and a package Y can both contain a class named ``ABC``. By using the fully classified names (or an ``import`` statement), we can exactly tell the compiler whether we want to use class :code:`X.ABC` or class :code:`Y.ABC`. This becomes important when you write larger applications and you want to use packages written by other people. Thanks to the different packages, you don't have to worry about classes with identical names.


.. _visibility:

Access control
--------------

First, let's summarize what we have learned about the visibility of classes in packages:

1. Classes that are declared as :code:`public` are visible in all packages.

2. Non-public classes are only visible inside their own package.

For class members (i.e., static and non-static methods, class variables, and instance variables), the rules are more complicated:

1. Members that are declared as :code:`public` are accessible from all packages.

2. Members that are declared as :code:`private` are only accessible inside their class.

3. Members that are declared as :code:`protected` are only accessible inside their class and in subclasses of that class.

4. Members that have no special declaration are accessible inside the class and by all classes in the same package.


Exceptions
==========

In Java, there are two ways to exit a method: by using the :code:`return` statement or by *throwing an exception*. You already know the :code:`return` statement, so in the following we explain how exceptions work.

Throwing an exception
---------------------

Exceptions are a mechanism for stopping the execution of a method when an exceptional situation occurs that deviates from how the method is normally used. To do this, the :code:`throw` statement is used. Typically, you give the statement an instance of the class :code:`Exception` (or one of its subclasses) that contains information about why the exception was thrown:

.. code-block:: java

    class Employee {
        Employee boss;

        void setBoss(Employee boss) throws Exception {
            if(this==boss) {
                throw new Exception("An employee cannot be their own boss");
            }
            else {
                this.boss = boss;
            }
        }
    }

In general, a method that can throw an exception must indicate this in the method declaration with the keyword :code:`throws` and the class of the thrown exception object.

When a method calls a method that can throw an exception, it can react to an exception by catching it. To do this, it must put a :code:`try`-:code:`catch` block around the calls of the method.

.. code-block:: java

    public class Main {
        public static void main(String[] args) {
            Employee peter = new Employee();
            Employee anna = new Employee();

            try {
                peter.setBoss(anna);    // this is okay
                peter.setBoss(peter);   // this will throw an exception
            }
            catch(Exception e) {
                System.out.println("An exception happened: " + e.getMessage());
            }
        }
    }

When the :code:`setBoss()` method throws an exception, the execution of the code will directly go to the statement(s) specified inside the :code:`catch` block. We say that the message is "caught". The variable :code:`e` contains a reference to the :code:`Exception` object specified in the :code:`throw` statement.

What makes exceptions interesting is that the caller method can decide to not catch the exception. In that case, the exception will be passed to the method that called the caller method and so on until the exception is caught. This is illustrated in the following example:

.. code-block:: java

    public class Main {
        static void setBossOfTeam(Employee[] team, Employee boss) throws Exception {
            for(Employee employee : team) {
                employee.setBoss(boss);    // setBoss(...) can throw an exception,
                                           // but we don't catch it here
            }
        }

        public static void main(String[] args) {
            Employee peter = new Employee();
            Employee anna = new Employee();

            try {
                // a team with two employees:
                Employee team[] = { peter, anna };
                setBossOfTeam(team, peter);  // this will throw an exception
            }
            catch(Exception e) {
                System.out.println("An exception happened: " + e.getMessage());
            }
        }
    }

In the above example, the :code:`main()` method calls the :code:`setBossOfTeam()` method which then calls the :code:`setBoss()` method. The :code:`setBossOfTeam()` method does not catch any exceptions. This means that if an exception is thrown in :code:`setBoss()`, the exception will be passed to :code:`main()` where it is caught, as shown below:

.. image:: _static/images/part1/exception.svg
  :width: 30%

Using Exception subclasses
--------------------------

By creating subclasses of the :code:`Exception` class, we can help the method that catches the exception to understand why the exception happened:

.. code-block:: java

    class SelfBossException extends Exception {
        SelfBossException(String message) {
            super(message);
        }
    }

    class NoBossException extends Exception {
        NoBossException(String message) {
            super(message);
        }
    }

    class Employee {
        Employee boss;

        void setBoss(Employee boss) throws SelfBossException, NoBossException {
            if(this==boss) {
                throw new SelfBossException("An employee cannot be their own boss");
            }
            else if (boss==null) {
                throw new NoBossException("You cannot take the boss away from an employee");
            }
            else {
                this.boss=boss;
            }
        }
    }

    public class Main {
        public static void main(String[] args) {
            Employee peter = new Employee();
            Employee anna = new Employee();

            try {
                peter.setBoss(anna);
                peter.setBoss(null);  // this will throw a NoBossException
            }
            catch(SelfBossException e) {
                System.out.println("SelfBossException happened: " + e.getMessage());
            }
            catch(NoBossException e) {
                System.out.println("NoBossException happened: " + e.getMessage());
            }
        }
    }

If we don't want to use separate :code:`catch` blocks for the different :code:`Exception` subclasses, we can write the catch statement also like this:

.. code-block:: java

    public static void main(String[] args) {
        Employee peter = new Employee();
        Employee anna = new Employee();

        try {
            peter.setBoss(anna);
            peter.setBoss(null);  // this will throw a NoBossException
        }
        catch(SelfBossException | NoBossException e) {
            System.out.println("Some exception happened: " + e.getMessage());
        }
    }

And if we want to catch all exceptions (not only :code:`SelfBossException` and :code:`NoBossException`), we can still write: 

.. code-block:: java

    public static void main(String[] args) {
        Employee peter = new Employee();
        Employee anna = new Employee();

        try {
            peter.setBoss(anna);
            peter.setBoss(null);  // this will throw a NoBossException
        }
        catch(Exception e) {
            System.out.println("Some exception happened: " + e.getMessage());
        }
    }

The above code works, because a statement like :code:`catch(XYZ e) { ... }` catches all exceptions of the class :code:`XYZ` **and  of any subclass** of :code:`XYZ` if the try-catch block has no other :code:`catch` statement for a specific subclass of :code:`XYZ`.


Checked vs unchecked exceptions
-------------------------------

The exceptions that we threw in the above examples are all *checked exceptions*. This means that the compiler verifies that  the exceptions are correctly declared in the :code:`throws` part of the method declaration if the method does not catch them.

However, there are some exceptions for which the compiler does not perform this verification. Such exceptions are called *unchecked*. A famous unchecked exception is the :code:`NullPointerException` that is thrown by the JVM when a program tries to access a null reference:

.. code-block:: java

    public class Main {
        public static void main(String[] args) {
            Object obj = null;
            String s = obj.toString();   // this will throw a NullPointerException
        }
    }

As you can see in the above example, no :code:`throws` declaration or :code:`try`-:code:`catch` block is required for an unchecked exception, but you can still catch it if you want:

.. code-block:: java

    public class Main {
        public static void main(String[] args) {
            Object obj = null;

            try {
                String s = obj.toString();
            }
            catch(NullPointerException e) {
                System.out.println("A null pointer exception happened!");
            }
        }
    }

Unchecked exceptions are either instances of the class :code:`Error` or of the class :code:`RuntimeException` (or of a subclass of these classes). :code:`RuntimeException` is a subclass of :code:`Exception`, and :code:`Error` and :code:`Exception` are subclasses of the class :code:`Throwable`. All instances of :code:`Throwable` (or of a subclass of that class) can be thrown with a :code:`throw` statement. The class hierarchy for these classes is shown below:

.. image:: _static/images/part1/exception_classes.svg
  :width: 30%


Do we need exceptions?
----------------------

Strictly speaking, you *do not need* exceptions. For our example, our :code:`setBoss` method from above

.. code-block:: java

    class Employee {
        Employee boss;
        
        // throws an exception if there is an error
        void setBoss(Employee boss) throws Exception {
            if(this==boss) {
                throw new Exception("An employee cannot be their own boss");
            }
            else {
                this.boss = boss;
            }
        }
    }

could be written without exceptions:

.. code-block:: java

    class Employee {
        Employee boss;

        // returns false if there is an error
        boolean setBoss(Employee boss) {
            if(this==boss) {
                return false;
            }
            else {
                this.boss = boss;
                return true;
            }
        }
    }
    
Consequently, we would not need to catch the exception when we call the method:

.. code-block:: java

    public class Main {
        public static void main(String[] args) {
            Employee peter = new Employee();
            Employee anna = new Employee();
            
            boolean success = peter.setBoss(anna);
            if(success) {
                success = peter.setBoss(peter);
            }
            if(!success) {
                System.out.println("Something bad happened");
            }
        }
    }

As you can see above, the code becomes more complicated without exceptions since we have to check the result of every call of  :code:`setBoss()`. However, we should also mention here that programs without exceptions are easier to understand. Look at these two lines of code in the version of the main method with exceptions:

.. code-block:: java

    peter.setBoss(anna);
    peter.setBoss(null);

Just by reading these two lines, it is not obvious that the second call to :code:`setBoss` is not executed if the first call detects a problem. In the version without exceptions this is immediately clear:

.. code-block:: java

    boolean success = peter.setBoss(anna);
    if(success) {
        success = peter.setBoss(peter);
    }
    
For this reason, exceptions should only be used sparingly. Fortunately, in many program, you don't need to throw your own exceptions, and often the only place you need to catch an exception is when using the existing I/O classes of the JDK. We will show an example in the next section.


.. _file_reader:

Exceptions and I/O operations
-----------------------------

The JDK provides many classes that help you to work with files and communicate with other computers in the Internet. For example, the package :code:`java.io` contains classes to read data from files, to create new files, to delete files, etc. Many of the methods of these classes throw an instance of the :code:`IOException` class if they encounter a problem. 

The below example reads two characters from a text file:

.. code-block:: java

    import java.io.FileReader;
    import java.io.IOException;

    public class Main {
        public static void main(String[] args) {
            try {
                // open the file "somefile.txt"
                FileReader reader = new FileReader("somefile.txt");
                
                // read two characters from the file
                char c1 = (char) reader.read();
                char c2 = (char) reader.read();
                
                // close the file
                reader.close();
            }
            catch(IOException e) {
                System.out.println(e);
            }
        }
    }

The constructor of the :code:`FileReader` class throws a :code:`FileNotFoundException` if the specified file ``somefile.txt`` does not exist. The :code:`read()` method throws an :code:`IOException` if there was a problem when reading the file, for example because the user was not allowed to read that file. Since :code:`FileNotFoundException` is a subclass of :code:`IOException`, we can catch both exceptions with a single :code:`catch(IOException e) {...}`.

The above code has a weakness: If the :code:`read()` method throws an exception, the line :code:`reader.close()` is not executed and the file is not closed. The following code solves this problem by using a :code:`finally` block:

.. code-block:: java

    import java.io.FileReader;
    import java.io.IOException;

    public class Main {
        public static void main(String[] args) {
            try {
                // open the file "somefile.txt"
                FileReader reader = new FileReader("somefile.txt");

                try {
                    // read two characters from the file
                    char c1 = (char) reader.read();
                    char c2 = (char) reader.read();
                }
                finally {
                    // close the file
                    reader.close();
                }
            }
            catch(IOException e) {
                System.out.println(e);
            }
        }
    }

The JVM *always* executes the statements in a :code:`finally` block after the preceding :code:`try` block, even if an exception happened inside the :code:`try` block or the :code:`try` block contains a return statement. For this reason :code:`finally` blocks are often used in combination with try/catch blocks to "clean up" used resources (e.g., close a file).  

The above situation (opening a file, using it, and then closing it) is very common in Java programs. For this reason, Java has a special compact form of the :code:`try` block that is equivalent to the above program. When we us this special form, the Java compiler automatically adds the :code:`finally` block and the :code:`reader.close()` statement to our program:

.. code-block:: java

    import java.io.FileReader;
    import java.io.IOException;

    public class Main {
        public static void main(String[] args) {
            try(FileReader reader = new FileReader("somefile.txt")) {
                char c1 = (char) reader.read();
                char c2 = (char) reader.read();
            }
            catch(IOException e) {
                System.out.println(e);
            }
        }
    }



..
    Generics
    ========
    Comparator
    ==========
    Passing Arguments
    =================
    IO
    ===

