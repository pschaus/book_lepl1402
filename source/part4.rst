.. _part4:

********************************************************************************
Part 4: Object Oriented Programming: Data Structures and Design Patterns
********************************************************************************


.. _abstract_classes:

Abstract classes
================

An abstract class in Java is a class that cannot be instantiated on its own and is intended to be a parent class. 
Abstract classes are used when you want to provide a common base for different subclasses but do not want this base class to be instantiated on its own. 
They can contain both fully implemented (concrete) methods and abstract methods (methods without a body).


Imagine we are designing a geometric drawing program that incorporates scientific computations, such as calculating the area of various shapes. 
In this program, the formula for computing the area will be dependent on the specific shape, but there will also be common functionalities. 
For instance, each shape should have the capability to print information about itself. 
Additionally, the program is designed to allow users to define their own shapes.


Our design objective is to adhere to the crucial "Open/Closed Principle" (OCP) of object-oriented programming. 
This principle advocates that software entities (such as classes, modules, and functions) should be open for extension but closed for modification. 
This approach ensures that our program can grow and adapt over time without necessitating alterations to the existing, stable parts of the code.


Abstract classes become immensely valuable in this context. 
We can encapsulate all the common functionalities for handling the various geometric shapes into an abstract class, thereby avoiding code duplication. 
This abstract class will define methods that are common across all shapes, such as a method to print information about the shape. 
However, for specific functionalities that vary from one shape to another, such as the computation of area, we leave the method abstract.


..  code-block:: java
    :caption: Shape Abstract Class
    :name: shape_abstract

    public abstract class Shape {
        protected String shapeName; // Instance variable to hold the name of the shape

        public Shape(String name) {
            this.shapeName = name;
        }

        // Abstract method to calculate the area of the shape
        public abstract double calculateArea();

        // A concrete method implemented in the abstract class
        public void displayShapeInfo() {
            System.out.println("The " + shapeName + " has an area of: " + calculateArea());
        }
    }



With this design, introducing new shapes into the program is straightforward and does not require to change the structure of existing code. 
We simply add new subclasses for the new shapes.

..  code-block:: java
    :caption: Concrete shapes
    :name: shape_concrete

    public class Circle extends Shape {
        private double radius;

        public Circle(double radius) {
            super("Circle");
            this.radius = radius;
        }

        @Override
        public double calculateArea() {
            return Math.PI * radius * radius;
        }
    }

    public class Rectangle extends Shape {
        private double length;
        private double width;

        public Rectangle(double length, double width) {
            super("Rectangle");
            this.length = length;
            this.width = width;
        }

        @Override
        public double calculateArea() {
            return length * width;
        }
    }

    public class Triangle extends Shape {
        private double base;
        private double height;

        public Triangle(double base, double height) {
            super("Triangle");
            this.base = base;
            this.height = height;
        }

        @Override
        public double calculateArea() {
            return 0.5 * base * height;
        }
    }



To compute the total area of all shapes in an array, we can create a static method that takes an array of ``Shape`` objects as its parameter. 
This method will iterate on it, invoking the ``calculateArea()`` method on each ``Shape`` object, and accumulate the total area.
This static method remains valid even if you introduce later a new shape in your library.

..  code-block:: java
    :caption: Shape Utils
    :name: shapeutils

    class ShapeUtils {

        // Static method to compute the total area of an array of shapes
        public static double calculateTotalArea(Shape[] shapes) {
            double totalArea = 0.0;

            for (Shape shape : shapes) {
                totalArea += shape.calculateArea();
            }

            return totalArea;
        }

        public static void main(String[] args) {
            Shape[] shapes = {new Circle(5), new Rectangle(4, 5), new Triangle(3, 4)};
            double totalArea = calculateTotalArea(shapes);
            System.out.println("Total Area: " + totalArea);
        }
    }


.. _interfaces:

Interfaces
==========

An interface in Java is a class that is completely abstract. In other words, none of its methods has a concrete implementation. Interfaces are used to group related methods with empty bodies. 
Interfaces specify what a class must do, but not how it does it.

One advantage of interfaces over abstract classes is the ability of a class to implement multiple interfaces. 
Remember that Java doesn't allow to :ref:`extend multiple classes <multiple_inheritance>`.

.. TODO - Not sure to understand the end of the following sentence

Therefore interfaces promote a higher degree of flexibility and modularity in software design than abstract classes, but they don't often the same facility in terms of factorization of the code.


