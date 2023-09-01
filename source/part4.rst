.. _part4:

*****************************************************************
Part 4: Object Oriented Programming and Design Patterns
*****************************************************************


Interfaces and Abstract Classes
===============================

TODO, or did Ramin already covered it ?


Abstract Data Types (ADT)
==============================

In the context of data structures, an Abstract Data Type (ADT) is a high-level description of a collection of data and the operations that can be performed on this data. 
It specifies what operations can be done on the data, without prescribing how these operations will be implemented. 
In essence, an ADT provides a blueprint or an interface, and the actual implementation details are abstracted away.

The actual workings of the operations are hidden from the user, providing a layer of abstraction. This means that the underlying implementation of an ADT can change without affecting how users of the ADT interact with it.

Abstract Data Types are present in the Java Collections Framework. 
Let's consider the `List <https://docs.oracle.com/javase/8/docs/api/java/util/List.html>`_  interface.
This is an Abstract Data Types.
It defines an ordered collection of elements with duplicates allowed. 
List is an ADT because it specifies a set of operations (add(E e),get(int index), remove(int index), size(), etc.) that you can perform on a list without specifying how these operations are implemented.
To get a concrete implementation you must use one of the concrete classes that implement this interface, for instance `ArrayList <https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html>`_ or `LinkedList <https://docs.oracle.com/javase/8/docs/api/java/util/LinkedList.html>`_  
Whatever the one you choose the high level contract described at the interface level remain the same, although depending on the instanciation you might have different behaviors in terms of speed.


..  code-block:: java
    :caption: Example of usage of a Java List
    :name: java_list


    import java.util.LinkedList;
    import java.util.List;

    public class LinkedListExample {

        public static void main(String[] args) {
            
            List<String> fruits; // declaring a List ADT reference

            fruits = new LinkedList<>(); // Initializing it using LinkedList
            // fruits = new ArrayList<>(); This would also work using ArrayList instead

            // Adding elements
            fruits.add("Apple");
            fruits.add("Banana");
            fruits.add("Cherry");


            // Removing an element
            fruits.remove("Banana");
        }
    }


In the above example, you have seen a special notation using "<>" also called generics in java.
Generics introduce the concept of type parameters to Java, allowing you to write code that is parametrized by one or more types. 
This enables you to create generic algorithms that work on collections of different types, classes, interfaces, and methods that operate on a parameterized type.
Generics offer a way to define and enforce strong type-checks at compile-time without committing to a specific data type. 
The core idea is to allow type (classes and interfaces) to be parameters when defining classes, interfaces, and methods.


In earlier versions of Java generics did not exit.
You could add any type of objects to collections, which could lead to runtime type-casting errors. 


..  code-block:: java
    :caption: Example of ClassCastException at runtime
    :name: java_list_no_generics


    import java.util.LinkedList;
    import java.util.List;

    List list = new ArrayList();
    list.add("hello");
    list.add(1); // This is fine without generics
    String s = (String) list.get(1); // ClassCastException at runtime


With generics, the type of elements you can add is restricted at compile-time, eliminating the potential for ClassCastException at runtime.
Generics enable you to write generalized algorithms and classed based on parameterized types, making it possible to reuse the same method, class, or interface for different data types.


Stack ADT
----------

Let us now study in depth an ADT called Stack.
A stack is a collection that operates on a Last-In-First-Out (LIFO) principle. 
The primary operations are push, pop, and peek.

..  code-block:: java
    :caption: Stack ADT
    :name: stack_adt


    public interface StackADT<T> {
        // Pushes an item onto the top of this stack.
        void push(T item);
        
        // Removes and returns the top item from this stack.
        T pop();
        
        // Returns the top item from this stack without removing it.
        T peek();
        
        // Returns true if this stack is empty.
        boolean isEmpty();
    }






Implementing a Stack With Linked Structure
"""""""""""""""""""""""""""""""""""""""""""

The LinkedStack is a stack implementation that uses a linked list structure to store its elements. Each element in the stack is stored in a node, and each node has a reference to the next node. The top of the stack is maintained as a reference to the first node (head) of the linked list. 



