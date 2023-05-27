.. _part3:

*****************************************************************
Part 3: Data-Structures and Algorithms
*****************************************************************


Time Complexity
===================

In the rapidly evolving world of computer science, the efficiency of an algorithm is paramount. 
As we strive to tackle increasingly complex problems and manage growing volumes of data, 
understanding how our algorithms perform becomes more important than ever. 

This is where the concept of *time complexity* comes into play.

Time complexity provides a theoretical estimation of the time an algorithm requires to run relative to the size of the input data. 
In other words, it allows us to predict the efficiency of our code before we even run it. 
It's like having a magic crystal ball that tells us how our algorithm will behave in the wild!


Let's delve into the intricacies of time complexity and uncover the beauty and elegance of efficient code by studying first a very simple `sum` mehtod implemented next. It calculates the total sum of all the elements in an integer array provixed in argument.


..  code-block:: java
    :caption: The sum method
    :name: sum


	public class Main {
	    public static int sum(int [] values) {
	        int total = 0;
	        for (int i = 0; i < values.length; i++) {
	            total += values[i];
	        }
	        return total;
	    }
	}


One can measure the time it takes using `System.currentTimeMillis()` method
that returns the current time in milliseconds since the Unix Epoch (January 1, 1970 00:00:00 UTC). 
It is typically used to get a timestamp representing the current point in time.
Here is an example of how to use it to measure the time of one call to the `sum` method.  


..  code-block:: java
    :caption: Measuring the time of sum with currentTimeMillis
    :name: sum_time


	public class Main {
	    public static void main(String[] args) {
	        int[] values = {1, 2, 3, 4, 5};
	        long startTime = System.currentTimeMillis();
	        int totalSum = sum(values);
	        long endTime = System.currentTimeMillis()
	        long duration = (endTime - startTime);  // compute the duration in milliseconds
	    }
	}


Now, if one makes vary the size of values one can observe the evolution of execution time
in function of the size of the input array given in argument to `sum` and plot it.
Here is what we obtain a standard laptop.

.. figure:: _static/images/sum_complexity.png
   :scale: 25 %
   :alt: Sum time

   Evolution of time measures taken by `sum` on arrays of increasing size.


Undoubtedly, the absolute time is heavily reliant on the specifications of the machine the code is executed on. The same code running on a different laptop could produce different timing results. However, it's noteworthy that the time evolution appears to be linear with respect to the array size, as illustrated by the trend line. A crucial question arises: could this have been foreseen without even running the code? The answer is affirmative! :cite:t:`1965:hartmanis` layd down the foundations for such theoretical analyses from a source-code (or even pseudo-code, as the algorithm itself is of greater significance).

The Random Access Machine (RAM) model of computation
-----------------------------------------------------

The RAM, or Random Access Machine, model of computation is a theoretical model of a computer that provides a mathematical abstraction for algorithm analysis. 
In the RAM model, each 'simple' operation (such as addition, subtraction, multiplication, division, comparison, bitwise operations, following a reference, or direct addressing of memory) can be done in a single unit of time. 
It assumes that memory accesses (like accessing an element in an array: `value[i]` obove) take constant time, regardless of the memory location. 
This is where it gets the name "random access", since any memory location can be accessed in the same amount of time.

This abstraction is quite realistic for many practical purposes, and closely models real computers (a bit like Newton laws is a good approximation of general relativity).

Of course we can't assume a loop is a 'simple' operation in the RAM model. 
One need to count the number of times its body will be executed.
The next code add comments on the number of steps required to execute the sum algorithm.


..  code-block:: java
    :caption: The sum method with step annotations
    :name: sum_steps


	public class Main {
	    public static int sum(int [] values) {         // n = values.length
	        int total = 0;                             // 1 step
	        for (int i = 0; i < values.length; i++) {  
	            total += values[i];                    // 2* n steps (one memory access and one addition executed n times)
	        }
	        return total;                              // 1 step
	    }                                              // TOTAL: 2n + 2 steps
	}



In practice, it is difficult to translate one step into a concrete time since it depends on many factors (machine, language, compiler, etc).
Also, remember that it is a an approximation. In practice it not true that every operation takes exactly the same amount of time.
For this reason we will simplyfy our counting of the number of steps further by using classes of function.


The Best-Case, worst case execution of an algorithm
----------------------------------------------------------