..  code-block:: java
    :caption: Camera and MediaPlayer interfaces
    :name: interface_camera_mediaplayer

    public interface Camera {
        void takePhoto();
        void recordVideo();
    }

    public interface MediaPlayer {
        void playAudio();
        void playVideo();
    }


..  code-block:: java
    :caption: Smartphone
    :name: smartphone

    public class Smartphone implements Camera, MediaPlayer {

        @Override
        public void takePhoto() {
            System.out.println("Taking a photo");
        }

        @Override
        public void recordVideo() {
            System.out.println("Recording video");
        }

        @Override
        public void playAudio() {
            System.out.println("Playing audio");
        }

        @Override
        public void playVideo() {
            System.out.println("Playing video");
        }
    }


Abstract Data Types (ADT)
==========================================

In the context of data collection, an Abstract Data Type (ADT) is a high-level description of a collection of data and of the operations that can be performed on this data.

An ADT can best be described by an interface in Java. This interface specifies what operations can be done on the data, but without prescribing how these operations will be implemented. 
Implementation details are abstracted away.

It means that the underlying implementation of an ADT can change without affecting how the users of the ADT interact with it.


Abstract Data Types are present in the Java Collections Framework. 
Let's consider the `List <https://docs.oracle.com/javase/8/docs/api/java/util/List.html>`_  interface that belongs to the standard ``java.util`` namespace.
This is one of the most frequently used Abstract Data Types.
It defines an ordered collection of elements, with duplicates allowed. 
``List`` is an ADT because it specifies a set of operations (e.g., ``add(E e)``, ``get(int index)``, ``remove(int index)``, ``size()``) that you can perform on a list without specifying how these operations are concretely implemented.

To get a concrete implementation of a ``List``, you must use one of the concrete classes that implement this interface, 
for instance `ArrayList <https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html>`_ or `LinkedList <https://docs.oracle.com/javase/8/docs/api/java/util/LinkedList.html>`_.
Whatever the one you choose the high level contract described at the interface level remain the same, although depending on the instanciation you might have different behaviors in terms of speed for example.

One example of the ``List`` ADT is given next.

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


In the example above, you see the special notation ``<>`` that is associated with :ref:`generics <generics>` in Java.
Generics correspond to the concept of type parameters, allowing you to write code that is parameterized by one or more types.
The core idea is to allow type (classes and interfaces) to be parameters when defining classes, interfaces, and methods.

This enables you to create generic algorithms that can work on collections of different types, classes, interfaces, and methods that operate on a parameterized type.
Generics offer a way to define and enforce strong type-checks at compile-time without committing to a specific data type. 


Java introduced support for generics in 2004, as a part of Java 5 (formally referred to as J2SE 5.0). In earlier versions of Java generics did not exit.
You could add any type of object to collections, which was prone to runtime type-casting errors, as illustrated in this example:


..  code-block:: java
    :caption: Example of ``ClassCastException`` at runtime
    :name: java_list_no_generics


    import java.util.LinkedList;
    import java.util.List;

    List list = new ArrayList();
    list.add("hello");
    list.add(1); // This is fine without generics
    String s = (String) list.get(1); // ClassCastException at runtime


With generics, the type of elements you can add is restricted at compile-time, eliminating the potential for ``ClassCastException`` at runtime. In the example above, you would have used the ``List<String>`` and ``ArrayList<String>`` parametrized classes instead of the ``List`` and ``ArrayList`` plain classes. Consequently, the call to ``list.add(1)`` would have resulted in a compilation error, because ``1`` is not a ``String``.

Generics enable you to write generalized algorithms and classes based on parameterized types, making it possible to reuse the same method, class, or interface for different data types.


Stack ADT
------------

Let us now study in-depth an ADT called ``Stack`` that is also frequently used by programmers.
A stack is a collection that operates on a Last-In-First-Out (LIFO) principle. 
The primary operations of a ``Stack`` are ``push()``, ``pop()``, and ``peek()``, as described in the next interface:

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

        // Returns the number of items in this stack.
        public int size();
    }


Let us now see some possible concrete implementations of this interface.


.. _linked_stack_adt:

Implementing a Stack With a Linked Structure
""""""""""""""""""""""""""""""""""""""""""""

The ``LinkedStack`` is an implementation of the ``Stack`` ADT that uses a linked list structure to store its elements. 
Each element in the stack is stored in a node, and each node has a reference to the next node (like individual wagons are connected in a train). 
The top of the stack is maintained as a reference to the first node (head) of the linked list.


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


The state of the linked stack after pushing 1, 5 and 3 in this order is illustrated on the next figure.


