.. _part6:


*****************************************************************
Part 6: Functional Programming
*****************************************************************

Functional programming refers to a programming paradigm that emphasizes the **use of functions and immutable data** to create applications. This paradigm promotes writing code that is easier to reason about, and that allows for better handling of concurrency.

While Java is not a pure functional language like Haskell, it offers many features that can be used to write more functional-style code. Functional programming in Java encourages the use of pure functions that have no side effect, i.e., that avoid changing the state of the program. Java 8 introduced features to support functional programming, primarily through the addition of functional interfaces, of lambda expressions, and of the ``Stream`` API.


Nesting classes
===============

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
    
The ``Row`` class uses an `associative array <https://en.wikipedia.org/wiki/Associative_array>`_ that maps integers (the index of the columns) to strings (the value of the columns). The use of an associated array allows to account for columns with a missing value. The standard ``HashMap<K,V>`` class is used to this end: `<https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html>`_

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
            // We will implement this later on
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

We are now interested in the task of continuously sorting the rows according to the values that are present in the columns, as new rows get added to the spreadsheet using the ``addRow()`` method.

To this end, the ``Spreadsheet`` class contains the member variable ``sortOnColumn`` that specifies on which column the sorting must be applied. That parameter can be set using the ``setSortOnColumn()`` setter method. We already know that the task of sorting the rows can be solved through :ref:`delegation to a dedicated comparator <delegation_comparator>`:
    
..  code-block:: java

    class RowComparator1 implements Comparator<Row> {
        private int column;

        RowComparator1(int column) {
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
            Collections.sort(rows, new RowComparator1(sortOnColumn));
        }
    }
    
The ``RowComparator1`` class is called an **external class** because it is located outside of the ``Spreadsheet`` class. This is not an issue because this sample code is quite short. But in real code, it might be important for readability to bring the comparator class closer to the method that uses it (in this case, ``sort()``). This is why Java features **static nested classes**. This construction allows to define a class at the member level of another class:

..  code-block:: java

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
        // ...

        private static class RowComparator2 implements Comparator<Row> {
            private int column;

            RowComparator2(int column) {
                this.column = column;
            }

            @Override
            public int compare(Row a, Row b) {
                return a.get(column).compareTo(b.get(column));
            }
        }

        private void sort() {
            Collections.sort(rows, new RowComparator2(sortOnColumn));
        }
    }

In this code, ``RowComparator2`` is the static nested class, and ``Spreadsheet`` is called its **outer class**. Note that ``RowComparator2`` could have been tagged with a :ref:`public visibility <visibility>` to make it accessible outside of ``Spreadsheet``, in the case the developer felt like sorting collections of ``Row`` objects could make sense in other parts of the application.

Static nested classes are a way to logically group classes together, to improve code organization, and to encapsulate functionality within a larger class. This promotes a more modular and structured design, in a way that is similar to :ref:`packages <packages>`, but at a finer granularity. Note that it is allowed for two different classes to use the same name for a nested class, which can prevent collisions between class names in large applications.

Importantly, static nested classes have access to the private static members of the outer class, which was not the case of the external class ``RowComparator1``: This can for instance be useful to take advantage of :ref:`private enumerations or constants <enumerations>` that would be defined inside the outer class.


Inner classes
-------------

The previous code has however a redundancy: The value of ``sortOnColumn`` must be manually copied to a private ``column`` variable of ``RowComparator2`` so that it can be used inside the ``compare()`` method. Can we do better? The answer is "yes", thanks to the concept of non-static nested classes, that are formally known as **inner classes**. Java allows writing:

..  code-block:: java

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
        // ...

        private class RowComparator3 implements Comparator<Row> {
            @Override
            public int compare(Row a, Row b) {
                return a.get(column).compareTo(b.get(sortOnColumn));
            }
        }

        private void sort() {
            Collections.sort(rows, new RowComparator3());
        }
    }
                 