For given input size, the performance of the number of steps required by an algorithm may strongly depend on input content.
To illustrate a simple extreme case of an algorithm exhibiting such behavior consider the `find` method looking if an array contains a specific target value and returning the first index having this value, or -1 if this value is not present in the array.


The performance of an algorithm, in terms of the number of steps it requires, can significantly vary based on the content of the input. 
In other words, different inputs of the same size may cause the algorithm to take more or fewer steps to arrive at a result.

A simple example that highlights this behavior is the 'find' method. This method aims to determine whether a specific target value is present within an array. It achieves this by iterating through the array and returning the index of the first occurrence of the target value. If the target value isn't present, it returns -1.


..  code-block:: java
    :caption: The find method 
    :name: find


    public static int find(int[] array, int target) {
        for (int i = 0; i < array.length; i++) {
            if (array[i] == target) {
                return i;
            }
        }
        return -1; // Return -1 if target is not found
    }



In this case, the number of steps the 'find' method takes to complete is heavily dependent on the position of the target value within the array. If the target value is near the beginning of the array, the 'find' method completes quickly.
We call this the best-case scenario.

Conversely, if the target value is at the end of the array or not present at all, the 'find' method must iterate through the entire array, which naturally takes more steps.
We call this, the worst-case scenario.



For certain algorithms, the number of operations required is primarily determined by the input size rather than the input content. 
This characteristic is exemplified by the 'sum' method we previously analyzed.


The Big-O, Big-Omega and Big-Theta Clases of Functions
----------------------------------------------------------


Let's assume that the number of steps an algorithm requires can be represented by the function :math:`T(n)` where :math:`n` refers to the size of the input, such as the number of elements in an array. While this function might encapsulate intricate details about the algorithm's execution, calculating it with high precision can be a substantial undertaking, and often, not worth the effort.

For sufficiently large inputs, the influence of multiplicative constants and lower-order terms within the exact runtime is overshadowed by the impact of the input size itself. This leads us to the concept of asymptotic efficiency, which is particularly concerned with how an algorithm's running time escalates with an increase in input size, especially as the size of the input grows unboundedly.

Typically, an algorithm that is asymptotically more efficient will be the superior choice for all but the smallest of inputs. 
This section introduces standard methods and notations used to simplify the asymptotic analysis of algorithms, thereby making this complex task more manageable.
We shall see asymptotic notations that are well suited to characterizing running times no matter what the input.

Those notations are sets or classes of functions.
We have classes of function asymtotically bounded by above, below or both:

* :math:`f(n)\in \mathcal{O}(g(n)) \Longleftrightarrow` :math:`\exists c \in \mathbb{R}^+,n_0 \in \mathbb{N}: f(n) \leq c\cdot g(n)\ \forall n \geq n_0` (pper bound)
* :math:`f(n)\in \Omega(g(n)) \Longleftrightarrow` :math:`\exists c \in \mathbb{R}^+,n_0 \in \mathbb{N}: f(n) \geq c\cdot g(n)\ \forall n \geq n_0` (lower bound)
*  :math:`f(n)\in \Theta(g(n)) \Longleftrightarrow`:math:`\exists c_1, c_2 \in \mathbb{R}^+,n_0 \in \mathbb{N}: c_1\cdot g(n) \leq f(n) \leq c_2\cdot g(n)\ \forall n \geq n_0` (exact bound)


What is common in the definitions of these classes of function is taht we are not concerned about small constant , we care about the big-picture that is when :math:`n` becomes really large (say 10,000 or 1,000,000). The intuition for those classes of function notations are illustrated next.

.. figure:: _static/images/bigo.png
   :scale: 25 %
   :alt: bigo


One big advantage of Big-Oh notations is the capacity to simplify  notations by only keeping the fastest growing term and taking out the numerical coefficients.
Let us consider an example of simplification: :math:`f(n)=c \cdot n^a + d\cdot n^b\quad` with :math:`a \geq b \geq 0` and :math:`c, d \geq 0`.
Then we have :math:`f(n) \in \Theta(n^a)`. 
This is even true if :math:`c` is very small and :math:`d` very big!