.. figure:: _static/images/list.png
   :scale: 100 %
   :alt: LinkedStack


Implementing a Stack With an Array
""""""""""""""""""""""""""""""""""""


Another method for implementing the ``Stack`` ADT is by utilizing an internal array to hold the elements.
An implementation is given in the next code fragment:


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
            array[top--] = null; // to prevent memory leak

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

The internal array is initialized with a size larger than the expected number of elements in the stack to prevent frequent resizing.

An integer variable, often termed ``top`` or ``size``, represents the current position in the stack. When pushing a new element onto the stack, it is added at the position indicated by this integer. Subsequently, the integer is incremented. The ``pop()`` operation reverses this process: The element at the current position is retrieved, and the integer is decremented. Both the ``push()`` and ``pop()`` operations have constant time complexity: :math:`O(1)`.

However, there's an inherent limitation when using arrays in Java: Their size is fixed upon creation. Thus, if the stack's size grows to match the internal array's size, any further push operation risks an ``ArrayIndexOutOfBoundsException``.

To counteract this limitation, when the internal array is detected to be full, its size is doubled. This is achieved by creating a new array whose capacity is doubled with respect to the current array, then copying the contents of the current array to the new one. Although this resizing operation has a linear time complexity of :math:`O(n)`, where 
:math:`n` is the number of elements, it doesn't happen often.

In addition, to avoid inefficiencies in terms of memory usage, if the size of the stack drops to one-quarter of the internal array's capacity, the array size is halved. This prevents the array from being overly sparse and consuming unnecessary memory.

Although resizing (either increasing or decreasing the size) requires :math:`O(n)` time in the worst case, this cost is distributed over many operations, making the average cost constant. This is known as amortized analysis. Thus, when analyzed in an amortized sense, the average cost per operation over 
:math:`n` operations is :math:`O(1)`.




Evaluating Arithmetic Expressions with a Stack
"""""""""""""""""""""""""""""""""""""""""""""""

A typical use of stacks is to evaluate arithmetic expressions, as demonstrated in the next algorithm:

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

* Each token (whether it is a number, operator, or parenthesis) in the expression is read and processed exactly once.
* Pushing and popping elements from a stack take constant time, :math:`O(1)`.
* Arithmetic operations (addition, subtraction, multiplication, and division) are performed in constant time, :math:`O(1)`.



To understand and convince one-self about the correctness of the algorithm, we should try to discover an invariant.
As can be seen, a fully parenthesized expression can be represented as a binary tree where the parenthesis are not necessary:


.. figure:: _static/images/expression.png
   :scale: 100 %
   :alt: Arithmetic Expression



The internal nodes are the operator and the leaf nodes are the values.
The algorithm uses two stacks. One stack (``ops``) is for operators and the other (``vals``) is for (reduced) values.
The program splits the input string ``args[0]`` by spaces to process each token of the expression individually.


We will not formalize completely the invariant here but give some intuition about what it is.

At any point during the processing of the expression:

1. The ``vals`` stack contains the results of all fully evaluated sub-expressions (reduced subtrees) encountered so far.
2. The ``ops`` stack contains operators that are awaiting their right-hand operands to form a complete sub-expression (subtree) that can be reduced.
3. For every operator in the ``ops`` stack, its corresponding left-hand operand is already in the ``vals`` stack, awaiting the completion of its subtree for reduction.

The figure displays the status of the stacks at three distinct stages for our brief example.

When we encounter an operand, it is like encountering a leaf of this tree, and we immediately know its value, so it is pushed onto the ``vals`` stack.

When we encounter an operator, it is pushed onto the ``ops`` stack. This operator is awaiting its right-hand operand to form a complete subtree. Its left-hand operand is already on the ``vals`` stack.

When a closing parenthesis ``)`` is encountered, it indicates the end of a fully parenthesized sub-expression, corresponding to an entire subtree of the expression. This subtree is "reduced" or "evaluated" in the following manner:

1. The operator for this subtree is popped from the ``ops`` stack.
2. The right-hand operand (the value of the right subtree) is popped from the ``vals`` stack.
3. The left-hand operand (the value of the left subtree) is popped from the ``vals`` stack.
4. The operator is applied to the two operands, and the result (the value of the entire subtree) is pushed back onto the ``vals`` stack.

This invariant captures the essence of the algorithm's approach to the problem: It traverses the expression tree in a sort of depth-first manner, evaluating each subtree as it is fully identified by its closing parenthesis.


This algorithm taking a ``String`` as its input is a an example of an interpreter.
Interpreted programming languages (like Python) do similarly but accept constructs that a slightly more complex that parenthesized arithmetic expressions.



.. admonition:: Exercise
   :class: note

   Write an recursive algorithm for evaluation arithmetic expressions. 
   This program will not use explicit stacks but rely on the call stack instead.




Trees
------------

.. TODO - Add an introduction paragraph

..  code-block:: java
    :caption: LinkedBinaryTree
    :name: linkedBinaryTree


    public class LinkedBinaryTree {

            private Node root;

            class Node {
                public int val;
                public Node left;
                public Node right;

                public Node(int val) {
                    this.val = val;
                }

                public boolean isLeaf() {
                    return this.left == null && this.right == null;
                }
            }

            public static LinkedBinaryTree leaf(int val) {
                LinkedBinaryTree tree = new LinkedBinaryTree();
                tree.root = tree.new Node(val);
                return tree;
            }

            public static LinkedBinaryTree combine(int val, LinkedBinaryTree left, LinkedBinaryTree right) {
                LinkedBinaryTree tree = new LinkedBinaryTree();
                tree.root = tree.new Node(val);
                tree.root.left = left.root;
                tree.root.right = right.root;
                return tree;
            }
    }


.. _binary-tree:

.. figure:: _static/images/binary_tree.png
   :scale: 50 %
   :alt: Binary Tree example

   BinaryTree


..  code-block:: java
    :caption: LinkedBinaryTree Construction
    :name: linkedBinaryTree_construction


    public static void main(String[] args) {
        LinkedBinaryTree tree = combine(5,
                                   combine(8,
                                           leaf(2),
                                           combine(7,
                                                   combine(6,
                                                           leaf(5),
                                                           leaf(7)),
                                                   leaf(3))),
                                   leaf(3));
    }




Tree Traversals
"""""""""""""""""""""""""""""""""""""""""""""""


