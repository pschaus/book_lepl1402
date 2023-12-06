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


Static nested classes
---------------------

We are now interested in the task of continuously sorting the rows according to the values that are present in the columns, as new rows are added to the spreadsheet.

To this end, the ``Spreadsheet`` class contains the member variable ``sortOnColumn`` that specifies on which column the sorting must be applied, and can be set using the ``setSortOnColumn()`` setter method. We already know that the task of sorting the rows can be solved using a :ref:`delegation to a dedicated comparator <delegation_comparator>`:
    
..  code-block:: java

    class RowRomparator1 implements Comparator<Row> {
        private int column;

        RowRomparator1(int column) {
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
            Collections.sort(rows, new RowRomparator1(sortOnColumn));
        }
    }
    
The ``RowRomparator1`` class is called an **external class** because it is located outside the ``Spreadsheet`` class. This is not a real issue because this sample code is quite short. But in real code, it might be important for readability to bring the comparator class closer to the method that uses it (in this case, ``sort()``). This is why Java features **static nested classes**. This construction allows to define a class at the member level of another class:

..  code-block:: java

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
        // ...

        private static class RowRomparator2 implements Comparator<Row> {
            private int column;

            RowRomparator2(int column) {
                this.column = column;
            }

            @Override
            public int compare(Row a, Row b) {
                return a.get(column).compareTo(b.get(column));
            }
        }

        private void sort() {
            Collections.sort(rows, new RowRomparator2(sortOnColumn));
        }
    }

In this code, ``RowRomparator2`` is the static nested class, and ``Spreadsheet`` is called its **outer class**. Note that ``RowRomparator2`` could have been tagged with a :ref:`public visibility <visibility>` to make it accessible outside of ``Spreadsheet``.

Static nested classes are a way to logically group classes together, improve code organization, and encapsulate functionality within a larger class, promoting a more modular and structured design. Note that it is allowed for two different classes to use the same name for a nested class, which can prevent collisions between class names in large applications, in a way that is similar to :ref:`packages <packages>`.

Importantly, static nested classes have access to the private static members of the outer class, which was not the case of the external class ``RowRomparator1``: This can for instance be useful to take advantage of :ref:`private enumerations or constants <enumerations>` that would be defined inside the outer class.


Inner classes
-------------

The previous code has however a redundancy: The value of ``sortOnColumn`` must be manually copied to a private ``column`` variable of ``RowRomparator2`` so that it can be used inside the ``compare()`` method. Can we do better? The answer is "yes", thanks to the concept of non-static nested classes, that are formally known as **inner classes**. Java allows writing:

..  code-block:: java

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
        // ...

        private class RowRomparator3 implements Comparator<Row> {
            @Override
            public int compare(Row a, Row b) {
                return a.get(column).compareTo(b.get(sortOnColumn));
            }
        }

        private void sort() {
            Collections.sort(rows, new RowRomparator3());
        }
    }
                 
This is much more compact! In this code, ``RowRomparator3`` was defined as an inner class of the outer class ``Spreadsheet``, which grants its ``compare()`` method a direct access to the ``sortOnColumn`` member variable.

Inner classes look very similar to static nested classes, but they do not have the ``static`` keyword. As can be seen, the methods of inner classes can not only access the static member variables of the outer class, but they can also transparently access all members (variables and methods, including private members) of the object that created them. Inner classes were previously encountered in this course when the :ref:`implementation of custom iterators <custom_iterators>` was discussed.


Syntactic sugar
---------------

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

In the context of inner classes, the syntactic sugar consists in including a reference to the outer object that created the instance of the inner object. In our example, the compiler automatically transforms the ``RowRomparator3`` class into the following static nested class:

..  code-block:: java

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
        // ...

        private static class RowRomparator4 implements Comparator<Row> {
            private Spreadsheet outer;  // Reference to the outer object
    
            RowRomparator4(Spreadsheet outer) {
                this.outer = outer;
            }
        
            @Override
            public int compare(Row a, Row b) {
                return a.get(outer.sortOnColumn).compareTo(b.get(outer.sortOnColumn));
            }
        }
    
        private void sort() {
            Collections.sort(rows, new RowRomparator4(this));
        }
    }