..  code-block:: java
    :caption: Linked Stack ADT
    :name: linked_stack


    public class LinkedStack<T> implements Stack<T> {
        private Node<T> top;
        private int size;

        private static class Node<T> {
            T item;
            Node<T> next;

            Node(T item, Node<T> next) {
                this.item = item;
                this.next = next;
            }
        }

        @Override
        public void push(T item) {
            top = new Node<>(item, top);
            size++;
        }

        @Override
        public T pop() {
            if (isEmpty()) {
                throw new RuntimeException("Stack is empty");
            }
            T item = top.item;
            top = top.next;
            size--;
            return item;
        }

        @Override
        public T peek() {
            if (isEmpty()) {
                throw new RuntimeException("Stack is empty");
            }
            return top.item;
        }

        @Override
        public boolean isEmpty() {
            return top == null;
        }

        @Override
        public int size() {
            return size;
        }
    }



The state of the linked stack after pushing 1, 5 and 3 in this order is illustated on the next figure.


.. figure:: _static/images/list.png
   :scale: 100 %
   :alt: LinkedStack


Implementing a Stack With an Array
""""""""""""""""""""""""""""""""""""


Another method for implementing the Stack ADT is by utilizing an internal array to hold the elements.
An implementation is given in the next fragment.
The internal array is initialized with a size larger than the expected number of elements in the stack to prevent frequent resizing.

An integer variable, often termed top or size, represents the current position in the stack. When pushing a new element onto the stack, it's added at the position indicated by this integer. Subsequently, the integer is incremented. The pop operation reverses this process: the element at the current position is retrieved, and the integer is decremented. Both the push and pop operations have constant time complexity: :math:`O(1)`.

However, there's an inherent limitation when using arrays in Java: their size is fixed upon creation. Thus, if the stack's size grows to match the internal array's size, any further push operation risks an ArrayIndexOutOfBoundsException.

To counteract this limitation, when the internal array is detected to be full, its size is doubled. This is achieved by creating a new array with double the capacity and copying the contents of the current array to the new one. Although this resizing operation has a linear time complexity of :math:`O(n)`, where 
:math:`n` is the number of elements, it doesn't happen often.

Additionally, to avoid inefficiencies, if the size of the stack drops to one-quarter of the internal array's capacity, the array size is halved. This prevents the array from being overly sparse and consuming unnecessary memory.

Although resizing (either increasing or decreasing the size) requires :math:`O(n)`
:math:`O(n)` time in the worst case, this cost is distributed over many operations, making the average cost constant. This is known as amortized analysis. Thus, when analyzed in an amortized sense, the average cost per operation over 
:math:`n` operations is :math:`O(1)`.



..  code-block:: java
    :caption: Array Stack ADT
    :name: array_stack


    public class DynamicArrayStack<T> implements Stack<T> {
        private T[] array;
        private int top;

        @SuppressWarnings("unchecked")
        public DynamicArrayStack(int initialCapacity) {
            array = (T[]) new Object[initialCapacity];
            top = -1;
        }

        @Override
        public void push(T item) {
            if (top == array.length - 1) {
                resize(2 * array.length); // double the size
            }
            array[++top] = item;
        }

        @Override
        public T pop() {
            if (isEmpty()) {
                throw new RuntimeException("Stack is empty");
            }
            T item = array[top];
            array[top--] = null; // to prevent loitering

            // shrink the size if necessary
            if (top > 0 && top == array.length / 4) {
                resize(array.length / 2);
            }
            return item;
        }

        @Override
        public T peek() {
            if (isEmpty()) {
                throw new RuntimeException("Stack is empty");
            }
            return array[top];
        }

        @Override
        public boolean isEmpty() {
            return top == -1;
        }

        @Override
        public int size() {
            return top + 1;
        }

        @SuppressWarnings("unchecked")
        private void resize(int newCapacity) {
            T[] newArray = (T[]) new Object[newCapacity];
            for (int i = 0; i <= top; i++) {
                newArray[i] = array[i];
            }
            array = newArray;
        }
    }