Tree traversal strategies are methods used to visit all the nodes in a tree, such as a binary tree. 
The three common traversal strategies are pre-order, in-order, and post-order. 
Here's a brief explanation of each:

* Pre-order traversal visits the current node, then traverse the left subtree, and finally, traverse the right subtree.
* In-order traversal traverses the left subtree, visit the current node, and then traverse the right subtree.
* Post-order Traversal traverses the left subtree, then the right subtree, and finally visit the current node.

The code for each traversal is given next.

..  code-block:: java
    :caption: Tre Traversal
    :name: tree_traversals


        public void preOrderPrint() {
            preOrderPrint(root);
        }

        private void preOrderPrint(Node current) {
            if (current == null) {
                return;
            }
            System.out.print(current.val + " ");
            preOrderPrint(current.left);
            preOrderPrint(current.right);
        }

        public void inOrderPrint() {
            inOrderPrint(root);
        }

        private void inOrderPrint(Node current) {
            if (current == null) {
                return;
            }
            inOrderPrint(current.left);
            System.out.print(current.val + " ");
            inOrderPrint(current.right);
        }

        public void postOrderPrint() {
            postOrderPrint(root);
        }

        private void postOrderPrint(Node current) {
            if (current == null) {
                return;
            }
            postOrderPrint(current.left);
            postOrderPrint(current.right);
            System.out.print(current.val + " ");
        }


Here is the output order obtained on the binary represented :ref:`binary-tree` for each traversals:

* Pre-Order: 5, 8, 2, 7, 6, 5, 7, 3, 3
* In-Order: 2, 8, 5, 6, 7, 7, 3, 5, 3
* Post-Order: 2, 5, 7, 6, 3, 7, 8, 3, 5

Visiting a binary tree with ``n`` nodes takes :math:`\Theta(n)` (assuming the visit of one node takes a constant time),
since each node is visited exactly once.



.. admonition:: Exercise
   :class: note
   
   Write an iterative algorithm (not recursive) for implementing each of these traversals.
   You will need to use an explicit stack.



We show next two practical examples using binary trees data-structures.


.. _arithmetic_expression:

Representing an arithmetic Expression with Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""

.. NOTE:

   "Terminology: Nested classes are divided into two categories:
   non-static and static. Non-static nested classes are called inner
   classes. Nested classes that are declared static are called static
   nested classes."

   From the official Oracle tutorial on Java:
   https://docs.oracle.com/javase/tutorial/java/javaOO/nested.html

   In this section, "OperatorExpressionTree" are
   "ValueExpressionTree", are static nested classes. So SJO replaced
   "inner class" by "static nested class" for uniformity with part 6.