Local inner classes
-------------------
    
So far, we have seen three different constructions to define classes:

* External classes are the default way of defining classes, i.e. separately from any other class.

* Static nested classes are members of an outer class. They have access to the static members of the outer class.

* Inner classes are non-static members of an outer class. They are connected to the object that created them through syntactic sugar.

Inner classes are great, but code readability would still be improved if the ``RowComparator3`` class could somehow be brought *inside* the ``sort()`` method, because it is presumably the only location where this comparator would made sense in the application. This would make the one-to-one relation between the method and its comparator immediately apparent. This is the objective of **local inner classes**:

..  code-block:: java

    private void sort() {
        class RowComparator5 implements Comparator<Row> {
            @Override
            public int compare(Row a, Row b) {
                return a.get(sortOnColumn).compareTo(b.get(sortOnColumn));
            }
        }

        Collections.sort(rows, new RowComparator5());
    }

In this new version of the ``sort()`` method, the comparator was defined within the scope of the method. The ``RowComparator5`` class is entirely local to ``sort()``, and cannot be used in another method or class.


.. _anonymous_inner_classes:

Anonymous inner classes
-----------------------

Because local inner classes are typically used at one single point of the method, it is generally not useful to give a name to local inner classes. Consequently, Java features the **anonymous inner class** construction:

..  code-block:: java

    private void sort() {
        Comparator<Row> comparator = new Comparator<Row>() {
            @Override
            public int compare(Row a, Row b) {
                return a.get(sortOnColumn).compareTo(b.get(sortOnColumn));
            }
        };

        Collections.sort(rows, comparator);
    }

As can be seen in this example, an anonymous inner class is a class that is defined without a name inside a method and that instantiated at the same place where it is defined. This construction is often used for implementing interfaces or extending classes on-the-fly. To make this more apparent, note that we could have avoided the introduction of temporary variable ``comparator`` by directly writing:

..  code-block:: java

    private void sort() {
        Collections.sort(rows, new Comparator<Row>() {
            @Override
            public int compare(Row a, Row b) {
                return a.get(sortOnColumn).compareTo(b.get(sortOnColumn));
            }
        });
    }

Anonymous inner classes also correspond to a syntactic sugar construction, because an anonymous inner class can easily be converted into a local inner class.


Access to method variables
--------------------------

Importantly, both local inner classes and anonymous inner classes have **access to the variables of their enclosing method**.

To illustrate this point, let us consider the task of filling a matrix with a constant value using multiple threads. We could create one thread that fills the upper part of the matrix, and another thread that fills the lower part of the matrix. Using a :ref:`thread pool <thread_pools>` and the ``SynchronizedMatrix`` class that was defined to :ref:`demonstrate multithreading <matrix_multiplication>`, the corresponding implementation could be:

..  code-block:: java
                 
    public static void fill1(ExecutorService threadPool,
                             SynchronizedMatrix m,
                             float value) throws ExecutionException, InterruptedException {
        
        class Filler implements Runnable {
            private int startRow;
            private int endRow;

            Filler(int startRow,
                   int endRow) {
                this.startRow = startRow;
                this.endRow = endRow;
            }

            @Override
            public void run() {
                for (int row = startRow; row < endRow; row++) {
                    for (int column = 0; column < m.getColumns(); column++) {
                        // The inner class has access to the "m" and "value" variables!
                        m.setValue(row, column, value);
                    }
                }
            }
        }

        Future upperPart = threadPool.submit(new Filler(0, m.getRows() / 2));
        Future lowerPart = threadPool.submit(new Filler(m.getRows() / 2, m.getRows()));

        upperPart.get();
        lowerPart.get();
    }
    
As can be seen in this example, it is not necessary for the inner class ``Filler`` to explicitly store a copy of ``m`` and ``value``. Indeed, because those two variables are part of the scope of method ``fill1()``, the ``run()`` method has direct access to ``m`` and ``value``. Actually, this is again syntactic sugar: The compiler automatically gives inner classes a copy of all the local variables of the surrounding method.