Evaluating Arithmetic Expressions with a Stack
"""""""""""""""""""""""""""""""""""""""""""""""

A typical use of stacks is to evaluate arithmetic expressions as provided in the next algorithm.

..  code-block:: java
    :caption: Evaluating Expressions Using Stacks
    :name: stack_expressions


    public class ArithmeticExpression {
        public static void main(String[] args) {
            System.out.println(evaluate("( ( 2 * ( 3 + 5 ) ) / 4 )");
        }

        public static double evaluate(String expression) {

            Stack<String> ops  = new LinkedStack<String>();
            Stack<Double> vals = new LinkedStack<Double>();

            for (String s: expression.split(" ")) {
                // INVARIANT
                if      (s.equals("("))               ;
                else if (s.equals("+"))    ops.push(s);
                else if (s.equals("-"))    ops.push(s);
                else if (s.equals("*"))    ops.push(s);
                else if (s.equals("/"))    ops.push(s);
                else if (s.equals(")")) {
                    String op = ops.pop();
                    double v = vals.pop();
                    if      (op.equals("+"))    v = vals.pop() + v;
                    else if (op.equals("-"))    v = vals.pop() - v;
                    else if (op.equals("*"))    v = vals.pop() * v;
                    else if (op.equals("/"))    v = vals.pop() / v;
                    vals.push(v);
                }
                else vals.push(Double.parseDouble(s));
            }
            return vals.pop();

        }  
    }

The time complexity of the algorithm is clearly :math:`O(n)` where :math:`n` is the size of the input string:

* Each token (whether it's a number, operator, or parenthesis) in the expression is read and processed exactly once.
* Pushing and popping elements from a stack take constant time, :math:`O(1)`.
* Arithmetic operations (addition, subtraction, multiplication, and division) are performed in constant time, :math:`O(1).



To understand and convince one-self about the correctness of the algorithm, we should try to discover an invariant.
As can be seen, a fully parenthesized expression can be represented as a binary tree where the parenthesis are not necessary:


.. figure:: _static/images/expression.png
   :scale: 50 %
   :alt: Arithmetic Expression



The internal nodes are the operator and the leaf nodes are the values.
The algorithm uses two stacks. One stack (`ops`) is for operators and the other (`vals`) is for (reduced) values.
The program splits the input string args[0] by spaces to process each token of the expression individually.


We will not formalise completely the invariant here but give some intuition about what it is.

At any point during the processing of the expression:

1. The `vals` stack contains the results of all fully evaluated sub-expressions (reduced subtrees) encountered so far.
2. The `ops` stack contains operators that are awaiting their right-hand operands to form a complete sub-expression (subtree) that can be reduced.
3. For every operator in the ops stack, its corresponding left-hand operand is already in the vals stack, awaiting the completion of its subtree for reduction.

The figure displays the status of the stacks at three distinct stages for our brief example.

When we encounter an operand, it's like encountering a leaf of this tree, and we immediately know its value, so it's pushed onto the `vals` stack.

When we encounter an operator, it's pushed onto the `ops` stack. This operator is awaiting its right-hand operand to form a complete subtree. Its left-hand operand is already on the vals stack.

When a closing parenthesis `)` is encountered, it indicates the end of a fully parenthesized sub-expression, corresponding to an entire subtree of the expression. This subtree is "reduced" or "evaluated" in the following manner:

1. The operator for this subtree is popped from the ops stack.
2. The right-hand operand (the value of the right subtree) is popped from the vals stack.
3. The left-hand operand (the value of the left subtree) is popped from the vals stack.
4. The operator is applied to the two operands, and the result (the value of the entire subtree) is pushed back onto the vals stack.

This invariant captures the essence of the algorithm's approach to the problem: it traverses the expression tree in a sort of depth-first manner, evaluating each subtree as it's fully identified by its closing parenthesis.



This algorithm taking a String in input is a an example of an interpreter.
Interpreted programming languages (like Python) do similarly but accept constructs that a slightly more complex that parenthetized arithmetic expressions.



Iterators
=========

An iterator is an object that facilitates the traversal of a data structure, especially collections, in a systematic manner without exposing the underlying details of that structure. The primary purpose of an iterator is to allow a programmer to process each element of a collection, one at a time, without needing to understand the inner workings or specific layout of the collection.

Java provides an Iterator interface in the `java.util package, which is implemented by various collection classes. This allows objects of those classes to return iterator instances to traverse through the collection.

An iterator acts like a cursor pointing to some element within the collection. 
The two important methods of an iterator are:

* hasNext(): Returns true if there are more elements to iterate over.
* next(): Returns the next element in the collection and advances the iterator.

The method remove() is optional and we will not use it in this course.

The next example show how to use an interator to print every element of a list.

..  code-block:: java
    :caption: Iterator Usage Example
    :name: iterator


	import java.util.ArrayList;
	import java.util.Iterator;

	public class IteratorExample {
	    public static void main(String[] args) {
	        ArrayList<String> list = new ArrayList<>();
	        list.add("A");
	        list.add("B");
	        list.add("C");

	        Iterator<String> it = list.iterator();
	        while (it.hasNext()) {
	            String element = it.next();
	            System.out.println(element);
	        }
	    }
	}


`Iterable` should not be confused with `Iterator`.
It is also an interface in Java, found in the `java.lang package`. 
An object is "iterable" if it implements the `Iterable` interface wich has a signle method:
`Iterator<T> iterator();`.
This essentially means that the object has the capability to produce an `Iterator`.

Many data structures (like lists, sets, and queues) in the `java.util.collections` package implement the `Iterable` interface to provide a standardized method to iterate over their elements.

One of the main benefits of the Iterable interface is that it allows objects to be used with the enhanced for-each loop in Java. 
Any class that implements Iterable can be used in a for-each loop.
This is illustrated next that is equivalent to the previous code.

..  code-block:: java
    :caption: Iterator Usage Example relying on Iterable for for-loops
    :name: iterable


	import java.util.ArrayList;
	import java.util.Iterator;

	public class IteratorExample {
	    public static void main(String[] args) {
	        ArrayList<String> list = new ArrayList<>();
	        list.add("A");
	        list.add("B");
	        list.add("C");

	        for (String element: list) {
	            System.out.println(element);
	        }
	    }
	}


In conclusion, while they are closely related and often used together, `Iterable` and `Iterator` serve distinct purposes. 
`Iterable` is about the ability to produce an `Iterator`, while `Iterator` is the mechanism that actually facilitates the traversal.


Implementing your own iterators
================================

When implementing an iterator preperly, there are two possible strategies.


1. Fail-Fast: they throw ConcurrentModificationException if there is structural modification of the collection. 
2. Fail-Safe: they don’t throw any exceptions if a collection is structurally modified while iterating over it. This is because, they operate on the clone of the collection, not on the original collection and that’s why they are called fail-safe iterators.

Fail-Safe iterator may be slower since one have to pay the cost of the clone at the creation of the iterator, even if we only end-up iterating on a few elements. Therefore we will rather focus on the Fail-Fast strategy that is also the one chosen most frequently in the impleentation of Java collections.


To implement a fail-fast iterator for our `LinkedStack`, we can keep track of a "modification count" for the stack. 
This count will be incremented whenever there's a structural modification to the stack (like pushing or popping). 
The iterator will then capture this count when it's created and compare its own captured count to the stack's modification count during iteration. 
If they differ, the iterator will throw a `ConcurrentModificationException.
The `LinkedStack` class has an inner `LinkedStackIterator`class that checks the modification count every time it's asked if there's a next item or when retrieving the next item.
It is important to understand that this is a non static inner classe. An inner class cannot be instantiated without first instantiating the outer class and it is tied to a specific instance of the outer class. This is why, the instance variables of the Iterator inner class can be intialized using the instance variables of the outer class.


The sample main method demonstrates that trying to modify the stack during iteration (by pushing a new item) results in a
`ConcurrentModificationException`.

The creation of the iterator has a constant time complexity, :math:`O(1)`.


1. The iterator's current node is set to the top node of the stack. This operation is done in constant time since it's just a reference assignment.
2. Modification Count Assignment: The iterator captures the current modification count of the stack. This again is a simple assignment operation, done in constant time.

No other operations are involved in the iterator's creation, and notably, there are no loops or recursive calls that would add to the time complexity. Therefore, the total time complexity of creating the LinkedStackIterator is :math:`O(1)`.


..  code-block:: java
    :caption: Implementation of a Fail-Fast Iterator for the LinkedStack
    :name: iterator_linkedstack


	import java.util.Iterator;
	import java.util.ConcurrentModificationException;

	public class LinkedStack<T> implements Iterable<T> {
	    private Node<T> top;
	    private int size = 0;
	    private int modCount = 0;  // Modification count

	    private static class Node<T> {
	        private T item;
	        private Node<T> next;

	        Node(T item, Node<T> next) {
	            this.item = item;
	            this.next = next;
	        }
	    }

	    public void push(T item) {
	        Node<T> oldTop = top;
	        top = new Node<>(item, oldTop);
	        size++;
	        modCount++;
	    }

	    public T pop() {
	        if (top == null) throw new IllegalStateException("Stack is empty");
	        T item = top.item;
	        top = top.next;
	        size--;
	        modCount++;
	        return item;
	    }

	    public boolean isEmpty() {
	        return top == null;
	    }

	    public int size() {
	        return size;
	    }

	    @Override
	    public Iterator<T> iterator() {
	        return new LinkedStackIterator();
	    }

	    private class LinkedStackIterator implements Iterator<T> {
	        private Node<T> current = top;
	        private final int expectedModCount = modCount;

	        @Override
	        public boolean hasNext() {
	            if (expectedModCount != modCount) {
	                throw new ConcurrentModificationException();
	            }
	            return current != null;
	        }

	        @Override
	        public T next() {
	            if (expectedModCount != modCount) {
	                throw new ConcurrentModificationException();
	            }
	            if (current == null) throw new IllegalStateException("No more items to iterate over");
	            
	            T item = current.item;
	            current = current.next;
	            return item;
	        }
	    }

	    public static void main(String[] args) {
	        LinkedStack<Integer> stack = new LinkedStack<>();
	        stack.push(1);
	        stack.push(2);
	        stack.push(3);

	        Iterator<Integer> iterator = stack.iterator();
	        while (iterator.hasNext()) {
	            System.out.println(iterator.next());
	            stack.push(4);  // Will cause ConcurrentModificationException at the next call to hasNext
	        }
	    }
	}



Delegation 
===========

We consider the book class below

..  code-block:: java
    :caption: Book
    :name: book


	public class Book {
	    private String title;
	    private String author;
	    private int publicationYear;

	    public Book(String title, String author, int year) {
	        this.title = title;
	        this.author = author;
	        this.publicationYear = year;
	    }

	    // ... getters, setters, and other methods ...
	}

We aim to sort a collection of Books based on their titles in lexicographic order. 
This can be done by implementing the Comparable interface, requiring to define the compareTo method.
The compareTo method, when implemented within the Book class, leverages the inherent compareTo method of the String class.

..  code-block:: java
    :caption: Book Comparable
    :name: book_comparable

	public class Book implements Comparable<Book> {
	    final String title;
	    final String author;
	    final int publicationYear;

	    public Book(String title, String author, int year) {
	        this.title = title;
	        this.author = author;
	        this.publicationYear = year;
	    }

	    @Override
	    public int compareTo(Book other) {
	        return this.title.compareTo(other.title);
	    }

	    public static void main(String[] args) {
	        List<Book> books = new ArrayList<>();
	        books.add(new Book("The Great Gatsby", "F. Scott Fitzgerald", 1925));
	        books.add(new Book("Moby Dick", "Herman Melville", 1851));
	        books.add(new Book("1984", "George Orwell", 1949));

	        Collections.sort(books);  // Sorts the books by title due to the implemented Comparable

	        for (Book book : books) {
	            System.out.println(book.getTitle());
	        }
	    }
	}


Imagine that the books are displayed on a website, allowing visitors to browse through an extensive catalog. 
To enhance user experience, the website provides a feature to sort the books not just by their titles, but also by other attributes: the author's name or the publication year.

Now, the challenge arises: our current Book class design uses the Comparable interface to determine the natural ordering of books based solely on their titles. While this design works perfectly for sorting by title, it becomes restrictive when we want to provide multiple sorting criteria. Since the Comparable interface mandates a single compareTo method, it implies that there's only one "natural" way to sort the objects of a class. This design decision binds us to sorting by title and makes it less straightforward to introduce additional sorting methods for other attributes.


A general important principle of object-oriented design is the Open/Closed Principle (OCP): a software module (like a class or method) should be open for extension but closed for modification:

1. Open for Extension: This means that the behavior of the module can be extended or changed as the requirements of the application evolve or new functionalities are introduced.
2. Closed for Modification: Once the module is developed, it should not be modified to add new behavior or features. Any new functionality should be added by extending the module, not by making modifications to the existing code.



The delegate design pattern can help us improve our design and is a nice example of the OCP.
The delegation here occurs when the sorting algorithm (within Collections.sort) calls the compare method of the provided Comparator object. 
The responsibility of defining how two Book objects compare is delegated to the Comparator object, allowing for flexibility in sorting criteria without modifying the Book class or the sorting algorithm itself.

This delegation approach with Comparator has a clear advantage over inheritance because you can define countless sorting criteria without needing to modify or subclass the original Book class.

Here are the three Comparator classes, one for each sorting criterion:


..  code-block:: java
    :caption: Book Comparators
    :name: book_comparators

	import java.util.Comparator;

	public class TitleComparator implements Comparator<Book> {
	    @Override
	    public int compare(Book b1, Book b2) {
	        return b1.getTitle().compareTo(b2.getTitle());
	    }
	}

	public class AuthorComparator implements Comparator<Book> {
	    @Override
	    public int compare(Book b1, Book b2) {
	        return b1.getAuthor().compareTo(b2.getAuthor());
	    }
	}

	public class YearComparator implements Comparator<Book> {
	    @Override
	    public int compare(Book b1, Book b2) {
	        return Integer.compare(b1.getPublicationYear(), b2.getPublicationYear());
	    }
	}



As next example shows, we can now sort by title, author or publication year by just proding the corresponding comparator to the sorting algorithm.


..  code-block:: java
    :caption: Book Comparators
    :name: book_comparators


	import java.util.ArrayList;
	import java.util.Collections;
	import java.util.List;

	public class Main {
	    public static void main(String[] args) {
	        List<Book> books = new ArrayList<>();
	        books.add(new Book("The Great Gatsby", "F. Scott Fitzgerald", 1925));
	        books.add(new Book("Moby Dick", "Herman Melville", 1851));
	        books.add(new Book("1984", "George Orwell", 1949));

	        Collections.sort(books, new TitleComparator());  // Sort by title
	        Collections.sort(books, new AuthorComparator()); // Sort by author
	        Collections.sort(books, new YearComparator());   // Sort by publication year
	    }
	}

Exercise on Delegate pattern
""""""""""""""""""""""""""""""

You are developing a document management system. As part of the system, you have a Document class that contains content. 
You want to provide a printing capability for the Document.

Instead of embedding the printing logic directly within the Document class, you decide to use the delegate design principle. 
This will allow the Document class to delegate the responsibility of printing to another class, thus adhering to the single responsibility principle.

Complete the code below.


..  code-block:: java
    :caption: Book Comparators
    :name: book_comparators


	// The Printer interface
	interface Printer {
	    void print(String content);
	}

	// TODO: Implement the Printer interface for InkjetPrinter
	class InkjetPrinter ... {
	    ...
	}

	// TODO: Implement the Printer interface for LaserPrinter
	class LaserPrinter ... {
	    ...
	}

	// Document class
	class Document {
	    private String content;
	    private Printer printerDelegate;

	    public Document(String content) {
	        this.content = content;
	    }

	    // TODO: Set the printer delegate
	    public void setPrinterDelegate(...) {
	        ...
	    }

	    // TODO: Print the document using the delegate
	    public void printDocument() {
	        ...
	    }
	}

	// Demo
	public class DelegateDemo {
	    public static void main(String[] args) {
	        Document doc = new Document("This is a sample document content.");

	        // TODO: Set the delegate to InkjetPrinter and print
	        ...

	        // TODO: Set the delegate to LaserPrinter and print
	        ...
	    }
	}


Observer
==========

In computer science, it is considered a good practice to have a loose coupling between objects (the opposite is generally called a spagetti code).
Loose coupling allows for more modular and maintainable code.


The *Observer Pattern* is a pattern that we can use to have a loose coupling between objects.

First show how to use it in the context of GUI development (Graphical User Interface) , and then will show how to implement it.



Observer pattern on GUI components
""""""""""""""""""""""""""""""""""