This is much more compact! This derives from the fact that in this code, ``private static class`` was replaced by ``private class``. This means that ``RowComparator3`` is as an inner class of the outer class ``Spreadsheet``, which grants its ``compare()`` method a direct access to the ``sortOnColumn`` member variable.

Inner classes look very similar to static nested classes, but they do not have the ``static`` keyword. As can be seen, the methods of inner classes can not only access the static member variables of the outer class, but they can also transparently access all members (variables and methods, including private members) of the object that created them. Inner classes were previously encountered in this course when the :ref:`implementation of custom iterators <custom_iterators>` was discussed.

It is tempting to systematically use inner classes instead of static nested classes. But pay attention to the fact that inner classes induce a much closer coupling with their outer classes, which can make it difficult to refactor the application, and which can quickly lead to the so-called `Feature Envy <https://refactoring.guru/fr/smells/feature-envy>`_ "code smell" (i.e. the `opposite of a good design pattern <https://en.wikipedia.org/wiki/Anti-pattern>`_). Use an inner class only when you need access to the instance members of the outer class. Use a static nested class when there is no need for direct access to the outer class instance or when you want clearer namespacing and better code organization.

.. _syntactic_sugar:

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

Thanks to its knowledge about the internals of the standard ``Integer`` class, the compiler can automatically "fill the dots" by adding the constructor and selecting the proper conversion method. The :ref:`enhanced for-each loop for iterators <iterators>` is another example of syntactic sugar, because writing:

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

In the context of inner classes, the syntactic sugar consists in including a reference to the outer object that created the instance of the inner object. In our example, the compiler automatically transforms the ``RowComparator3`` class into the following static nested class:

..  code-block:: java

    public class Spreadsheet {
        private List<Row> rows;
        private int sortOnColumn;
        // ...

        private static class RowComparator4 implements Comparator<Row> {
            private Spreadsheet outer;  // Reference to the outer object
    
            RowComparator4(Spreadsheet outer) {
                this.outer = outer;
            }
        
            @Override
            public int compare(Row a, Row b) {
                return a.get(outer.sortOnColumn).compareTo(b.get(outer.sortOnColumn));
            }
        }
    
        private void sort() {
            Collections.sort(rows, new RowComparator4(this));
        }
    }

As can be seen, the compiler transparently adds a new argument to the constructor of the inner class, which contains the reference to the outer object.


Local inner classes
-------------------
    
So far, we have seen three different constructions to define classes:

* External classes are the default way of defining classes, i.e. separately from any other class.

* Static nested classes are members of an outer class. They have access to the static members of the outer class.

* Inner classes are non-static members of an outer class. They are connected to the object that created them through syntactic sugar.

Inner classes are great for the spreadsheet application, but code readability could still be improved if the ``RowComparator3`` class could somehow be brought *inside* the ``sort()`` method, because it is presumably the only location where this comparator would make sense in the application. This would make the one-to-one relation between the method and its comparator immediately apparent. This is the objective of **local inner classes**:

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

In this new version of the ``sort()`` method, the comparator was defined within the scope of the method. The ``RowComparator5`` class is entirely local to ``sort()``, and cannot be used in another method or class, which further reduces coupling.


.. _anonymous_inner_classes:

Anonymous inner classes
-----------------------

Because local inner classes are typically used at one single point of the method, it is generally not useful to give a name to local inner classes (in the previous example, this name was ``RowComparator5``). Consequently, Java features the **anonymous inner class** construction:

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

As can be seen in this example, an anonymous inner class is a class that is defined without a name inside a method and that instantiated at the same place where it is defined.

This construction is often used for implementing interfaces or extending classes on-the-fly. To make this more apparent, note that we could have avoided the introduction of temporary variable ``comparator`` by directly writing:

..  code-block:: java

    private void sort() {
        Collections.sort(rows, new Comparator<Row>() {
            @Override
            public int compare(Row a, Row b) {
                return a.get(sortOnColumn).compareTo(b.get(sortOnColumn));
            }
        });
    }

