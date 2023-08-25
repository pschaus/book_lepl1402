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


.. _sum:

..  code-block:: java
    :caption: The sum method
    :name: Sum Algorithm


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
    :name: Sum Algorithm with Time Measurement


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
    :name: Sum Algorithm with Step Annotations


    public static int sum(int [] values) {         // n = values.length
        int total = 0;                             // 1 step
        for (int i = 0; i < values.length; i++) {  
            total += values[i];                    // 2* n steps (one memory access and one addition executed n times)
        }
        return total;                              // 1 step
    }                                              // TOTAL: 2n + 2 steps



In practice, it is difficult to translate one step into a concrete time since it depends on many factors (machine, language, compiler, etc).
Also, remember that it is a an approximation. In practice it not true that every operation takes exactly the same amount of time.
For this reason we will simplyfy our counting of the number of steps further by using classes of function.


The Best-Case, worst case execution of an algorithm
----------------------------------------------------------


For given input size, the performance of the number of steps required by an algorithm may strongly depend on input content.
To illustrate a simple extreme case of an algorithm exhibiting such behavior consider the `find` method looking if an array contains a specific target value and returning the first index having this value, or -1 if this value is not present in the array.


The performance of an algorithm, in terms of the number of steps it requires, can significantly vary based on the content of the input. 
In other words, different inputs of the same size may cause the algorithm to take more or fewer steps to arrive at a result.

A simple example that highlights this behavior is the 'linearSearch' method. This method aims to determine whether a specific target value is present within an array. It achieves this by iterating through the array and returning the index of the first occurrence of the target value. If the target value isn't present, it returns -1.


.. _linear_search:

..  code-block:: java
    :caption: Linear Search algorithm
    :name: Linear Search Algortithm

    /**
     * This method performs a linear search on an array.
     *
     * @param arr The input array.
     * @param x   The target value to search for in the array.
     * @return The index of the target value in the array if found, or -1 if the target value is not in the array.
     */
    public static int linearSearch(int[] arr, int x) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == x) {
                return i;
            }
        }
        return -1;
    }


In this case, the number of steps the 'linearSearch' method takes to complete is heavily dependent on the position of the target value within the array. If the target value is near the beginning of the array, the 'linearSearch' method completes quickly.
We call this the best-case scenario.

Conversely, if the target value is at the end of the array or not present at all, the method must iterate through the entire array, which naturally takes more steps.
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




Recursive Algorithms
----------------------

Say something about recurence equation + Graphical Method.



Practical examples of different algorithms 
-------------------------------------------


+-------------------------------------------------+---------------------------------------------------------------+
| Complexity (name)                               | Algorithm                                                     |
+=================================================+===============================================================+
| :math:`\mathcal{O}(1)` (constant)               | Sum of two integers                                           |
+-------------------------------------------------+---------------------------------------------------------------+
| :math:`\mathcal{O}(\log n)` (logarithmic )      | Find an entry in a sorted array (binary search)               |
+-------------------------------------------------+---------------------------------------------------------------+
| :math:`\mathcal{O}(n)` (linear)                 | Sum elements or find an entry in a not sorted array           |
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



Binary Search
""""""""""""""""""""

The Binary search, also known as dichotomic search, is a search algorithm that finds the position of a target value within a sorted array. 
It works by halving the number of elements to be searched each time, which makes it incredibly efficient for large arrays.

Here's how the binary search algorithm works:

1. You start with the middle element of the sorted array.
2. If the target value is equal to this middle element, then you've found the target and the algorithm ends.
3. If the target value is less than the middle element, then you repeat the search with the left half of the array.
4. If the target value is greater than the middle element, then you repeat the search with the right half of the array.
5. You keep repeating this process until you either find the target value or exhaust all elements.


The execution of this search is illustrated on next schema searching for value 7 repeating 4 times the process until finding it.
On this array of 16 entries, the search will never require more than four trials so this is a worst-case scenario.


.. figure:: _static/images/binary_search.png
   :scale: 25 %
   :alt: binarysearch



This algorithm has a time complexity of :math:`\mathcal{O}(\log n)` because each time through the loop, the number of elements to be searched is halved and in the worst case, this process is repeated :math:`\log n` times.
On the other hand, if one is lucky, the search immediatly find the element at the first iteration. 
Therefore the best-case time complexity is :math:`Omega(1)`.