In Java, the `swing` and `awt` packages facilitate the creation of Graphical User Interfaces (GUIs). 
Swing in Java uses a system based on the observer pattern to handle events like button clicks. 


On the next example we have a solitary button that, when clicked, responds with the message "Thank you" to the user.






..  code-block:: java
    :caption: Simple GUI with Action Listener
    :name: listener_gui

	import javax.swing.JButton;
	import javax.swing.JFrame;
	import javax.swing.JOptionPane;
	import java.awt.event.ActionEvent;
	import java.awt.event.ActionListener;

	class ButtonActionListener implements ActionListener {
	    @Override
	    public void actionPerformed(ActionEvent e){
	        JOptionPane.showMessageDialog(null,"Thank you!");
	    }
	}

	public class AppWithActionListener {
	    public static void main(String[] args) {
	        JFrame frame=new JFrame("Hello");
	        frame.setSize(400,200);
	        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

	        JButton button=new JButton("Press me!");
	        button.addActionListener(new ButtonActionListener());
	        frame.add(button);

	        frame.setVisible(true);
	    }
	}



The `ActionListener` is an interface within Java that contains a single method: `actionPerformed()`.
In our application, we've implemented this interface within the ButtonActionListener class. 
When invoked, it displays a dialog with the message "Thank you!" to the user. 
However, this setup remains inactive until we associate an instance of our ButtonActionListener to a button using the addActionListener method. This ensures that every time the button is pressed, the actionPerformed method of our listener gets triggered.

