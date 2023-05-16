.. _part3:

*****************************************************************
Part 3: Data-Structures and Algorithms
*****************************************************************


Time Complexity
===================

Example of an equation :math:`a^2 + b^2 = c^2`.


See :cite:t:`1965:hartmanis` for an introduction to non-standard analysis.
Non-standard analysis is fun :cite:p:`1965:hartmanis`.


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
