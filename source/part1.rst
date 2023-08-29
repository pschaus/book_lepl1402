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

You have already learned about classes and methods in the course LINFO1101 and you might remember that classes are used to create objects and methods are used to do something with the objects. In our simple example, we don't objects and all the strange things that come with them (constructors, inheritance, etc.). The word :code:`static` in the line :code:`public static void main(String[] args)` indicates that the method "main" behaves more like a function in Python and not like a real method with objects. We will learn more about this later.

The second thing you might have noticed is the word :code:`public` in the first two lines of the code:

..  code-block:: java

    public class Main {
        public static void main(String[] args) {
        
The :code:`public` in the first line  indicates that the class can be used by others. It is not strictly necessary for this simple program. Our program will continue to work if you remove it (try it!). However, there is something important you have to know about public classes: If a class is public, the source file that contains the class must have the same name as the class. That's the reason why the file is called "Main.java" and the class is called "Main". Try to change the name of the class and see what happens! Apart from that, the name "Main" doesn't have any special meaning. Our program would still work if we called the class (and the file!) "Catweazle" or "Cinderella" instead of "Main".

The :code:`public` in the second line is much more important for our example. A Java program can only be executed if it contains a method "main" that is :code:`public` and :code:`static`. Remove the :code:`public` or :code:`static` from the second line and try to run the program.

In general, the execution of a Java program always starts at the public static main method. With this knowledge, can you guess what this :ref:`two_static` prints?

..  code-block:: java
    :caption: Program with two static methods
    :name: two_static

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
    
(Have you noticed the difference between :code:`System.out.print` and :code:`System.out.println`?)



Primitive Types
================

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