Anonymous inner classes also correspond to another :ref:`syntactic sugar <syntactic_sugar>` construction, because an anonymous inner class can easily be converted into a local inner class by giving them a meaningless name.

 
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
    
As can be seen in this example, it is not necessary for the inner class ``Filler`` to explicitly store a copy of ``m`` and ``value``. Indeed, because those two variables are part of the scope of method ``fill1()``, the ``run()`` method has direct access to the ``m`` and ``value`` variables. Actually, this is again :ref:`syntactic sugar <syntactic_sugar>`: The compiler automatically gives inner classes a copy of all the local variables of the surrounding method.

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

Contrarily to ``fill1()`` that used a *local* inner class, the ``fill2()`` method uses an *anonymous* inner class, an instance of which is created for each row. This is because the first implementation had to separately track exactly two futures using two variables, whereas the second implementation tracks multiple futures using a stack.

There is however a caveat associated with ``fill2()``: One could expect to have access to the ``row`` variable inside the ``run()`` method, because ``row`` is part of the scope of the enclosing method. However, the inner class might continue to exist and be used even after the loop has finished executing and the variable ``row`` has disappeared. To prevent potential issues arising from changes to variables after the start of the execution of a method, an inner class is actually only allowed to access the **final variables** in the scope of method (or variables that could have been tagged as ``final``). Remember that a final variable means that it is :ref:`not allowed to change its value later <final_keyword>`.

In the ``fill2()`` example, ``m`` and ``value`` could have been explicitly tagged as ``final``, because their value does not change in the method. But adding a line like ``value = 10;`` inside the method would break the compilation, because ``value`` could not be tagged as ``final`` anymore, which would prevent the use of ``value`` inside the runnable. One could argue that the *content* of ``m`` changes because of the calls to ``m.setValue()``, however the *reference* to the object ``m`` that was originally provided as argument to the method never changes. Finally, the variable ``row`` cannot be declared as ``final``, because its value changes during the loop. Storing a copy of ``row`` inside the variable ``myRow`` is a workaround to solve this issue.

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

      // ...
      Collections.sort(books, new TitleComparator());

* Inside the :ref:`Observer Design Pattern <observer>`:

  ..  code-block:: java

      class ButtonActionListener implements ActionListener {
          @Override
          public void actionPerformed(ActionEvent e) {
              JOptionPane.showMessageDialog(null,"Thank you!");
          }
      }

      // ...
      button.addActionListener(new ButtonActionListener());

* For :ref:`specifying operations to be done by threads <runnable>`:

  ..  code-block:: java

      class Computation implements Runnable {
          @Override
          public void run() {
              expensiveComputation();
          }
      }

      // ...
      Thread t = new Thread(new Computation());
      t.start();

This recurrent pattern corresponds to simple classes that implement **one single abstract method** and that have **no member**.

The presence of a single method stems from the fact that these classes implement a **single functional interface**. In Java, a functional interface is defined as an :ref:`interface <interfaces>` that contains only one abstract method. Functional interfaces are also known as Single Abstract Method (SAM) interfaces. Functional interfaces are a key component of functional programming support introduced in Java 8. The interfaces ``Comparator<T>``, ``ActionListener``, ``Runnable``, and ``Callable<T>`` are all examples of functional interfaces.

.. admonition:: Advanced remarks
   :class: remark

   A functional interface can have multiple ``default`` methods or ``static`` methods without violating the rule of having a single abstract method. This course has not covered ``default`` methods, but it is sufficient to know that a ``default`` method provides a default implementation within an interface that the classes implementing the interface can choose to inherit or overwrite. For instance, the interface ``Comparator<T>`` comes with multiple ``default`` and ``static`` methods, as can be seen in the Java documentation: `<https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html>`_

   In Java 8 and later, the ``@FunctionalInterface`` annotation helps explicitly mark an interface as a functional interface. If an interface annotated with ``@FunctionalInterface`` contains more than one abstract method, the compiler generates an error to indicate that it does not meet the criteria of a functional interface. Nonetheless, pay attention to the fact that not all the functional interfaces of Java are annotated with ``@FunctionalInterface``. This is notably the case of ``ActionListener``.