The ``BinaryExpressionTree`` class in the provided code is an abstract representation of a binary expression tree, 
a data structure commonly used in computer science for representing expressions with binary operators (like ``+, -, *, /``).

The set of expression methods (``mul()``, ``div()``, ``plus()``, ``minus()``) allows to build easily expressions from other expressions.
These methods return a new ``OperatorExpressionTree`` object, which is a subclass of ``BinaryExpressionTree``. 
Each method takes another ``BinaryExpressionTree`` as an operand to the right of the operator.
The private static nested class ``OperatorExpressionTree`` represents an operator node in the tree with left and right children, which are also BinaryExpressionTree instances.
The private static nested class ``ValueExpressionTree``  represents a leaf node in the tree that contains a value.
A convenience static method ``value()`` allows creating a ``ValueExpressionTree`` with a given integer value.
An example is provided in the main method for creating tree representation of the expression ``(2 * ((5+7)-3)) / 3``.


..  code-block:: java
    :caption: BinaryExpressionTree
    :name: expressionTree


    public abstract class BinaryExpressionTree {


        public BinaryExpressionTree mul(BinaryExpressionTree right) {
            return new OperatorExpressionTree(this, right, '*');
        }

        public BinaryExpressionTree div(BinaryExpressionTree right) {
            return new OperatorExpressionTree(this, right, '/');
        }

        public BinaryExpressionTree plus(BinaryExpressionTree right) {
            return new OperatorExpressionTree(this, right, '+');
        }

        public BinaryExpressionTree minus(BinaryExpressionTree right) {
            return new OperatorExpressionTree(this, right, '-');
        }

        private static class OperatorExpressionTree extends BinaryExpressionTree {
            private final BinaryExpressionTree left;
            private final BinaryExpressionTree right;
            private final char operator;

            public OperatorExpressionTree(BinaryExpressionTree left, BinaryExpressionTree right, char operator) {
                this.left = left;
                this.right = right;
                this.operator = operator;
            }

        }

        private static class ValueExpressionTree extends BinaryExpressionTree {

            private final int value;

            public ValueExpressionTree(int value) {
                this.value = value;
            }
        }

        public static BinaryExpressionTree value(int value) {
            return new ValueExpressionTree(value);
        }

        public static void main(String[] args) {
            BinaryExpressionTree expr = value(2).mul(value(5).plus(value(7)).minus(value(3)).div(value(3))); // (2 * ((5+7)-3)) / 3
        }

    }





We now enrich this class with two functionalities:

* ``evaluate()`` is a method for evaluating the expression represented by the tree. This method performs a post-order traversal of the tree. The evaluation of the left sub-expression (left traversal) and the right subexpression (right traversal) must be first evaluated prior to applying the node operator (visit of the node).
* ``prettyPrint()`` is a method for printing the expression as full parenthesized representation. It corresponds to an infix traversal. The left subexpression is printed (left traversal) before printing the node operator (visit of the node) and then printing the right subexpression (right traversal).


..  code-block:: java
    :caption: BinaryExpressionTree (Continued)
    :name: expressionTree_enriched


    public abstract class BinaryExpressionTree {

        // evaluate the expression
        abstract int evaluate(); 

        // print a fully parenthesized representation of the expression
        abstract String prettyPrint();

        // mul , div, plus, minus not represented


        private static class OperatorExpressionTree extends BinaryExpressionTree {
            private final BinaryExpressionTree left;
            private final BinaryExpressionTree right;
            private final char operator;

            // constructor not represented

            @Override
            public String prettyPrint() {
                return "(" + left.prettyPrint() + operator + right.prettyPrint() + ")";
            }

            @Override
            int evaluate() {
                int leftRes = left.evaluate();
                int rightRes = right.evaluate();
                switch (operator) {
                    case '+':
                        return leftRes + rightRes;
                    case '-':
                        return leftRes - rightRes;
                    case '/':
                        return leftRes / rightRes;
                    case '*':
                        return leftRes * rightRes;
                    default:
                        throw new IllegalArgumentException("unkown operator " + operator);
                }
            }
        }

        private static class ValueExpressionTree extends BinaryExpressionTree {

            private final int value;

            // constructor not represented

            @Override
            public String prettyPrint() {
                return value + "";
            }

            @Override
            int evaluate() {
                return value;
            }
        }
    }



