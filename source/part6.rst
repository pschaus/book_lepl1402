.. _part6:


*****************************************************************
Part 6: Functional Programming
*****************************************************************

Functional programming refers to a programming paradigm that emphasizes the **use of functions and immutable data** to create applications. This paradigm promotes writing code that is easier to reason about, and that allows for better handling of concurrency.

While Java is not a pure functional language like Haskell, it offers many features that can be used to write more functional-style code. Functional programming in Java encourages the use of pure functions that do not have side effects, i.e., that avoids changing state of the program. Java 8 introduced features to support functional programming, primarily through the addition of lambda expressions, of the ``Stream`` API, and of functional interfaces.


Inner classes
=============

.. NOTE:

   "Terminology: Nested classes are divided into two categories:
   non-static and static. Non-static nested classes are called inner
   classes. Nested classes that are declared static are called static
   nested classes."

   From the official Oracle tutorial on Java:
   https://docs.oracle.com/javase/tutorial/java/javaOO/nested.html


To begin our study of functional programming, we will first go back to the concept of nested classes that has previously been :ref:`briefly encountered <arithmetic_expression>`. A nested class is simply a **class that is defined within another class**. Note that a nested class can also define its own nested classes, just like Matryoshka dolls.

Let us consider the task of creating a spreadsheet application. A spreadsheet document is composed of a number of rows. Each row is made of several columns with string values. A data structure to represent a single row can be modeled as follows:

..  code-block:: java

    import java.util.HashMap;
    import java.util.Map;
    
    class Row {
        private Map<Integer, String> columns = new HashMap<>();
    
        public void put(int column,
                        String value) {
            columns.put(column, value);
        }
    
        public String get(int column) {
            return columns.getOrDefault(column, "" /* default value if absent */);
        }
    }
    
The ``Row`` class uses an `associative array <https://en.wikipedia.org/wiki/Associative_array>`_ that maps integers (the index of the columns) to strings (the value of the columns). The use of an associated array allows to account for columns with a missing value. The standard ``HashMap<K,V>`` class of Java is used to this end: `<https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html>`_

A basic spreadsheet application can then be created on the top of this ``Row`` class. Let us define a spreadsheet document as a list of rows:
    
..  code-block:: java

    import java.util.ArrayList;
    import java.util.List;

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
    
        public Spreadsheet() {
            this.rows = new ArrayList<>();
            this.sortOnColumn = 0;
        }
    
        public void add(Row row) {
            rows.add(row);
            sort();
        }
    
        public void setSortOnColumn(int sortOnColumn) {
            this.sortOnColumn = sortOnColumn;
            sort();
        }

        private void sort() {
            // TODO
        }
    
        static private void fillWithSongs(Spreadsheet spreadsheet) {
            Row row = new Row();
            row.put(0, "Pink Floyd");
            row.put(1, "The Dark Side of the Moon");
            row.put(2, "Money");
            spreadsheet.add(row);
    
            row = new Row();
            row.put(0, "The Beatles");
            row.put(1, "Abbey Road");
            row.put(2, "Come Together");
            spreadsheet.add(row);
    
            row = new Row();
            row.put(0, "Queen");
            row.put(1, "A Night at the Opera");
            row.put(2, "Bohemian Rhapsody");
            spreadsheet.add(row);
        }
        
        static public void main(String[] args) {
            Spreadsheet spreadsheet = new Spreadsheet();
            fillWithSongs(spreadsheet);
        }
    }

This Java application creates a spreadsheet with 3 rows and 3 columns that are filled with information about 3 songs. If exported to a real-world spreadsheet application such as LibreOffice Calc, it would be rendered as follows:

.. image:: _static/images/part6/spreadsheet.png
  :width: 480
  :align: center
  :alt: Spreadsheet

We are now interested in the task of continuously sorting the rows according to the values that are present in the columns, as new rows are added to the spreadsheet.

To this end, the ``Spreadsheet`` class contains the member variable ``sortOnColumn`` that specifies on which column the sorting must be applied, and can be set using the ``setSortOnColumn()`` setter method. We already know that the task of sorting the rows can be solved using a :ref:`delegation to a dedicated comparator <delegation_comparator>`:
    
..  code-block:: java

    class MyComparator1 implements Comparator<Row> {
        private int column;

        MyComparator1(int column) {
            this.column = column;
        }

        @Override
        public int compare(Row a, Row b) {
            return a.get(column).compareTo(b.get(column));
        }
    }

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
        // ...

        private void sort() {
            Collections.sort(rows, new MyComparator1(sortOnColumn));
        }
    }
    
The ``MyComparator1`` class is called an **external class** because it is located outside the ``Spreadsheet`` class. This is not a real issue because this sample code is quite short. But in real code, it might be important for readability to bring the comparator class closer to the method that uses it (in this case, ``sort()``). This is why Java features **static nested classes**. This construction allows to define a class at the member level of another class:

..  code-block:: java

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
        // ...

        private static class MyComparator2 implements Comparator<Row> {
            private int column;

            MyComparator2(int column) {
                this.column = column;
            }

            @Override
            public int compare(Row a, Row b) {
                return a.get(column).compareTo(b.get(column));
            }
        }

        private void sort() {
            Collections.sort(rows, new MyComparator2(sortOnColumn));
        }
    }

In this code, ``MyComparator2`` is the static nested class, and ``Spreadsheet`` is called its **outer class**. Static nested classes are a way to logically group classes together, improve code organization, and encapsulate functionality within a larger class, promoting a more modular and structured design. Note that ``MyComparator2`` could have been tagged with a :ref:`public visibilty <visibility>` to make it accessible outside of ``Spreadsheet``.

Importantly, static nested classes have access to the private static members of the outer class, which was not the case of the external class ``MyComparator1``: This can for instance be useful to take advantage of :ref:`private enumerations or constants <enumerations>` that would be defined inside the outer class.

The latter code has however a redundancy: The value of ``sortOnColumn`` must be manually copied to a private ``column`` variable of ``MyComparator2`` so that it can be used inside the ``compare()`` method. Can we do better? The answer is "yes", thanks to the concept of non-static nested classes, that are formally known as **inner classes**. Java allows writing:

..  code-block:: java

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
        // ...

        private class MyComparator3 implements Comparator<Row> {
            @Override
            public int compare(Row a, Row b) {
                return a.get(column).compareTo(b.get(sortOnColumn));
            }
        }

        private void sort() {
            Collections.sort(rows, new MyComparator3());
        }
    }
                 
This is much more compact! In this code, ``MyComparator3`` was defined as an inner class of the outer class ``Spreadsheet``, which grants its ``compare()`` method a direct access to the ``sortOnColumn`` member variable.

Inner classes look very similar to static nested classes, but they don't have the ``static`` keyword. As can be seen, the methods of inner classes can not only access the static member variables of the outer class, but they can also transparently access all members (variables and methods, including private members) of the object that created them. Inner classes were previously encountered in this course when the :ref:`implementation of custom iterators <custom_iterators>` was discussed.

The fact that ``compare()`` has access to ``sortOnColumn`` might seem magic. This is actually an example of **syntactic sugar**. Syntactic sugar refers to language features or constructs that do not introduce new functionality but provide a more convenient or expressive way of writing code. These features make the code more readable or concise without fundamentally changing how it operates. In essence, syntactic sugar is a shorthand or a more user-friendly syntax for expressing something that could be written in a longer or more explicit manner.

Syntactic sugar constructions were already encountered in this course. :ref:`Autoboxing <boxing>` is such a syntactic sugar. Indeed, the code:

..  code-block:: java
                 
    Integer num = 42;  // Autoboxing (from primitive type to wrapper)
    int value = num;   // Auto unboxing (from wrapper to primitive type)

is semantically equivalent to the more explicit code:

..  code-block:: java
                 
    Integer num = Integer.valueOf(42);
    int value = num.intValue();

Thanks to its knowledge about the standard ``Integer`` class, the compiler can automatically "fill the dots" by adding the constructor and selecting the proper conversion method. The :ref:`enhanced for-each loop for iterators <iterators>` is another example of syntactic sugar, because writing:

..  code-block:: java

    List<Integer> a = new ArrayList<>();
    a.add(-1);
    a.add(10);
    a.add(42);

    for (Integer item: a) {
        System.out.println(item);
    }

is semantically equivalent to:

..  code-block:: java

    Iterator<Integer> it = a.iterator();
    
    while (it.hasNext()) {
        Integer item = it.next();
        System.out.println(item);
    }

Once the compiler comes across some ``for()`` loop on a collection that implements the standard ``Iterable<T>`` interface, it can automatically instantiate the iterator and traverse the collection using this iterator.

In the context of inner classes, the syntactic sugar consists in including a reference to the outer object that created the instance of the inner object. In our example, the compiler automatically transforms the ``MyComparator3`` class into the following static nested class:

..  code-block:: java

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
        // ...

        private static class MyComparator4 implements Comparator<Row> {
            private Spreadsheet outer;  // Reference to the outer object
    
            MyComparator4(Spreadsheet outer) {
                this.outer = outer;
            }
        
            @Override
            public int compare(Row a, Row b) {
                return a.get(outer.sortOnColumn).compareTo(b.get(outer.sortOnColumn));
            }
        }
    
        private void sort() {
            Collections.sort(rows, new MyComparator4(this));
        }
    }

So far, we have seen three different constructions to define classes:

* External classes are the default way of defining classes, i.e. separately from any other class.

* Static nested classes are members of an outer class and have access to the static members of the outer class.

* Inner classes are members of an outer class and keep a reference to the object that created them through syntactic sugar.


Lambda functions
================


Other example of syntactic sugar:


..  code-block:: java
                 
    list.forEach(item -> System.out.println(item));

    // Method reference (syntactic sugar for the above)
    list.forEach(System.out::println);


Functional interfaces 
======================

Higher order functions 
=======================

Streams 
========

Immutable collections
=====================


