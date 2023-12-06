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
        }
    
        public void setSortOnColumn(int sortOnColumn) {
            this.sortOnColumn = sortOnColumn;
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

We are now interested in the task of sorting the rows according to the values that are present in the columns. To this end, the ``Spreadsheet`` class contains the member variable ``sortOnColumn`` that specifies on which column the sorting must be applied. The ``sortOnColumn`` variable is useful to preserve the same ordering if new rows are added to the spreadsheet. We already know that this task can be solved using a :ref:`delegation to a dedicated comparator <delegation_comparator>`:
    
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

        public void sort() {
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

        public void sort() {
            Collections.sort(rows, new MyComparator2(sortOnColumn));
        }
    }

In this code, ``MyComparator2`` is the static nested class, and ``Spreadsheet`` is called its **outer class**. Static nested classes are a way to logically group classes together, improve code organization, and encapsulate functionality within a larger class, promoting a more modular and structured design. Note that ``MyComparator2`` could have been tagged with a :ref:`public visibilty <visibility>` to make it accessible outside of ``Spreadsheet``.

Importantly, static nested classes have access to the private static members of the outer class (which was not the case of the external class ``MyComparator1``): This can for instance be useful to take advantage of :ref:`private enumerations or constants that would be defined in the outer class <enumerations>`.

The latter code has however a redundancy: The value of ``sortOnColumn`` must be manually copied to a private ``column`` variable of ``MyComparator2`` so that it can be used inside the ``compare()`` method. Can we do better? The answer is "yes", thanks to the concept of non-static nested classes, that are also known as **inner classes**. Java allows writing:

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

        public void sort() {
            Collections.sort(rows, new MyComparator3());
        }
    }
                 
This is much more compact! In this code, ``MyComparator3`` was defined as an inner class of the outer class ``Spreadsheet``, which grants its ``sort()`` method a direct access to the ``sortOnColumn`` member variable.

Inner classes look very similar to static nested classes, but they don't have the ``static`` keyword. As can be seen, the methods of inner classes can not only access the static member variables of the outer class, but they can also transparently access all members (variables and methods) of the outer class, including private members. Inner classes were previously encountered in this course when the :ref:`implementation of custom iterators <custom_iterators>` was discussed.




Lambda functions
================


Functional interfaces 
======================

Higher order functions 
=======================

Streams 
========

Immutable collections
=====================


