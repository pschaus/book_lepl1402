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
   :scale: 100 %
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


Implementing our own iterators
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


Observer 
==========