A **lambda expression** is an expression that creates an instance of an :ref:`anonymous inner class <anonymous_inner_classes>` that has no member and that implements a functional interface. Thanks to lambda expressions, the ``sort()`` method for our spreadsheet application can be shortened as a single line of code:

..  code-block:: java

    private void sort() {
        Collections.sort(rows, (a, b) -> a.get(sortOnColumn).compareTo(b.get(sortOnColumn)));
    }

As can be seen in this example, a lambda expression only specifies the name of the arguments and the body of the single abstract method of the functional interface it implements.

A lambda expression can only appear in a context that expects a value whose type is a functional interface. Once the Java compiler has determined which functional interface is expected for this context, it transparently instantiates a suitable anonymous inner class that implements the expected functional interface with the expected single method.

Concretely, in the ``sort()`` example, the compiler notices the construction :code:`Collections.sort(rows, lambda)`. Because ``rows`` has type ``List<Row>``, the compiler looks for a static method in the ``Collections`` class that is named ``sort()`` and that takes as arguments a value of type ``List<Row>`` and a functional interface. As can be seen in the `Java documentation <https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html>`_, the only matching method is :code:`Collections.sort(List<T> list, Comparator<? super T> c)`, with ``T`` corresponding to class ``Row``. The compiler deduces that the functional interface of interest is ``Comparator<Row>``, and it accordingly creates an anonymous inner class as follows:

..  code-block:: java

    private void sort() {
        // "Comparator<Row>" is the functional interface that matches the lambda expression
        Collections.sort(rows, new Comparator<Row>() {
            @Override
            // The name of the single abstract method and the types of the arguments
            // are extracted from the functional interface. The name of the arguments
            // are taken from the lambda expression.
            public int compare(Row a, Row b) {
                // This is the body of the lambda expression
                return a.get(sortOnColumn).compareTo(b.get(sortOnColumn)));
            }
        }
    }

In other words, lambda expressions are also :ref:`syntactic sugar <syntactic_sugar>`! Very importantly, **functional interfaces provide a clear contract for the signature of the method that the matching lambda expression must implement**, which is needed for this syntactic sugar to work.

Thanks to lambda expressions, the three examples at the beginning of this section could all be simplified as one-liners:

* During the :ref:`delegation to comparators of objects <delegation_comparator>`:

  ..  code-block:: java

      Collections.sort(books, (b1, b2) -> b1.getTitle().compareTo(b2.getTitle()));

* Inside the :ref:`Observer Design Pattern <observer>`:

  ..  code-block:: java

      button.addActionListener(() -> JOptionPane.showMessageDialog(null,"Thank you!"));

* For :ref:`specifying operations to be done by threads <runnable>`:

  ..  code-block:: java

      Thread t = new Thread(() -> expensiveComputation());


The general form of a lambda expression is:

..  code-block::

    (A a, B b, C c /* ...possibly more arguments */ ) -> {
      /* Body */
      return /* result */;
    }

This general form can be lightened in different situations:

* If the compiler can deduce the types of the arguments, which is most commonly the case, you do not have to provide the types (e.g., ``(A a, B b)`` can be reduced as ``(a, b)``).

* If the lambda expression takes one single argument, the parentheses can be removed (e.g., ``a -> ...`` is a synonym for ``(a) -> ...``). Note that a lambda expression with no argument would be defined as ``() -> ...``.

* If the body of the lambda expression only contains the ``return`` instruction, the curly brackets and the ``return`` can be removed.

* If the lambda expression returns ``void`` and if its body contains a single line, the curly brackets can be removed as well, for instance:

  .. code-block:: java
                  
     i -> System.out.println(i)