The method ``fill1()`` creates exactly two threads, one for each part of the matrix. One could want to take advantage of a higher number of CPU cores by reducing this granularity. According to this idea, here is an alternative implementation that introduces parallelism at the level of the individual rows of the matrix:

..  code-block:: java
                 
    public static void fill2(ExecutorService threadPool,
                             SynchronizedMatrix m,
                             float value) throws ExecutionException, InterruptedException {
        Stack<Future> pendingRows = new Stack<>();
        
        for (int row = 0; row < m.getRows(); row++) {
            final int myRow = row;
            
            pendingRows.add(threadPool.submit(new Runnable() {
                @Override
                public void run() {
                    for (int column = 0; column < m.getColumns(); column++) {
                        m.setValue(myRow, column, value);
                    }                    
                }
            }));
        }

        while (!pendingRows.isEmpty()) {
            pendingRows.pop().get();
        }
    }

Contrarily to ``fill1()`` that used a *local* inner class, the ``fill2()`` method uses an *anonymous* inner class an instance of which is created for each row. This is because the first implementation had to separately track exactly two futures using two variables, whereas the second implementation tracks multiple futures using a stack.

There is however a caveat associated with ``fill2()``: One could expect to have access to the ``row`` variable inside the ``run()`` method, because ``row`` is part of the scope of the enclosing method. However, the inner class might continue to exist and be used even after the loop has finished executing and the variable ``row`` has disappeared. To prevent potential issues arising from changes to variables after the start of the execution of a method, an inner class is actually only allowed to access the **final variables** in the scope of method (or variables that could have been tagged as ``final``). Remember that a final variable means that it is :ref:`not allowed to change its value later <final_keyword>`.

In the ``fill2()`` example, ``m`` and ``value`` could have been tagged as ``final``, because their value does not change in the method. Adding a line like ``value = 10;`` inside the method would break the compilation. One could argue that the *content* of ``m`` changes because of the calls to ``m.setValue()``, however the *reference* to the object ``m`` that was originally provided as argument to the method never changes. Finally, the variable ``row`` cannot be declared as ``final``, because its value changes during the loop. Storing a copy of ``row`` inside the variable ``myRow`` is a workaround to solve this issue.

.. admonition:: Remark
   :class: remark

   The example of filling a matrix using multithreading is a bit academic, because for such an operation, the bottleneck will be the RAM, not the CPU. As a consequence, adding more CPU threads will probably never improve performance, and might even be detrimental because of the overhead associated with thread management. Furthermore, our class ``SynchronizedMatrix`` implements mutual exclusion for the access to the individual cells (i.e. the ``setValue()`` is tagged with the ``synchronized`` keyword), which will dramatically reduce the performance.

    
Functional interfaces and lambda functions
==========================================

Since the beginning of our :ref:`exploration of object-oriented programming <part4>`, a recurrent pattern keeps appearing:

* During the :ref:`delegation to comparators of objects <delegation_comparator>`:

  ..  code-block:: java

      public class TitleComparator implements Comparator<Book> {
          @Override
          public int compare(Book b1, Book b2) {
              return b1.getTitle().compareTo(b2.getTitle());
          }
      }

* Inside the :ref:`Observer Design Pattern <observer>`:

  ..  code-block:: java

      class ButtonActionListener implements ActionListener {
          @Override
          public void actionPerformed(ActionEvent e) {
              JOptionPane.showMessageDialog(null,"Thank you!");
          }
      }

* For :ref:`specifying operations to be done by threads <runnable>`:

  ..  code-block:: java

      class Computation implements Runnable {
          @Override
          public void run() {
              expensiveComputation();
          }
      }

This recurrent pattern corresponds to simple classes that implement **one single abstract method** and that have **no member**.

The presence of a single method stems from the fact that these classes implement **one functional interface**. In Java, a functional interface is defined as an :ref:`interface <interfaces>` that contains only one abstract method. It is also known as a Single Abstract Method (SAM) interface. Functional interfaces are a key component of functional programming support introduced in Java 8. The interfaces ``Comparator<T>``, ``ActionListener``, ``Runnable``, and ``Callable<T>`` are all examples of functional interfaces.