Let's take a look at how to implement binary search in Java:

.. _binary_search:

..  code-block:: java
    :caption: Binary Search Algorithm
    :name: Binary Search Algortithm


	/**
	 * This method performs a binary search on a sorted array.
	 * The array remains unchanged during the execution of the function.
	 *
	 * @param arr The input array, which must be sorted in ascending order.
	 * @param x   The target value to search for in the array.
	 * @return The index of the target value in the array if found, or -1 if the target value is not in the array.
	 */
    public static int binarySearch(int arr[], int x) {
        int left = 0, right = arr.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
  
            // Check if x is present at mid
            if (arr[mid] == x)
                return mid;
  
            // If x greater, ignore left half
            if (arr[mid] < x)
                left = mid + 1;
  
            // If x is smaller, ignore right half
            else
                right = mid - 1;
        }
  
        // If we reach here, then element was not present
        return -1;
    }


The code is a direct translation of the explanation of the algorithm.
Notice that the expression `left + (right - left) / 2` is preferred over the somewhat simpler `(left + right) / 2` to calculate the middle index in a binary search. At first glance, they seem to do the same thing, and indeed, they usually do give the same result. However, they can behave differently in certain scenarios.

The main advantage of using `left + (right - left) / 2` over `(left + right) / 2` comes into play when you are dealing with large numbers. 
The problem with `(left + right) / 2` is that the sum of `left` and `right` could exceed the maximum limit of the integer in the Java language that is is :math:`2^31-1`, causing an integer overflow, which can lead to unexpected results or errors.

On the other hand, `left + (right - left) / 2` does not have this problem. It's just as efficient, and it's safer because it avoids the risk of overflow.

