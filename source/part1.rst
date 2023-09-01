.. _part1:

*****************************************************************
Part 1: From Python to Java
*****************************************************************

Your first Java program with IntelliJ
=====================================

In this course LINFO1101, you used the Thonny Integrated Development Environment (IDE) to write your python programs. In this course, we will do something similar to write Java programs: we will use the free Community Edition of Intellij IDEA (we will just call it /IntelliJ/ in the following). You can download the installer from  `<https://www.jetbrains.com/idea/download/>`_ (scroll down to find the free Community edition, you don't need the commercial Ultimate edition). Start the installer and follow the instructions to install IntelliJ on your computer.

The second thing you will need is a Java Development Kit (JDK). A JDK contains the tools and libraries that you need to build and run Java programs. Fortunately, IntelliJ can download it for you when you create a new project. We just mention it here, so you know what to do when you want to run your Java application without IntelliJ. The JDK can be downloaded from `<https://openjdk.org/>`_ (but, as already said, you don't need to do it now).

Start IntelliJ. A window will open where you can create a new project. Click on the corresponding button and you should see a window like this one:

.. image:: _static/images/part1/new_project_screenshot.png
  :width: 90%
  :alt: Starting a new project

To create a new project, you have to enter a project name (in the field "Name") and a location on your disk where you want to store the project (in the field "Location"). Keep the other fields "Language", "Build system", and "Add sample code" as shown in the above picture. But there is something to do in the field "JDK". On my computer, there was already JDK version 20 installed. If you have not already installed a JDK on your computer, open the dropbox and choose "Download JDK" as shown in this picture (as you can see I have already many different JDK versions installed on my computer):

.. image:: _static/images/part1/select_jdk_screenshot.png
  :width: 90%
  :alt: Selecting a JDK

A small window should appear where you can select which JDK version to download and install:

.. image:: _static/images/part1/download_jdk_screenshot.png
  :alt: Downloading a JDK

Select version 20 from the vendor "Oracle OpenJKD". You can keep the location proposed by IntelliJ. Click the "Download" button and complete the JDK installation. Once everything is ready, you can finally create your first Java project. IntelliJ will normally automatically open the new project and showing you the main window:

.. image:: _static/images/part1/first_project_screenshot.png
  :width: 90%
  :alt: The new project

In the left part of the window, you see the project structure. Since we have select "Add sample code" in the project creation window, IntelliJ has already created a "src" directory with one file in it: "Main.java" (the file ending ".java" is not shown). When you double-click the file, its content is shown in editor in the right part of the window.

Click on the right triangle in the upper right corner to start the program. A new view should appear at the bottom of the window with the output of the program:

.. image:: _static/images/part1/program_output_screenshot.png
  :width: 90%
  :alt: Output of the program


How do Java programs look like?
===============================

Here is source code of the :ref:`hello_world_java` automatically created by IntelliJ in your project:

..  code-block:: java
    :caption: Example Program in Java
    :name: hello_world_java

    public class Main {
        public static void main(String[] args) {
            System.out.println("Hello world!");
        }
    }

And here is the equivalent :ref:`hello_world_python`:

..  code-block:: python
    :caption: Hello World Program in Python
    :name: hello_world_python

    print('Hello world!')

Why does the Java code looks more complicated than the Python code? First of all, unlike Python, Java doesn't allow to write a statement like :code:`print('Hello world!')` directly in a source code file. In Java, all statements MUST be inside a method and all methods MUST be inside a class. In our example, the statement :code:`System.out.println("Hello world!")` is in the method "main" and this method is in the class "Main". Of course, a class in Java can have more than one method, and a Java program can have more than one class.

You have already learned about classes and methods in the course LINFO1101 and you might remember that classes are used to create objects and methods are used to work with the objects. In our simple Java example, we don't objects and all the strange things that come with them (constructors, inheritance, etc.). The word :code:`static` in the line :code:`public static void main(String[] args)` indicates that the method "main" behaves more like a function in Python and not like a real method with objects. No object is needed to execute the method "main". We will learn more about this later.

The second thing you might have noticed is the word :code:`public` in the first two lines of the code:

..  code-block:: java

    public class Main {
        public static void main(String[] args) {
        
The :code:`public` in the first line indicates that the class "Main" can be used by others. It is not strictly necessary for this simple program and, in fact, our program will continue to work if you remove it (try it!). However, there is something important you have to know about public classes: If a class is public, the source file that contains the class must have the same name as the class. That's the reason why the file is called "Main.java" and the class is called "Main". Try to change the name of the class and see what happens! Apart from that, the name "Main" doesn't have any special meaning. Our program would still work if we renamed the class (and the file!) to "Catweazle" or "Cinderella".

The :code:`public` in the second line is much more important for our example. A Java program can only be executed if it contains a method "main" that is :code:`public` and :code:`static`. Remove the :code:`public` or :code:`static` from the second line and see what happens when you try to run the program.

In general, the execution of a Java program always starts at the public static main method. With this knowledge, can you guess what this :ref:`two_static` prints?

..  code-block:: java
    :caption: Program with two static methods
    :name: two_static

    public class Main {
        static void printHello() {
            System.out.print("How do ");
            System.out.println("you do, ");
        }
    
        public static void main(String[] args) {   // the program execution starts here!
            printHello();
            System.out.println("fellow kids?");
        }
    }
    
(By the way, have you noticed the difference between :code:`System.out.print` and :code:`System.out.println`?)

Typing
======

Python is a *strongly typed* language. That means that all "things" in Python have a specific type. You can see that by entering the following statements in the Python prompt:

..  code-block:: python

    >>> type("hello")
    <class 'str'>
    >>> type(1234)
    <class 'int'>
    >>> type(1234.5)
    <class 'float'>
    >>> type(True)
    <class 'bool'>

Java is a strongly typed language, too. However, there is a big difference to Python: Java is also a *statically typed* language. We will not discuss all the details here, but most of the time that means that you (the programmer) must indicate for *every* variable in your program what type of "things" it can contain. Here is a simple :ref:`python_with_types`:

..  code-block:: python
    :caption: Python program to calculate and print the area of a square
    :name: python_with_types

    def calculateArea(side):
        return side * side
        
    def printArea(message, side):
        area = calculateArea(side)
        print(message)
        print(area)

    t = 3 + 4
    printArea("Area of square", t)

And here is the equivalent :ref:`java_with_types`:

..  code-block:: java
    :caption: Java program with different types
    :name: java_with_types

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

- The line :code:`int calculateArea(int side)` indicates that the method "calculateArea" has a parameter "side" of type :code:`int`. Furthermore, the :code:`int` before "calculateArea" specifies that this method returns a value of type :code:`int`. This is called the *return type* of the method.
- The line :code:`void printArea(String message, int side)` defines that the method "printArea" has a parameter of type :code:`String` (the "message") and a parameter of type :code:`int` (the "side"). The method does not return anything, therefore it has the special return type :code:`void`.
- Inside the method "printArea", we can see in the line :code:`int area = calculateArea(side)` that the variable "area" has the type :code:`int`.
- (Exercise for you: look at the types that you can see in the "main" method. We will explain later why the "main" method always has a parameter named "args")

Whenever you want to execute a Java program, IntelliJ uses a special tool called the *Java compiler* that carefully verifies that there are no *type errors*  in your program, i.e., that you have not made any mistakes in the type declarations of the variables, parameters, and methods in your program. Unlike Python, this *type checking* is done *before* your program is executed. You cannot even start a Java program that contains type errors!

Here are some examples that contain type errors. Can you find the mistakes?

- :code:`int t = "Hello";`
- :code:`boolean t = calculateArea(3);`
- :code:`printArea(t, "Size of square");` (This example shows why it is easier to find bugs in Java than in Python)


The Java compiler and class files
=================================

In the previous section, we mentioned that a special tool, the Java compiler, checks your program for type errors *before* it is executed. This process is part of another fundamental difference between Python and Java.

Python is an *interpreted language*. That means that when you start a program written in Python in an IDE like Thonny or on the command line with

..  code-block:: bash

    python myprogram.py
    
the Python-Interpreter will

1. load the file "myprogram.py" (and the modules you have imported in your program with the :code:`import` command),
2. do some checks to verify that your program doesn't contain syntax errors such as :code:`print('Hello')))`,
3. execute your program.

Java, being a *compiled language*, works differently. To execute a Java program, another step is needed:

1. First, the Java code has to be compiled. This is the job of the Java compiler, a tool that is part of the JDK. THe compiler does two things:

    - It verifies that your source code is a well-formed Java program. This includes the type checking described in the previous section.
    - It translates your Java source code into a more compact representation that is easier to process for your computer. This compact representation is called a *class file*. One such file will be created per class in your program. In IntelliJ, you can find the generated class files in the directory "out" in your project.
    
2. The class files are loaded and executed by the JVM.

The JVM doesn't need the source code (the .java files) of your program to execute it since the class files contain all the necessary information. If you are a professional software developer, it's usually the class files that you give to your customer, not the source code.

The IntelliJ IDE is running the Java compiler for you, but it's perfectly possible to do it by hand on the command line:

..  code-block:: bash

    javac Main.java     // javac is part of the JDK. It will generate the file Main.class
    java Main           // this command starts the JVM with your Main class


Primitive Types
===============

As explained, Java requires that you specify the type of all variables and the return types of all functions.
Java differs between *primitive types* and complex types, such as arrays and objects. The primitive types are:

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

As you can see, each primitive type has a limited range of values it can represent. If you don't respect this range, very strange things will happen in your program. Try this code in IntelliJ (copy it into the "main" method of your program):

..  code-block:: java

    int a = 123456789;
    int b = a * 100000;     // This is too large for the int type!
    System.out.println(b);  // What will you get here?

For most calculations, it will be sufficient to use :code:`int` (for natural numbers) and :code:`float` (for real numbers). The types :code:`long` and :code:`double` provide a wider value range and more precision, but they are slower and your program will consume more memory when running.

Java performs automatic conversions between values of different types if the destination type is wide enough to hold the result. This is called a *type cast*. For example, this is allowed:

..  code-block:: java

    float a = 34;             // int to float is okay
    float b = a * 4.5f;       // int * float gives float
    
But this is not allowed:

..  code-block:: java

    int a = 4.5f;             // Error! float to int is not okay
    float b = 4.5f * 6.7;     // Error! float * double gives double

You can force the conversion by doing a manual type cast, but the result will be less precise:

..  code-block:: java

    int a = (int)4.5f;             // this will give 4 
    float b = (float)(4.5f * 6.7); // works, but the result might change depending on the values

The Java package "java.lang.Math" provides a large set of functions to work with numbers of different types. Here is an example:

..  code-block:: java

    double area = 123.4;
    double radius = Math.sqrt(area / Math.PI);

    System.out.println("Area of disk: " + area);
    System.out.println("Radius of disk: " + radius);
    
When working with variables of primitive types, you can imagine that every time you declare a variable in your program, the JVM will uses a small part of the main memory of your computer to store the value of the variable:

When you assign the content of a variable to another variable, the value is copied:





 

Arrays and ArrayLists
======================

Strings
=======

Loops
======

Conditional Statements
=======================


Classes and Objects
====================

Organizing Code: Packages
==========================

Visibility Modifiers
====================


Static and Non-Static Methods and Members
==========================================

Passing Arguments
=================

Exceptions
==========

IO
===