.. admonition:: Advanced remarks
   :class: remark

   A functional interface can have multiple ``default`` methods or ``static`` methods without violating the rule of having a single abstract method. This course has not covered ``default`` methods, but it is sufficient to know that a ``default`` method provides a default implementation within an interface that the classes implementing the interface can choose to inherit or overwrite. For instance, the interface ``Comparator<T>`` comes with multiple ``default`` and ``static`` methods, as can be seen in the Java documentation: `<https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html>`_

   In Java 8 and later, the ``@FunctionalInterface`` annotation helps explicitly mark an interface as a functional interface. If an interface annotated with ``@FunctionalInterface`` contains more than one abstract method, the compiler generates an error to indicate that it does not meet the criteria of a functional interface. Nonetheless, pay attention to the fact that not all the functional interfaces of Java are annotated with ``@FunctionalInterface``. This is notably the case of ``ActionListener``.

A **lambda expression** is an expression that creates an instance of an :ref:`anonymous inner class <anonymous_inner_classes>` that has no member and that implements a functional interface. Thanks to lambda expressions, the ``sort()`` method for our spreadsheet application can be shortened as a single line of code:

..  code-block:: java

    private void sort() {
        Collections.sort(rows, (a, b) -> a.get(sortOnColumn).compareTo(b.get(sortOnColumn)));
    }

As can be seen in this example, a lambda expression only specifies the name of the arguments and the body of the unique abstract method of the functional interface it implements. A lambda expression can only appear in a context that expects a value whose type is a functional interface. Once the Java compiler has determined which functional interface is expected for this context, it transparently instantiates a suitable anonymous inner class that implements the expected functional interface with the expected single method.

Concretely, in this example, the compiler notices the construction :code:`Collections.sort(rows, lambda)`. Because ``rows`` has type ``List<Row>``, the compiler looks for a static method in the ``Collections`` class that is named ``sort()`` and that takes as arguments a value of type ``List<Row>`` and a functional interface. As can be seen in the `Java documentation <https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html>`_, the only matching method is :code:`Collections.sort(List<T> list, Comparator<? super T> c)`, with ``T`` corresponding to class ``Row``. The compiler deduces that the functional interface of interest is ``Comparator<Row>``, and it accordingly creates an anonymous inner class as follows:

..  code-block:: java

    private void sort() {
        // The "Comparator<Row>" is the functional interface that matches the lambda expression
        Collections.sort(rows, new Comparator<Row>() {
            @Override
            // The name of the single abstract method and the types of the arguments
            // are derived from the functional interface. The name of the arguments
            // are taken from the lambda expression.
            public int compare(Row a, Row b) {
                // This is the body of the lambda expression
                return a.get(sortOnColumn).compareTo(b.get(sortOnColumn)));
            }
        }
    }

So, again, lambda expressions are syntactic sugar! Very importantly, functional interfaces provide a clear contract for the signature of the method that the matching lambda expression must implement, which is needed for the syntactic sugar to work.

The general form of a lambda expression is:

..  code-block::

    (A a, B b, C c /* ...possibly more arguments */ ) -> {
      /* Body */
      return /* result */;
    }

This general form can be lightened in different situations:

* If the compiler can deduce the types of the arguments, which is most commonly the case, you do not have to provide the types (e.g., ``(A a, B b)`` can be reduced as ``(a, b)``).

* If the lambda expression takes one single argument, the parentheses can be removed (e.g., ``a -> ...`` is a synonym for ``(a) -> ...``).

* If the body of the lambda expression only contains the ``return`` instruction, the curly brackets and the ``return`` can be removed.

* If the lambda expression returns ``void`` and if its body contains a single line, the curly brackets can be removed as well, for instance:

  .. code-block:: java
                  
     i -> System.out.println(i)
  

     



Higher order functions 
=======================

Streams 
========

Immutable collections
=====================


Other example of syntactic sugar:


..  code-block:: java
                 
    list.forEach(item -> System.out.println(item));
    list.forEach(System.out::println);