* It often happens that you want to write a lambda expression that simply calls a method and passes it the arguments it has received. In such situations, Java offers the notion of **method reference**. For instance, the following lambda expression that calls a static method:

  .. code-block:: java
                  
     i -> System.out.println(i)

  can be shortened as:
  
  .. code-block:: java
                  
     System.out::println

  Similarly, the following lambda expression that calls a non-static method on a list of integers:

  ..  code-block:: java

     (List<Integer> a) -> a.size()

  can be rewritten as:
     
  ..  code-block:: java

     List<Integer>::size
     

General-purpose functional interfaces
=====================================

Lambda expressions can only be used in a context that expects a value whose type is a functional interface. It is therefore useful to have a number of such interfaces available, covering the main use cases.

This motivates the introduction of the ``java.util.function`` standard package that provides general-purpose definitions for:

* Unary functions (with one argument) and binary functions (with two arguments),

* Unary and binary operators (functions whose result type is identical to the type of the argument), and
  
* Unary and binary predicates (functions whose result type is Boolean).

Make sure to have a look at Java documentation about general-purpose functions: `<https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html>`_


Unary functions
---------------

The ``java.util.function.Function`` interface represents a **general-purpose function with one argument**. The type ``T`` of this argument and the result type ``R`` of the function are the generics parameters of this interface:

.. code-block:: java

    public interface Function<T,R> {
        public R apply(T t);
    }

The input type ``T`` and the result type ``R`` can be different. Together, they define the **domain** of the function. In mathematical notation, the corresponding function :math:`f` would be defined as :math:`f:T \mapsto R`.

For instance, the following program first uses a lambda expression to define a function that computes the length of a string, then applies the function to a string:

.. code-block:: java

    public static void main(String args[]) {
        Function<String, Integer> f = s -> s.length();

        // At this point, no actual computation is done: This is just a definition for "f"!
        
        System.out.println(f.apply("Hello"));  // Displays: 5
    }

As another example, here is a function that extracts the first character of a string in lower case:
    
.. code-block:: java

    Function<String, Character> f = s -> Character.toLowerCase(s.charAt(0));
    System.out.println(f.apply("Hello"));  // Displays: h

    
Binary functions
----------------

The ``java.util.function.BiFunction`` interface represents a **general-purpose functional interface with two arguments** of different types, and with a separate result type:

.. code-block:: java

    public interface BiFunction<T,U,R> {
        public R apply(T t, U u);
    }

In mathematical notation, the corresponding function :math:`f` has domain :math:`f:T \times U \mapsto R`.

In the following example, a lambda expression is used to define a binary function that returns the element of a list at a specific index:

.. code-block:: java

    BiFunction<List<Float>, Integer, Float> f = (lst, i) -> lst.get(i);
      
    List<Float> lst = Arrays.asList(10.0f, 20.0f, 30.0f, 40.0f);
    System.out.println(f.apply(lst, 1));  // Displays: 20


Operators
---------

An **operator** is a particular case of a general-purpose functional interface, in which **the arguments and the result are all of the same type**. Operators are so common that Java defines specific interfaces for unary and binary operators:

.. code-block:: java

    public interface UnaryOperator<T> {
        public T apply(T x);
    }

    public interface BinaryOperator<T> {
        public T apply(T x, T y);
    }

The mathematical domain of an unary operator :math:`f` is :math:`f: T \mapsto T`, whereas the domain of a binary operator :math:`f` is :math:`f: T \times T \mapsto T`.

As an example, the function computing the square of a double number is an unary operator that could be defined as:

.. code-block:: java

    UnaryOperator<Double> f = x -> x * x;
    System.out.println(f.apply(5.0));  // Displays: 25.0

Similarly, for the absolute value:

.. code-block:: java

    UnaryOperator<Double> f = x -> Math.abs(x);
    System.out.println(f.apply(-14.0));    // Displays: 14.0
    System.out.println(f.apply(Math.PI));  // Displays: 3.14159...