It's worth noting that the inner workings of how the button manages this relationship or stores the listener are abstracted away. 
What's crucial for developers to understand is the contract: the listener's method will be invoked whenever the button is clicked. 
This process is often referred to as attaching a callback to the button. 
This concept echoes a well-known programming principle sometimes dubbed the Hollywood principle: "Don't call us, we'll call you."

Although we have registered only one listener to the button, this is not a limitation.
Buttons can accommodate multiple listeners. For example, another listener might track the total number of times the button has been clicked.

This setup exemplifies the observer design pattern from the perspective of end users, using the JButton as an illustration. 
Let's now delve into how to implement this pattern for custom classes.

Implementing the Observer pattern
"""""""""""""""""""""""""""""""""

Imagine a scenario where there's a bank account that multiple people, say family members, can deposit into. Each family member possesses a smartphone and wishes to be alerted whenever a deposit occurs. For the sake of simplicity, these notifications will be printed to the console.
The complete source code is given next.



..  code-block:: java
    :caption: Implementation of the Observable Design Pattern for an Account
    :name: listener_account


	public interface AccountObserver {
	    public void accountHasChanged(int newValue);
	}


	class MyObserver implements AccountObserver {
	    @Override
	    public void accountHasChanged(int newValue) {
	        System.out.println("The account has changed. New value: "+newValue);
	    }
	}

	public class ObservableAccount {
	    private int value ;
	    private List<AccountObserver> observers = new LinkedList();

	    public void deposit(int d) {
	        value += d;
	        for (AccountObserver o: observers) {
	            o.accountHasChanged(value);
	        }
	    }

	    public void addObserver(AccountObserver o) {
	        observers.add(o);
	    }

	    public static void main(String [] args) {
	        ObservableAccount account = new ObservableAccount();
	        MyObserver observerFather = new MyObserver();
	        MyObserver observerMother = new MyObserver();
	        MyObserver observerGirl = new MyObserver();
	        MyObserver observerBoy = new MyObserver();

	        account.addObserver(observerFather);
	        account.addObserver(observerMother);
	        account.addObserver(observerGirl);
	        account.addObserver(observerBoy);

	        account.deposit(100); // we will see 4X "The account has changed. New Value: 100"
	        account.deposit(50); // we will see 4X "The account has changed. New Value: 150"
	    }
	}


In this context, our bank account is the subject being observed. 
In our code, we'll refer to it as the ObservableAccount. 
This account maintains a balance, which can be incremented through a deposit function.

We require a mechanism to register observers (note: observers and listeners can be used interchangeably) who wish to be informed about deposits. The LinkedList data structure is an excellent choice for this purpose: it offers constant-time addition and seamlessly supports iteration since it implements the Iterable interface. 
To add an AccountObserver, one would simply append it to this list. 
We've chosen not to check for duplicate observers in the list, believing that ensuring uniqueness is the user's responsibility.

Whenever a deposit occurs, the account balance is updated, and subsequently, each registered observer is notified by invoking its accountHasChangedMethod, which shares the updated balance.

It's important to note that the notification order is determined by the sequence of registration because we're using a list. However, from a user's standpoint, depending on a specific order is inadvisable. We could have just as easily used a set, which does not guarantee iteration order.



Exercise
"""""""""