The simplication principle that we have applied are the following:
:math:`\mathcal{O}(c \cdot f(n)) = \mathcal{O}(f(n))` (for :math:`c>0`) and :math:`\mathcal{O}(f(n) + g(n)) \subseteq \mathcal{O}(\max(f(n), g(n))))`.
You can also use these inclusion relations to simplify:
:math:`\mathcal{O}(1) \subseteq \mathcal{O}(\log n) \subseteq \mathcal{O}(n) \subseteq \mathcal{O}(n^2) \subseteq \mathcal{O}(n^3) \subseteq \mathcal{O}(c^n) \subseteq \mathcal{O}(n!)`

As a general rule of thumb, you must simplify if possible to get rid of numerical coefficients.



Practical examples of different algorithms 
-------------------------------------------



+-------------------------------------------------+---------------------------------------------------------------+
| Complexity (name)                               | Algorithm                                                     |
+=================================================+===============================================================+
| :math:`\mathcal{O}(1)` (constant)               | Sum of two integers                                           |
+-------------------------------------------------+---------------------------------------------------------------+
| :math:`\mathcal{O}(log(n))` (logarithmic )      | Find an entry in a sorted array (dichotomic search)           |
+-------------------------------------------------+---------------------------------------------------------------+
| :math:`\mathcal{O}(n)` (linear)                 | Sum elements of an array                                      |
+-------------------------------------------------+---------------------------------------------------------------+
| :math:`\mathcal{O}(n \log n)` (linearithmic)    | Sorting efficiently an array (merge sort)                     |
+-------------------------------------------------+---------------------------------------------------------------+
| :math:`\mathcal{O}(n^2)` (quadratic)            | Sorting inefficiently an array (insertion sort)               |
+-------------------------------------------------+---------------------------------------------------------------+
| :math:`\mathcal{O}(n^3)` (cubic)                | Enumerating tripples in an array                              |
+-------------------------------------------------+---------------------------------------------------------------+
| :math:`\mathcal{O}(2^n)` (exponential)          | Finding elements in an array summing to zero (Subset-sum)     |
+-------------------------------------------------+---------------------------------------------------------------+
| :math:`\mathcal{O}(n!)` (factorial)             | Visiting all cities in a country minimizing the distance      |
+-------------------------------------------------+---------------------------------------------------------------+










Space Complexity
===================


Sorting Algorithms
===================


Insertion Sort
---------------


Bubble Sort
------------


Merge Sort
----------


Recursive Algorithms
=====================


Abstract Data Type
===================


Generics
=========

Algorithm Correctness
======================

A loop invariant is a condition or property that holds before and after each iteration of a loop. It's used as a technique for proving formally the correctness of an algorithm. The loop invariant must be true:

1. Before the loop begins (Initialization).
2. Before each iteration (Maintenance).
3. After the loop terminates (Termination). This often helps prove something important about the output.


The code fragment :ref:`bubble_loop` illustrates a simple loop invariant for the Bubble Sort algorithm. 
The loop invariant here is that after the i-th iteration of the outer loop, the largest i elements will be in their correct, final positions at the end of the array.


..  code-block:: java
    :caption: Bubble Sort with Loop Invariant
    :name: bubble_loop


	 public class Main {
	    public static void main(String[] args) {
	        int[] numbers = {5, 1, 12, -5, 16};
	        bubbleSort(numbers);
	        
	        for (int i = 0; i < numbers.length; i++) {
	            System.out.print(numbers[i] + " ");
	        }
	    }

	    public static void bubbleSort(int[] array) {
	        int n = array.length;
	        for (int i = 0; i < n-1; i++) {
	            for (int j = 0; j < n-i-1; j++) {
	                if (array[j] > array[j+1]) {
	                    // swap array[j] and array[j+1]
	                    int temp = array[j];
	                    array[j] = array[j+1];
	                    array[j+1] = temp;
	                }
	            }
	            // Here, the loop invariant is that the largest i elements 
	            // are in their correct, final positions at the end of the array.
	        }
	    }
	}


In this example, the loop invariant helps us understand why the Bubble Sort algorithm correctly sorts the array. 
After each iteration of the outer loop, the largest element is "bubbled" up to its correct position, so by the time we've gone through all the elements, the array is sorted. 
The loop invariant holds at the initialization (before the loop, no elements need to be in their final position), maintains at each iteration (after i-th iteration, the largest i elements are in their correct positions), and at termination (when the loop is finished, all elements are in their correct positions, so the array is sorted).