Keep in mind that when dealing with objects (as opposed to primitive types), we would want to use the `equals` method instead of `==`. This is because equals tests for logical equality, meaning it checks whether two objects are logically equivalent (even if they are different instances). On the other hand, `==` tests for reference equality, which checks whether two references point to the exact same object instance. For objects where logical equality is more meaningful than reference equality, like Strings or custom objects, using `equals is the appropriate choice."



.. admonition:: Exercise
   :class: note

   What is the time complexity of next algorithm? 
   Characterize the best and worst case.



	..  code-block:: java
	    :caption: BitCount 
	    :name: Bitcount



	    /**
	     * This method counts the number of bits in the binary representation of a positive input number.
	     * It halves it until it becomes zero counting the number of iterations.
	     *
	     * @param n The input number, which must be a positive integer.
	     * @return The number of bits in the binary representation of the input number.
	     */
	    public static int bitCount(int n) {
	        int bitCount = 0;

	        while (n > 0) {
	            bitCount++;
	            n = n >> 1;  // bitwise shift to the right, which is equivalent to dividing by 2
	        }

	        return bitCount;
	    }



Linear Search
"""""""""""""""""

We already have seen the :ref:`sum` algorithm and its :math:`\Theta(n)` time complexity.

Another example of a linear time complexity algorithm is the :ref:`linear_search`.

The time complexity of the linear search algorithm is :math:`\mathcal{O}(n)`, where `n` is the size of the array, because in the worst-case scenario (the target value is not in the array or is the last element in the array), the algorithm has to examine every element in the array once.

In the best-case scenario for the linear search algorithm, the target value is the very first element of the array.
Therefore, in the best-case scenario, the time complexity of the linear search algorithm is :math:`\mathcal{O}(1)` or we can simply say that the algorithm is also in :math:`\Omega(1)`.


Merge Sort
""""""""""""""


Merge sort is a divide-and-conquer algorithm for sorting lists or arrays of items using pair-wise comparisons. 
It works by dividing the unsorted list into n sublists, each containing one element (a list of one element is considered sorted), and then repeatedly merging sublists to produce newly sorted sublists until there is only one sublist remaining.

Here's the basic idea behind merge sort:

* Divide: If the list is of length 0 or 1, then it is already sorted. Otherwise, divide the unsorted list into two sublists of about half the size.
* Conquer: Sort each sublist recursively by re-applying the merge sort.
* Combine: Merge the two sublists back into one sorted list.

Here is a simple implementation of Merge Sort in Java:


.. _merge_sort_better:

..  code-block:: java
    :caption: Merge Sort Algorithm
    :name: Merge Sort Algortithm


    private static void merge(int[] left, int [] right, int result[]) {
        assert(result.length == left.length + right.length);
        int index = 0, leftIndex = 0 , rightIndex = 0;
        while (leftIndex != left.length || rightIndex != right.length) {
            if (rightIndex == right.length || 
                (leftIndex != left.length && left[leftIndex] < right[rightIndex])) {
                result[index] = left[leftIndex];
                leftIndex++;
            }
            else {
                result[index] = right[rightIndex];
                rightIndex++;
            }
            index++;
        }
    }

    /**
     * Sort the values increasingly
     */
    public static void mergeSort(int[] values) {
        if(values.length == 1) // list of size 1, already sorted
            return;

        int mid = values.length/2;

        int[] left = new int[mid];
        int[] right = new int[values.length-mid];

        // copy values[0..mid-1] to left
        System.arraycopy(values, 0, left, 0, mid);
        // copy values[mid..values.length-1] to right
        System.arraycopy(values, mid, right, 0, values.length-mid);

        // sort left and right
        mergeSort(left);
        mergeSort(right);

        // merge left and right back into values
        merge(left, right, values);
    }


The Merge sort is a divide and conquer algorithm.
It breaks the array into two subarrays, sort them, and then merges these sorted subarrays to produce a final sorted array.
All the operations and the data-flow of execution is best undersood with a small visual example.


.. figure:: _static/images/merge_sort_complexity.png
   :scale: 25 %
   :alt: Sum time




There are :math:`\Theta(\log n)` layers of split and merge operations. 
Each requires :math:`\Theta(n)` operations by summing all the split/merge operations at one level.
In the end, the time complexity of the merge sort algorithm is the product of the time complexities of these two operations that is :math:`\Theta(n \log n)`.


Insertion Sort
"""""""""""""""""

The insertion sort algorithm is probably the one you use when sorting a hand of playing cards. 
You start with one card in your hand (the sorted portion). 
For each new card, you "insert" it in the correct position in your hand by moving over any cards that should come after it.

The Java code is given next.

.. _insertion_sort:

..  code-block:: java
    :caption: Insertion Sort Algorithm
    :name: Insertion Sort Algortithm


    /**
     * This method sort the array using Insertion Sort algorithm.
     *
     * @param arr The input array.
     */
    public static void insertionSort(int[] arr) {
        for (int i = 1; i < arr.length; i++) {
            int key = arr[i];
            int j = i - 1;
            // Move elements of arr[0..i-1], that are greater than key, 
            // to one position ahead of their current position
            while (j >= 0 && arr[j] > key) {
                arr[j + 1] = arr[j];
                j = j - 1;
            }
            arr[j + 1] = key;
        }
    }


For each element (except the first), it finds the appropriate position among the already sorted elements (all elements before the current one), and inserts it there by moving larger elements up.
Moving the larger elements up is the goal of the inner `while` loop.

The time complexity of insertion sort is :math:`\mathcal{O}(n^2)` in the worst-case scenario, because each of the `n` elements could potentially need to be compared with each of the `n` already sorted elements. 
However, in the best-case scenario (when the input array is already sorted), the time complexity is :math:`\mathcal{O}(n)`, because each element only needs to be compared once with the already sorted elements.
Or we can simply say that the insertion sort algorithm runs in :math:`\Omega(n)` and :math:`\mathcal{O}(n^2)`.





Triple Sum
"""""""""""""""""

Let's consider a simple example: an algorithm that checks for all combinations of three elements in the array that sum up to zero. 
Here's a naive implementation in Java:

.. _triple_sum:

..  code-block:: java
    :caption: Triple Sum algorithm
    :name: Trimple Sum Algortithm

    /**
     * This method checks if there are any three numbers in the array that sum up to zero.
     *
     * @param arr The input array.
     * @return True if such a triple exists, false otherwise.
     */
    public static boolean checkTripleSum(int[] arr) {
        int n = arr.length;

        for (int i = 0; i < n - 2; i++) {
            for (int j = i + 1; j < n - 1; j++) {
                for (int k = j + 1; k < n; k++) {
                    if (arr[i] + arr[j] + arr[k] == 0) {
                        return true;
                    }
                }
            }
        }

        return false;
    }


In this program, `checkTripleSum` goes through each possible combination of three elements in the input array. 
If it finds a triple that sums up to zero, it immediately returns true. If no such triple is found after checking all combinations, it returns false. Since there are :math:`n*(n-1)*(n-2)` / 6 possible combinations of three elements in an array of length :math:`n`, and we're checking each combination once, the time complexity of this method is :math:`\mathcal{O}(n^3)` and :math:`\Omega(1)`.
The best case scenerio occurs if the first three elements in the array sum to zero so that each of the loop executes only once before reaching the return instruction.



Subset-Sum
"""""""""""""""

The subset sum problem is a classic problem in computer science: given a set of integers, is there a subset of the integers that sums to zero?
This is a generalization of the `checkTripleSum` problem we have seen before.

The algorithm we will use for solving the problem is a brute-force approach that will enumerate all subsets to solve this problem.
A common approach to enumerate all the subsets is to use recursion. 
We can consider each number in the set and make a recursive call for two cases: one where we exclude the number in the subset, and one where we include it.

The Java code is given next. It calls an auxiliary method with an additional argument `sum` that is the sum of the elements
up to index `i` already included.


.. _subset_sum:

..  code-block:: java
    :caption: An algorithm for solving the Subset Sum problem
    :name: Subset Sum Algorithm

    /**
     * This method checks if there is a subset of the array that sums up to zero.
     *
     * @param arr   The input array.
     * @return True if there is such a subset, false otherwise.
     */
    public static boolean isSubsetSumZero(int[] arr) {
    	return isSubsetSum(arr, 0, 0) || ;
    }

    private static boolean isSubsetSum(int[] arr, int i, int sum) {
        // Base cases
        if (i == arr.length) { // did not find it
            return false;
        }
        if (sum + arr[i] == 0) { // found it
        	return true;
        } else {
        	// Check if sum can be obtained by excluding / including the next
        	return isSubsetSumZero(arr, i + 1, sum) || 
        	       isSubsetSumZero(arr, i + 1, sum + arr[i]);
        }
    }


The time complexity of this algorithm is :math:`\mathcal{O}(2^n)`, because in the worst case it generates all possible subsets of the array, and there are :math:`2^n` possible subsets for an array of n elements. The worst-case is obtained when there is no solution and that false is returned.
The best time complexity is :math:`\Omega(1)` obtained when the first element in the array is zero so that the algorithm immediatly returns true.

Note that this algorithm has an exponential time complexity (so far the algorithm we have studies were polynomial (e.g., :math:`\mathcal{O}(n^3)`). Therefore, although this approach will work fine for small arrays, it will be quite slow for larger ones.

There are more efficient algorithms for the subset sum problem that use dynamic programming to avoid redundant work but these are out of the scope of this introduction.


Space Complexity
===================

The space complexity of an algorithm quantifies the amount of space or memory taken by an algorithm to run as a function of the length of the input. 
It represents the amount of memory space that the algorithm needs to execute and 
includes the space taken by the input data and the additional space (usually called auxiliary space) taken by the algorithm to execute:
:math:`Space Complexity = Auxiliary Space + Input space`

The Auxiliary Space is the extra space or the temporary space used by the algorithm during it's execution.
The Input space is the space taken by the argument of the algorithm or the instance variables if any.
Notice that the extra space may also take into account the stack space in the case of a recursive algorithm.
In such a situation, when the recursive call happens, the current local variables are pushed onto the system stack, where they wait for the call the return
and unstack the local variables.
More exactly, If a function A() calls function B() (which can be A in case of recursion) inside it, then all the variables still in the scope of the function A() will get stored on the system stack temporarily, while the function B() is called and executed inside the function A().


In the :ref:`Merge Sort <merge_sort>` implementation, new arrays are created at each level of recursion.
The overall space complexity is thus of :math:`\mathcal{O}(n \log n)`, where :math:`n` is the number of elements in the input array. 
This is because, at each level of the recursion, new arrays are created, adding up to :math:`n` elements per level, and the recursion goes :math:`\log n` levels deep.


.. figure:: _static/images/stack_merge_sort.png
   :scale: 25 %
   :alt: Sum time




The time complexity required by our merge sort algorithm can be lowered to :math:`\mathcal{O}(n)` for the Auxiliary space.
We can indeed create a single temporary array of size :math:`n` once and reusing it in every merge operation. 
This temporary array requires :math:`n` units of space, which is independent of the depth of the recursion. 
As such, the space complexity of this version of the merge sort algorithm is :math:`\mathcal{O}(n)`, which is an improvement over the original version.


..  code-block:: java
    :caption: Merge Sort Algortithm with Temporary Shared Array
    :name: Merge Sort Algortithm with Temporary Shared Array


	public class MergeSort {

	    private void merge(int[] arr, int[] temp, int leftStart, int mid, int rightEnd) {
	        int leftEnd = mid;
	        int rightStart = mid + 1;
	        int size = rightEnd - leftStart + 1;

	        int left = leftStart;
	        int right = rightStart;
	        int index = leftStart;

	        while (left <= leftEnd && right <= rightEnd) {
	            if (arr[left] <= arr[right]) {
	                temp[index] = arr[left];
	                left++;
	            } else {
	                temp[index] = arr[right];
	                right++;
	            }
	            index++;
	        }

	        System.arraycopy(arr, left, temp, index, leftEnd - left + 1);
	        System.arraycopy(arr, right, temp, index, rightEnd - right + 1);
	        System.arraycopy(temp, leftStart, arr, leftStart, size);
	    }

	    public void sort(int[] arr) {
	        int[] temp = new int[arr.length];
	        sort(arr, temp, 0, arr.length - 1);
	    }

	    private void sort(int[] arr, int[] temp, int leftStart, int rightEnd) {
	        if (leftStart >= rightEnd) {
	            return;
	        }
	        int mid = leftStart + (rightEnd - leftStart) / 2;
	        sort(arr, temp, leftStart, mid);
	        sort(arr, temp, mid + 1, rightEnd);
	        merge(arr, temp, leftStart, mid, rightEnd);
	    }

	    public static void main(String[] args) {
	        MergeSort mergeSort = new MergeSort();
	        int[] arr = {38, 27, 43, 3, 9, 82, 10};
	        mergeSort.sort(arr);
	        for (int i : arr) {
	            System.out.print(i + " ");
	        }
	    }
	}


It's worth noting that in both versions of the algorithm, the time complexity remains the same: :math:`\mathcal{O}(n \log n)`. 
This is because the time complexity of merge sort is determined by the number of elements being sorted (n) and the number of levels in the recursion tree (:math:`\log n`), not by the amount of space used.

It is quite frequent to have time complexity larger than the space complexity for an algorithm but the opposite is not true, at least for the auxiliary space complexity.
The time complexity is necessarily at least the one of the auxiliary space complexity since you always need the same order as elementary steps as the one of the consumed memory.




.. admonition:: Exercise
   :class: note

   Compare the space and time complexity of the iterative and recursive computation of the factorial of a number expressed in function of :math:`n`, the value of the number for which we want to compute the factorial.



	..  code-block:: java
	    :caption: Factorial 
	    :name: Recursive



		public class Factorial {
		    public static long factorialRecur(int n) {
		        if (n == 0) {
		            return 1;
		        } else {
		            return n * factorialRecur(n - 1);
		        }
		    }
		    public static long factorialIter(int n) {
		        long result = 1;
		        for (int i = 1; i <= n; i++) {
		            result *= i;
		        }
		        return result;
		    }
		}




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


Generics
==========





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



A typical use of stacks is to evaluate arithmetic expressions as provided in the next algorithm.

..  code-block:: java
    :caption: Stack ADT
    :name: stack_adt


    public class ArithmeticExpression {
        public static void main(String[] args) {
            System.out.println(evaluate("( ( 2 * ( 3 + 5 ) ) / 4 )");
        }

        public static double evaluate(String expression) {

            Stack<String> ops  = new Stack<String>();
            Stack<Double> vals = new Stack<Double>();

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