In this exercise, you will use the Observer pattern in conjunction with the Java Swing framework. 
The application MessageApp provides a simple GUI where users can type a message and submit it. 
This message, once submitted, goes through a spell checker and then is meant to be displayed to observers.

Your task is to make it work as exected: when a message is submitted, it is corrected by the spell checker and it is appended in the text area of the app (use `textArea.append(String text)`).

.. figure:: _static/images/gui_exercise.png
   :scale: 100 %
   :alt: GUI Exercise


It's imperative that your design allows for seamless swapping of the spell checker without necessitating changes to the MessageApp class. Additionally, the MessageSubject class should remain decoupled from the MessageApp. 
It must not depend on it and should not even be aware that it exists.

Use the observer pattern in your design. You'll have to add instance variables and additional arguments to some existing constructors.
When possible always prefer to depend on interfaces rather than on concrete classes when declaring your parameters.
With the progress of deep-learning we anticipate that we will soon have to replace the existing StupidSpellChecker by a more advanced one.
Make this planned change as simple as possible, without having to change your classes.


..  code-block:: java
    :caption: Implementation of the Observable Design Pattern for an Account
    :name: listener_account

	import javax.swing.*;
	import java.awt.event.*;

	import java.util.ArrayList;
	import java.util.List;


	public class MessageApp {
	    private JFrame frame;
	    private JTextField textField;
	    private JTextArea textArea;
	    private JButton submitButton;

	    public MessageApp() {

	        frame = new JFrame("Observer Pattern with Swing");
	        textField = new JTextField(16);
	        textArea = new JTextArea(5, 20);
	        submitButton = new JButton("Submit");

	        frame.setLayout(new java.awt.FlowLayout());

	        frame.add(textField);
	        frame.add(submitButton);
	        frame.add(new JScrollPane(textArea));

	        // Hint: add an actionListner to the submitButon
	        // Hint: use textField.getText() to retrieve the text

	        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	        frame.pack();
	        frame.setVisible(true);
	    }

	    public static void main(String[] args) {
	        SwingUtilities.invokeLater(new Runnable() {
	            public void run() {
	                new MessageApp();
	            }
	        });
	    }
	}

	interface SpellChecker {
    	String correct(String sentence);
	}

	class StupidSpellChecker implements SpellChecker {
    	public String correct(String sentence) {
        	return sentence;
   	 	}
	}

	interface MessageObserver {
	    void updateMessage(String message);
	}


	class MessageSubject {

	    private List<MessageObserver> observers = new ArrayList<>();
	    private String message;

	    public void addObserver(MessageObserver observer) {
	        observers.add(observer);
	    }

	    public void setMessage(String message) {
	        this.message = message;
	        notifyAllObservers();
	    }

	    private void notifyAllObservers() {
	        for (MessageObserver observer : observers) {
	            observer.updateMessage(message);
	        }
	    }
	}