.. admonition:: Exercise
   :class: note
   
   Enrich the BinaryExpressionTree with a method ``rpnPrint()`` to print the expression in *reverse Polish notation*.
   In reverse Polish notation, the operators follow their operands. For example, to add 3 and 4 together, the expression is ``3 4 +`` rather than ``3 + 4``.
   This notation doesn't need parenthesis: ``(3 × 4) + (5 × 6)`` becomes ``3 4 × 5 6 × +`` in reverse Polish notation.




Representing a set with a tree
"""""""""""""""""""""""""""""""""""""""""""""""

.. TODO - Add an explanation paragraph


..  code-block:: java
    :caption: BinarySearchTree
    :name: binary_search_tree


    public class BinarySearchTree implements IntSet {

        private Node root;

        private class Node {
            public int val;
            public Node left;
            public Node right;

            public Node(int val) {
                this.val = val;
            }

            public boolean isLeaf() {
                return this.left == null && this.right == null;
            }
        }

        // Method to add a value to the tree
        public void add(int val) {
            root = addRecursive(root, val);
        }

        private Node addRecursive(Node current, int val) {
            if (current == null) {
                return new Node(val);
            }
            if (val < current.val) {
                current.left = addRecursive(current.left, val);
            } else if (val > current.val) {
                current.right = addRecursive(current.right, val);
            } // if val equals current.val, the value already exists, do nothing

            return current;
        }

        // Method to check if the tree contains a specific value
        public boolean contains(int val) {
            return containsRecursive(root, val);
        }

        private boolean containsRecursive(Node current, int val) {
            if (current == null) {
                return false;
            }
            if (val == current.val) {
                return true;
            }
            return val < current.val
                    ? containsRecursive(current.left, val)
                    : containsRecursive(current.right, val);
        }

        // Main method for testing
        public static void main(String[] args) {
            BinarySearchTree bst = new BinarySearchTree();
            bst.add(5);
            bst.add(3);
            bst.add(7);
            bst.add(1);

            System.out.println("Contains 3: " + bst.contains(3)); // true
            System.out.println("Contains 6: " + bst.contains(6)); // false
        }
    }



.. _iterators:

Iterators
===========

An iterator is an object that facilitates the traversal of a data structure, especially collections, in a systematic manner without exposing the underlying details of that structure. The primary purpose of an iterator is to allow a programmer to process each element of a collection, one at a time, without needing to understand the inner workings or the specific memory layout of the collection.

Java provides an ``Iterator`` interface in the ``java.util`` package, which is implemented by various collection classes. This allows objects of those classes to create iterator instances on demand that can be used to traverse through the collection.

An iterator acts like a cursor pointing to some element within the collection. 
The two important methods of an iterator are:

* ``hasNext()``: Returns ``true`` if and only if there are more elements to iterate over.
* ``next()``: Returns the next element in the collection and advances the iterator. This method fails if ``hasNext()`` is ``false``.

The method ``remove()`` is optional and will not be covered in this course.

The next example show how to use an iterator to print every element of a list.

..  code-block:: java
    :caption: ``Iterator`` Usage Example
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


``Iterable`` should not be confused with ``Iterator``.
It is also an interface in Java, found in the ``java.lang package``. 
An object is "iterable" if it implements the ``Iterable`` interface which has a single method:
``Iterator<T> iterator();``.
This essentially means that the object has the capability to provide an ``Iterator`` over itself.

Many data structures (like lists, sets, and queues) in the ``java.util.collections`` package implement the ``Iterable`` interface to provide a standardized method to iterate over their elements.

One of the main benefits of the ``Iterable`` interface is that it allows objects to be used with the :ref:`enhanced for-each loop <simple_for_loops>` in Java. 
Any class that implements ``Iterable`` can be used in a for-each loop.
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


In conclusion, while they are closely related and often used together, ``Iterable`` and ``Iterator`` serve distinct purposes. 
``Iterable`` is about the ability to produce an ``Iterator``, while ``Iterator`` is the mechanism that actually facilitates the traversal.


.. _custom_iterators:

Implementing your own iterators
---------------------------------

To properly implement an ``Iterator``, there are two possible strategies:

1. Fail-Fast: Such iterators throw ``ConcurrentModificationException`` if there is structural modification of the collection. 
2. Fail-Safe: Such iterators don't throw any exceptions if a collection is structurally modified while iterating over it. This is because they operate on the clone of the collection, not on the original collection.

Fail-Safe iterator may be slower since one have to pay the cost of the clone at the creation of the iterator, even if we only end-up iterating over few elements. Therefore we will rather focus on the Fail-Fast strategy, which corresponds to the most frequent choice in the implementation of Java collections.


To implement a Fail-Fast iterator for our ``LinkedStack``, we can keep track of a modification count for the stack. 
This count will be incremented whenever there's a structural modification to the stack (like pushing or popping). 
The iterator will then capture this count when it is created and compare its own captured count to the stack's modification count during iteration. 
If they differ, the iterator will throw a ``ConcurrentModificationException``.
The ``LinkedStack`` class has an inner ``LinkedStackIterator`` class that checks the modification count every time it is asked if there's a next item or when retrieving the next item.
It is important to understand that ``LinkedStackIterator`` is an inner class, *not* a static nested class. An inner class cannot be instantiated without first instantiating the outer class and it is tied to a specific instance of the outer class. This is why, the instance variables of the ``Iterator`` inner class can be initialized using the instance variables of the outer class.


The sample main method demonstrates that trying to modify the stack during iteration (by pushing a new item) results in a
``ConcurrentModificationException``.

The creation of the iterator has a constant time complexity, :math:`O(1)`. Indeed:


1. The iterator's current node is set to the top node of the stack. This operation is done in constant time since it is just a reference assignment.
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
	            if (current == null) throw new IllegalStateException("No more items");
	            
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


.. _delegation_comparator:

Delegation 
===========

Let us consider the ``Book`` class below:

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

We aim to sort a collection of ``Book`` objects based on their titles in lexicographic order. 
This can be done by implementing the ``Comparable`` interface that requires to define the ``compareTo()`` method.
The ``compareTo()`` method, when implemented within the ``Book`` class, leverages the inherent ``compareTo()`` method of the ``String`` class.

..  code-block:: java
    :caption: Book Comparable
    :name: book_comparable

    import java.util.ArrayList;
    import java.util.Collections;
    import java.util.List;

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

	        Collections.sort(books);  // Sorts by title due to the implemented Comparable

	        for (Book book : books) {
	            System.out.println(book.getTitle());
	        }
	    }
	}


Imagine that the books are displayed on a website, allowing visitors to browse through an extensive catalog. 
To enhance user experience, the website provides a feature to sort the books not just by their titles, but also by other attributes: the author's name or the publication year.

Now, the challenge arises: Our current ``Book`` class design uses the ``Comparable`` interface to determine the natural ordering of books based solely on their titles. While this design works perfectly for sorting by title, it becomes restrictive when we want to provide multiple sorting criteria (for instance, sorting by author or publication year). Since the ``Comparable`` interface mandates a single ``compareTo()`` method, it implies that there's only one "natural" way to sort the objects of a class. This design decision binds us to sorting by title and makes it less straightforward to introduce additional sorting methods for other attributes.


A general important principle of object-oriented design is the :ref:`Open/Closed Principle (OCP) <abstract_classes>`: A software module (like a class or method) should be open for extension but closed for modification:

1. Open for Extension: This means that the behavior of the module can be extended or changed as the requirements of the application evolve or new functionalities are introduced.
2. Closed for Modification: Once the module is developed, it should not be modified to add new behavior or features. Any new functionality should be added by extending the module, not by making modifications to the existing code.



The so-called *Delegate Design Pattern* can help us improve our design and is a nice example of the OCP.
In the example of ``Book``, delegation occurs when the sorting algorithm (within ``Collections.sort()``) calls the ``compare()`` method of the provided ``Comparator`` object. 
The responsibility of defining how two ``Book`` objects compare is delegated to the ``Comparator`` object, allowing for flexibility in sorting criteria without modifying the ``Book`` class or the sorting algorithm itself.

This delegation approach with ``Comparator`` has a clear advantage over inheritance because you can define countless sorting criteria without needing to modify or subclass the original ``Book`` class.

Here are the three ``Comparator`` classes, one for each sorting criterion:


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



As next example shows, we can now sort by title, author or publication year by just providing the corresponding comparator to the sorting algorithm.


..  code-block:: java
    :caption: Book Comparators Example
    :name: book_comparators_example


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



.. admonition:: Exercise
   :class: note


    You are developing a document management system. As part of the system, you have a ``Document`` class that contains content. 
    You want to provide a printing capability for the ``Document``.

    Instead of embedding the printing logic directly within the ``Document`` class, you decide to use the delegate design pattern. 
    This will allow the ``Document`` class to delegate the responsibility of printing to another class, thus adhering to the single responsibility principle.

    Complete the code below.


    ..  code-block:: java
        :caption: Printers
        :name: printers


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

In computer science, it is considered as a good practice to have a loose coupling between objects (the opposite is generally referred to as a "spaghetti code").
Loose coupling allows for more modular and maintainable code.


The *Observer Design Pattern* is a pattern that we can use to have a loose coupling between objects.

We will first show how to use observers in the context of GUI development (Graphical User Interface), then will show how to implement observers.


.. _awt_swing:

Observer pattern on GUI components
------------------------------------


In Java, the ``swing`` and ``awt`` packages facilitate the creation of Graphical User Interfaces (GUIs). 
Swing in Java uses a system based on the observer pattern to handle events, such as mouse clicks. 


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
	    public void actionPerformed(ActionEvent e) {
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



The ``ActionListener`` is an interface within Java that contains a single method: ``actionPerformed()``.
In our application, this interface is implemented by the ``ButtonActionListener`` concrete class. 
When invoked, it displays a dialog with the message "Thank you!" to the user. 
However, this setup remains inactive until we associate an instance of our ``ButtonActionListener`` to a button using the ``addActionListener()`` method. This ensures that every time the button is pressed, the ``actionPerformed()`` method of our listener gets triggered.

It is worth noting that the inner workings of how the button manages this relationship or stores the listener are abstracted away. 
What is crucial for developers to understand is the contract: The listener's method will be invoked whenever the button is clicked. 
This process is often referred to as "attaching a callback" to the button, or as "registering an event handler" to the button.
This concept echoes a well-known programming principle sometimes dubbed the Hollywood principle: "Don't call us, we will call you."

Although we have registered only one listener to the button, this is not a limitation.
Buttons can accommodate multiple listeners. For example, a second listener could be added to track the total number of times the button has been clicked.

This setup exemplifies the observer design pattern from the perspective of end users, using the JButton as an illustration. 
Let's now delve into how to implement this pattern for custom classes.

Implementing the Observer pattern
------------------------------------

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

	        account.deposit(100); // prints 4X "The account has changed. New Value: 100"
	        account.deposit(50);  // prints 4X "The account has changed. New Value: 150"
	    }
	}


In this context, our bank account is the subject being observed. 
In our code, this will be modeled by the ``ObservableAccount`` class. 
This account maintains a balance, which can be incremented through a deposit function.

We require a mechanism to register observers (note: the wordings "observer" and "listener" are synonyms that can be used interchangeably) who wish to be informed about deposits. The ``LinkedList`` data structure is an excellent choice for this purpose: It offers constant-time addition and seamlessly supports iterators since it implements the ``Iterable`` interface. 
To add an ``AccountObserver``, one would simply append it to this list. 
We have chosen not to check for duplicate observers in the list, believing that ensuring uniqueness is the user's responsibility.

Whenever a deposit occurs, the account balance is updated, and subsequently, each registered observer is notified by invoking its ``accountHasChangedMethod()``, which shares the updated balance.

It is important to note that in this specific implementation, the order of notification is determined by the sequence of registrations because we are using a list. However, from a user's standpoint, the caller should never make the hypothesis that this order is always used. Indeed, one could replace the ``LinkedList`` by another collection, for instance a set, which would not guarantee the same order while iterating over the observers.



.. admonition:: Exercise
   :class: note


    In this exercise, you will use the Observer pattern in conjunction with the Java Swing framework. 
    The application ``MessageApp`` provides a simple GUI (Graphical User Interface) where users can type a message and submit it. 
    This message, once submitted, goes through a spell checker and then is meant to be displayed to observers.

    Your task is to make it work as expected: when a message is submitted, it is corrected by the spell checker and it is appended in the text area of the app (use ``textArea.append(String text)``).

    .. figure:: _static/images/gui_exercise.png
       :scale: 100 %
       :alt: GUI Exercise


    It is imperative that your design allows for seamless swapping of the spell checker without necessitating changes to the ``MessageApp`` class. Additionally, the ``MessageSubject`` class should remain decoupled from the ``MessageApp``. 
    It must not depend on it and should not even be aware that it exists.

    Use the observer pattern in your design. You'll have to add instance variables and additional arguments to some existing constructors.
    When possible, always prefer to depend on interfaces rather than on concrete classes when declaring your parameters.
    With the advances of Deep Learning, we anticipate that we will soon have to replace the existing ``StupidSpellChecker`` by a more advanced one.
    Make this planned change as simple as possible, without having to change your classes.


    ..  code-block:: java
        :caption: Implementation of GUI MessageApp
        :name: message_app

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





