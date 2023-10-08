.. _part2:

*****************************************************************
Part 2: Unit testing
*****************************************************************

Software testing
================

What is software testing?
-------------------------

According to the ANSI/IEEE standard 610.12-1990, *testing*  is *"the process of operating a system or component under specified conditions, observing or recording the results and making an evaluation of some aspect of the system or component"*. More informally, testing means verifying that software (or hardware) does what we expect it to do. 

As an example, let's assume we have written a method to calculate the quotient *a/b* of two natural numbers *a* and *b*:

..  code-block:: java

    static int division(int a, int b) { ... }
    
Now, we want to know whether our implementation is correct. We can call the method with arguments 6 and 3 and maybe we get 2 as result. This seems to be correct. Then we call the method with arguments 12 and 3, and we get 4. This looks fine, too. Finally, we call the method with arguments 5 and 2 and we get 3. Is that correct? Or did we expect the result to be 2? And what should be the result if the arguments are 4 and 0?

As the above example shows, tests are only useful if we have defined what our program is supposed to do. There are different ways to specify the expected behavior of software:

1. We could write a formal specification. In our example, this is relatively easy because the method performs a simple operation. Our formal specification could be:

    .. math::

        division(a,b) = \left\{\begin{array}{cl}\lceil\frac{a}{b}\rceil & if b\neq 0\\error\  exception,& otherwise \end{array}\right.

  According to this specification (note the :math:`\lceil\cdot \rceil`), it becomes clear that the method should return 3 when called with arguments 5 and 2, and it should throw an exception if the second argument is 0. 

2. Especially for more complex programs that are difficult to describe in a formal way, the specification is often written in the form of a text document with sentences like *"The method returns the quotient of two natural numbers..."*.

3. Finally, when working with customers, we often have to start with a list of *user requirements*, i.e., a description of what is need (*"The program should calculate a/b"*), and we have to write our own specification from that.

Requirements can come in all kinds of forms. In general, we can distinguish two broad categories of requirements:

- **Functional requirements** describe **what** the final product must be able to do. Examples:

  - "The program should calculate *a/b*"
  - "The program should sort a list"
  - "The program should print the first five prime numbers"
  
- **Non-functional requirements** describe **how** the product should perform. Examples:

  - "The program should be easy to use"
  - "The program should not need more than 10 milliseconds to calculate *a/b*"
  - "The program should be secure"

What can be tested?
-------------------

Tests can be performed at different levels. Our above test of the :code:`division` method is a *unit test* because methods are the smallest entities in Java that we can independently test. We could also test an entire class or package (this is called a *module test*), several packages (*integration test*), or an entire program (*system test*). In this book, we will only do unit tests.

In general, the larger and the more complex the program you are testing, the more complicated the tests will be, and, more importantly, the more time-consuming it will be to fix a bug. A unit test can be done as soon as we write the method, and if we find a bug we can change the implementation of the method relatively easily. Imagine if we first finished writing the whole program and then, after several months of development, found during a system test that the program violates the specification! In the worst case, this could mean rewriting the whole program.

For this reason, it makes sense to start testing as early as possible in the form of unit tests. However, it should be noted that unit tests do not replace the other tests, because some errors appear only when we combine several methods or classes.


How to plan a unit test
-----------------------

We test software because we want to verify that it produces the correct results (functional requirements) in the right way (non-functional requirements). In general, software like our above :code:`division` method takes one or more input values and produces one or more result values. Unfortunately, in many cases there are many possible input values and testing our software with all of them would take a lot of time.

In practice, we can only test our software on a few input values and hope that the software also works correctly for other input values. For example, when we call our :code:`division` method with the arguments 6 and 3 and we get the correct result, we assume that the method also works correctly with the arguments 12 and 6. On the other hand, if the result for 6 and 3 is not correct, we know that our software contains a bug that we have to fix.

Does that mean that we should test our :code:`division` method with some random numbers? No, we can do something smarter than that:

1. First, we determine the *input domain* of the method, i.e., the set of possible input values. Because the method has two :code:`int` parameters, the input domain is :math:`\{-2^{31}..2^{31}-1\}\times \{-2^{31}..2^{31}-1\}`.

2. Then we split the input domain into interesting sub-domains. For example, we could decide it is interesting to test whether our method works correctly for :math:`b=0`. In that case we would obtain two sub-domains:

    - With :math:`b=0`: :math:`\{-2^{31}..2^{31}-1\}\times \{0\}`
    - With :math:`b\neq 0`: :math:`\{-2^{31}..2^{31}-1\}\times \{-2^{31}..2^{31}-1\} \backslash \{0\}`

3. Instead of testing all possible input values, we choose a few input values from each subdomain for the tests, for example :math:`a=3, b=0` for the first sub-domain, and :math:`a=6, b=3` for the second sub-domain.

This approach also works for more complex methods. Let's take the following one:

..  code-block:: java

   // returns a sorted array with the elements
   // of "a" in ascending order
   static int[] sortArray(int[] a)
   
Clearly, the input domain is very large. It contains all arrays of any length :math:`n\ge 0` containing all possible integer values. Possible sub-domains could be:

1. The empty array (:math:`n=0`)
2. Arrays with one element (:math:`n=1`)
3. Arrays containing random unsorted numbers for :math:`n>1`
4. Arrays containing numbers that have been already sorted, like :code:`{1,2,3,4}`, for :math:`n>1`
5. Arrays containing numbers that have been already sorted in descending order, like :code:`{4,3,2,1}`, for :math:`n>1`

It’s always good to have disjoint sub-domains that cover the entire input domain. Our second sub-domain already covers the case :math:`n=1`, therefore it is not necessary to cover that case again in sub-domains 3 to 5.

Test coverage
=============

Black box vs white box testing
------------------------------

Because the input domain of any non-trivial program is so large, identifying interesting input values for testing is a major challenge. If we do not have access to the source code of the program to test, we can only select the test values based on our experience and the specification. Such a test is called a *black box test* because the program that we want to test is like a opaque black box.

But if we have the source code of the program available, and that is the assumption in this book, we can use it to choose reasonable test values. This is a *white box test*.

Control Flow Graph and node coverage
------------------------------------

The following example shows an implementation of the :code:`min` function that contains a bug:

..  code-block:: java

    // returns the minimum of "a" and "b"
    static int min(int a, int b) {
        int m;
        if (a<b)
            m = a;
        else
            m = a;    // oops. That should be "m = b"
        return m;
    }
    
If we call the above method with two numbers *a* and *b* where *a<b* (for example, *a=3* and *b=5*), we get always the correct result because the statement that contains the bug is never executed. The obvious truth is that **we can only find a bug in a program if the program reaches the faulty location in the code with our test values**. The conclusion here is that our input values should be chosen such that both branches of the if-else statement are tested.

We can visualize this by the *Control Flow Graph* (CFG) of the above code:

.. image:: _static/images/part1/control_flow_min.svg
  :width: 35%

In the above control flow graph the node 0 represents the beginning of the method, the node 1 and 2 represent the two assignments in the if-else statement, and node 3 represents the :code:`return` statement of the method.

.. admonition:: \ \

    In the Control Flow Graph (CFG), the small circles (called "nodes", French "nœuds") represent the beginning of the method and the statements. The arrows between the circles (called "edges", French "arêtes") represent how the program can go from statement to statement.

If we test the code with test values *a=3* and *b=5*, the program will go through the nodes 0, 1, and 3 of the CFG. To find the bug, we have to use test values where the program goes through node 2, for example *a=5* and *b=3*. With these two tests, we have covered all nodes of the CFG. We call this *100% node coverage*.

Edge coverage
-------------

While 100% node coverage is an important goal in testing, it does not necessarily mean that a program  contains no bugs. Consider the following faulty implementation of the the :code:`min` function:

..  code-block:: java

    static int min(int a, int b) {
        int m=0;
        if (a<b) {
            m=a;
        }              // oops, we forgot the "else"
        return m;
    }

Here is the CFG of the method:

.. image:: _static/images/part1/control_flow_min2.svg
  :width: 35%

If we test this method with the test values *a=3* and *b=5*, the program will go through the nodes 0, 1, and 2, and we have achieved 100% node coverage without finding the bug! The bug only becomes visible if we use test values that force the program to go directly from node 0 to 2.

The above example shows that covering 100% of the *nodes* of the CFG with our tests is not enough. We have to choose our test values such that all all *edges* of the CFG are covered, too.

Path coverage
-------------

Unfortunately, 100% edge coverage is still not enough to find all bugs. The following example shows a method with a loop:

..  code-block:: java

    // returns the sum of the values 1 to n
    static int sum(int n) {
        int sum = 0;
        int i = 1;
        while (i<=n){
            sum = i;       // oops, this should be "sum += i"
            i++;
        }
        return sum;
    }

.. image:: _static/images/part1/control_flow_loop.svg
  :width: 50%
  
A test with *n=0* covers the edges :math:`0 \to 1` and :math:`1 \to 3` and we get the correct result 0. A test with *n=1* covers the edges :math:`0 \to 1`, :math:`1 \to 2`, :math:`2 \to 1`, and :math:`1 \to 3` and we get the correct result 1. With these two tests, we have covered all edges, but we have not found the bug.

To be sure that our program is correct, we would have to test all possible *paths* through the code:

- For *n=0*, the program takes the path :math:`0 \to 1 \to 3` through the code.
- For *n=1*, the program takes the path :math:`0 \to 1 \to 2 \to 1 \to 3` through the code.
- For *n=2*, the program takes the path :math:`0 \to 1 \to 2 \to 1 \to 2 \to 1 \to 3` through the code. In this path, the bug becomes visible.
- etc.

In practice, 100% path coverage is not feasible if a program contains loops because there are too many possible paths. In practice, we are often satisfied with 100% node coverage or 100% edge coverage.

Coverage test tools
-------------------

JaCoCo is a tool (and library) to perform coverage tests for Java programs: `<https://www.jacoco.org/jacoco/>`_. When you run a program with JaCoCo, it calculates two metrics:

- JVM bytecode instruction coverage: this is similar to node coverage, but JaCoCo counts JVM bytecode instructions, not Java statements. A statement like :code:`a=b+2` corresponds to 4 JVM bytecode instructions.

- Branch coverage: this is similar to edge coverage, but only for the edges of if-else and switch statements.

Similar tools also exist for other programming languages. They help to check whether you have enough test cases.