The function computing the sum of two integers can be defined as:

.. code-block:: java

    BinaryOperator<Integer> f = (x, y) -> x + y;
    System.out.println(f.apply(42, -5));  // Displays: 37

    
.. admonition:: Remark
   :class: remark

   If you look at the `Java documentation <https://docs.oracle.com/javase/8/docs/api/java/util/function/UnaryOperator.html>`_, unary and binary operators are actually defined as:

   .. code-block:: java
                   
      public interface UnaryOperator<T> extends Function<T, T> { }
      public interface BinaryOperator<T> extends BiFunction<T,T,T> { }

   This construction implies that a ``UnaryOperator`` (resp. ``BinaryOperator``) can be used as a placeholder for a ``Function`` (resp. ``BiFunction``). However, the construction is more involved, which explains why we preferred defining the operators as separate interfaces.


.. _composition:
      
Composition
-----------

In the context of general-purpose functional interfaces in Java, **composition** refers to the ability to combine multiple functions or operators to create more complex functions. It involves chaining functions together to perform a sequence of operations on data in a concise and expressive manner.

From a mathematical perspective, if we have a function :math:`f:X\mapsto Y` and a function :math:`g:Y\mapsto Z`, their `function composition <https://en.wikipedia.org/wiki/Function_composition>`_ is the function :math:`g\circ f:X\mapsto Z:x\mapsto g(f(x))`. In other words, the function :math:`g` is applied to the result of applying the function :math:`f` to :math:`x`. 

In Java, the ``Function`` interface contains the default method ``compose()`` that can be used to construct a new function that represents its composition with another function. Thanks to the fact that ``UnaryOperator`` is a special case of a ``Function``, composition is also compatible with operators.

Here is an example of composition:

.. code-block:: java
                
    UnaryOperator<Double> f = (d) -> d / 2.5;
    Function<Integer, Double> g = (i) -> Math.sqrt(i);
    Function<Integer, Double> h = f.compose(g);
    
    System.out.println(h.apply(25));  // Displays: 2.0, which corresponds to "sqrt(25) / 2.5"

In the example above, we have used the built-in ``compose()`` method that is part of Java. We could have implemented a similar functionality by ourselves thanks to the expressiveness of lambda expressions. Indeed, the following program would have produced exactly the same result as above:

.. code-block:: java
                
    public static <X,Y,Z> Function<X,Z> myCompose(Function<Y,Z> g,
                                                  Function<X,Y> f) {
        return x -> g.apply(f.apply(x));
    }

    public static void main(String[] args) {
        UnaryOperator<Double> f = (d) -> d / 2.5;
        Function<Integer, Double> g = (i) -> Math.sqrt(i);
        Function<Integer, Double> h = myCompose(f, g);
        
        System.out.println(h.apply(25));  // Display: 2.0
    }
    
Evidently, composition is also available for binary functions and binary operators.    


Predicates
----------

Predicates are another particular case of a general-purpose functional interface. They correspond to functions whose **result type is a Boolean value**. Unary predicates are frequently used to filter a collection of objects of a given type. The corresponding functional interface is defined as follows:

.. code-block:: java
                
    public interface Predicate<T> {
        public boolean test(T x);
    }

Pay attention to the fact that while the single abstract method of ``Function`` is named ``call()``, the single abstract method of ``Predicate`` is named ``test()``.

For instance, a predicate that tests whether a list is empty could be defined and used as follows:

.. code-block:: java

    Predicate<List<Integer>> f = x -> x.isEmpty();

    System.out.println(f.test(Arrays.asList()));       // Displays: true
    System.out.println(f.test(Arrays.asList(10)));     // Displays: false
    System.out.println(f.test(Arrays.asList(10, 20))); // Displays: false

Here is another example to test whether a number if negative:

.. code-block:: java

    Predicate<Double> f = x -> x < 0;

    System.out.println(f.test(-10.0)); // Displays: true
    System.out.println(f.test(10.0));  // Displays: false
                
Note that there exists a binary version of the ``Predicate<T>`` unary functional interface, that is known as ``BiPredicate<T,U>``.

In the same way functions and operators can be :ref:`composed <composition>`, the ``Predicate`` and ``BiPredicate`` interfaces contain default methods that can be used to create new predicates from existing predicates. Those methods are:

* ``and()`` to define the logical conjunction of two predicates (i.e., :math:`f \wedge g`),

* ``or()`` to define the logical disjunction of two predicates (i.e., :math:`f \vee g`), and

* ``negate()`` to define the logical negation of one predicate (i.e., :math:`\neg f`).

These operations can be used as follows:

.. code-block:: java

    Predicate<Integer> p = x -> x >= 0;
    Predicate<Integer> q = x -> x <= 10;
    Predicate<Integer> r = p.and(q);    // x >= 0 && x <= 10
    Predicate<Integer> s = p.or(q);     // x >= 0 || x <= 10 <=> true
    Predicate<Integer> t = p.negate();  // x < 0

    System.out.println(r.test(-5));  // Displays: false
    System.out.println(r.test(5));   // Displays: true
    System.out.println(r.test(15));  // Displays: false

    System.out.println(s.test(-5));  // Displays: true
    System.out.println(s.test(5));   // Displays: true
    System.out.println(s.test(15));  // Displays: true

    System.out.println(t.test(-5));  // Displays: true
    System.out.println(t.test(5));   // Displays: false
    System.out.println(t.test(15));  // Displays: false
    

Consumer
--------

Finally, a **consumer** is a general-purpose functional interface whose result type is ``Void``, i.e., that does not produce any value. It is defined as:

.. code-block:: java
                
    public interface Consumer<T> {
        public void accept(T x);
    }

Consumers are typically encountered as the "terminal block" of a chain of functions. They can notably be used to print the result of a function, to store this result into a file, or to send this result into another data structure.

For instance, the following code defines a consumer to print the result of a function:

.. code-block:: java
                
    Function<Integer, Integer> f = x -> 10 * x;
    Consumer<Integer> c = x -> System.out.println(x);

    c.accept(f.apply(5));  // Displays: 50
    
                
Higher-order functions
----------------------

In Java, **higher-order functions** are methods that can **accept other functions as arguments, return functions as results, or both**. They treat the general-purpose functions seen above as first-class citizens, allowing these functions to be manipulated, passed around, and used as data.

The ``myCompose()`` method that was introduced to :ref:`compose two functions <composition>` is an example of a higher-order function: It takes two ``Function`` as arguments, and generates one ``Function`` as its result.

Very interestingly, the standard Java collections (most notably lists) include several methods that take operators and predicates as arguments, for instance:

* ``forEach(c)`` applies a consumer to all the elements of the collection (this is part of the ``Iterable<T>`` interface),

* ``removeIf(p)`` removes all of the elements of this collection that satisfy the given predicate (this is part of the ``Collection<T>`` interface), and

* ``replaceAll(f)`` replaces each element of the collection with the result of applying the operator to that element (this is specific to the ``List<T>`` interface).

Here is a full example combining all these three methods:

.. code-block:: java
            
    // Create the following list of integers: [ -3, -2, -1, 0, 1, 2, 3 ]
    List<Integer> lst = new ArrayList<>();
    for (int i = -3; i <= 3; i++) {
        lst.add(i);
    }

    // Multiply each integer by 10
    lst.replaceAll(x -> 10 * x);  //  => [ -30, -20, -10, 0, 10, 20, 30 ]

    // Remove negative integers
    lst.removeIf(x -> x < 0);     //  => [ 0, 10, 20, 30 ]

    // Print each element in the list
    lst.forEach(x -> System.out.println(x));





Streams 
========

Programming without side effects


Immutable collections
=====================

