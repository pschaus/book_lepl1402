.. _part5:


*****************************************************************
Part 5: Parallel Programming
*****************************************************************

Parallel programming is a computing technique where multiple tasks are executed simultaneously to achieve faster execution times and to improve resource utilization compared to sequential execution.

Parallel programming involves **breaking down a task into smaller sub-tasks that can be executed independently and concurrently** across multiple processing units, such as CPUs (central processing units), GPUs (graphics processing units), or distributed computing resources.

Parallel programming is often introduced as a way to optimally take advantage of the multiple computing units that are embedded in modern computers, in order to **speed up some computation that takes a lot time**.

However, besides this exploitation of multiple computing units to speed up computations, parallel programming also enables the design of **responsive user interfaces**. Indeed, most GUI (graphical user interface) frameworks are built on the top of a "main event loop" that continuously monitors user interactions and that calls application code to react to those events. If the application code takes too much time to run, the user interface appears to "freeze." Parallel programming allows to run this applicative logic in the background, hereby preserving an optimal user experience.

This concept of "main event loop" can also be encountered in **network applications**, where a software must serve requests issued by different clients. Thanks to parallel programming, each connection with a client can be handled in the background, leaving the main server listen to new connections.

Finally, it may also happen that the design of a whole software can be more naturally modeled using parallel programming than using sequential programming. Think about your personal week agenda: You have a number of distinct tasks of different natures to be achieved during the week, and those tasks only have loose dependencies between them. A large-scale software is likewise: It can generally be **decomposed into a set of mostly uncoupled tasks**, where each of the individual tasks has a different objective and can be solved using sequential programming. Sequential programming has indeed the advantage of being easier to write, to :ref:`test <software_testing>`, and to correct. Nevertheless, developing the whole software using sequential programming would introduce unnecessary, arbitrary dependencies between the individual tasks, hereby reducing the performance and increasing the complexity of the design.


GPUs vs. CPUs
=============

In recent years, there is a growing interest in the exploitation of GPUs to carry on computations that are not related to computer graphics. Indeed, **GPUs** consist of a massive number of processing units working in parallel that are highly optimized for certain types of computations, especially those involving heavy numerical calculations, matrix operations, simulations, graphics rendering, and deep learning.

However, while GPUs are incredibly powerful for certain types of parallel computations, they are not a universal replacement for CPUs. Indeed, CPUs are much more versatile, as they are designed to handle a wide range of tasks, including general-purpose computing, running operating systems, managing I/O operations, executing single-threaded applications, and handling diverse workloads. In contrast, the processing units of GPUs focus on simpler tasks that can be duplicated a large number of times in an identical way. Furthermore, certain types of tasks, particularly those with sequential dependencies or requiring frequent access to shared data, might not benefit significantly from GPU acceleration. Finally, writing code for GPUs often requires the usage of specialized programming languages or libraries and the understanding of the underlying hardware architecture.

Consequently, in this course, we will only focus on **parallel programming on CPU**. It is indeed essential to notice that thanks to hardware evolution, any consumer computer is nowadays equipped with multiple CPU cores (even if they are less numerous than processing units inside a GPU), as depicted on the following picture:

.. image:: _static/images/part5/gpu-vs-cpu.svg
  :width: 75%
  :align: center
  :alt: GPU vs. CPU

Parallel programming on CPU seeks to leverage the multiple CPU cores available inside a single computer to execute multiple tasks or portions of a single task simultaneously.


Multiprocessing vs. multithreading
==================================

In computing, a **process** corresponds to a program that is actively running on the CPU of a computer, along with its current state. A typical operating system allows multiple independent processes to run concurrently on the available CPU cores, hereby providing an environment to achieve parallelism that is referred to as **multiprocessing**.

A process has its own memory space (including code, data, stack, and CPU registers) and its own resources that are isolated from other processes to prevent unauthorized access and interference. Distinct processes may still communicate with each other through the so-called **"interprocess communication" (IPC)** mechanisms provided by the operating system, such as files, pipes, message passing, shared memory, or network communications (sockets).

Multiprocessing has two main downsides. Firstly, creating new processes incurs a high overhead due to the need for separate memory allocation and setup for each process. Secondly, because different processes are isolated from each other, interprocess communications are relatively complex and come at a non-negligible cost.

This motivates the introduction of the concept of a **thread**. A thread refers to the smallest unit of execution within a process. A thread corresponds to a sequence of instructions that can be scheduled and executed independently by one CPU core. One single process can run multiple threads, as illustrated below:

.. image:: _static/images/part5/threads.svg
  :width: 50%
  :align: center
  :alt: Multithreading

In this picture, the blue blocks indicate at which moment the different threads are active (i.e., are executing something). A thread can indeed "fall asleep" while waiting for additional data to process, while waiting for user interaction, or while waiting for the result of a computation done by another thread.

Accordingly, **multithreading** is a programming technique where a single process is divided into multiple threads of execution. Threads can perform different operations concurrently, such as handling different parts of an application (e.g., keeping the user interface responsive while performing a background computation).

Importantly, contrarily to processes, **threads within the same process are not isolated**: They share the same memory space and resources, which allows distinct threads to directly access the same variables and data structures. Threads are sometimes called *lightweight processes*, because creating threads within a process incurs less overhead compared to creating multiple processes.

Summarizing, multithreading tends to be simpler and more lightweight than multiprocessing. This explains why this course will only cover the **basics of multithreading in Java**.

It is always worth remembering that the fact that different threads do not live in isolation can be error-prone. Multithreading notably requires the introduction of suitable synchronization and coordination mechanisms between threads when accessing shared variables. If not properly implemented, **race conditions, deadlocks, and synchronization issues can emerge**, which can be extremely hard to identify and resolve.

Also, note that all programmers are constantly confronted with threads. Indeed, even if you never explicitly create a thread by yourself, the vast majority of software frameworks (such as GUI frameworks and a software libraries to deal with network programming or scientific computations) will create threads on your behalf. For instance, in the context of Java-based GUI, both the :ref:`AWT (Abstract Window Toolkit) <awt>` and the Swing framework will transparently create threads to handle the interactions with the user. Consequently, parallel programming should never be considered as an "advanced feature" of a programming language, because almost any software development has to deal with threads. In other words, even if you do not create your own threads, it is important to understand how to design thread-safe applications that properly coordinate the accesses to the shared memory space.


Threads in Java
===============

Java provides extensive support of multithreading.

When a Java program starts its execution, the Java Virtual Machine (JVM) starts an initial thread. This initial thread is called the **main thread** and is responsible for the execution of the ``main()`` method, which is the :ref:`entry point of most Java applications <java_main>`. Alongside the main thread, the JVM can also start background threads for its own housekeeping (most notably the garbage collector).

Additional threads can then be created by software developers in two different ways:

* By :ref:`extending <inheritance>` the standard class ``Thread``. Note that since ``Thread`` belongs to the ``java.lang`` package, no ``import`` directive is needed. Here is the documentation of the ``Thread`` class: `<https://docs.oracle.com/javase/8/docs/api/java/lang/Thread.html>`_ 

* By :ref:`implementing <interfaces>` the standard interface ``Runnable`` that is also of the ``java.lang`` package: `<https://docs.oracle.com/javase/8/docs/api/java/lang/Runnable.html>`_ 

In this course, we will use the second approach. The ``Runnable`` interface is quite intuitive:

..  code-block:: java

    public interface Runnable {
        public void run();
    }

This snippet indicates that to create a thread, we first have to define a class providing a ``run()`` method that will take care of the computations. Once a concrete class implementing this ``Runnable`` interface is available, it can be executed as a thread by instantiating the ``Thread`` class.


Using a thread to compute the minimum
-------------------------------------

As an illustration, let us consider the task of computing the minimum value of an array of floating-point numbers. It is straightforward to implement a sequential method to do this computation:

..  code-block:: java

    static void computeMinValue(float values[]) {
        if (values.length == 0) {
            System.out.println("This is an empty array");
        } else {
            float minValue = values[0];
            for (int i = 1; i < values.length; i++) {
                if (values[i] < minValue) {
                    minValue = values[i];
                }
            }
            System.out.println("Minimum value: " + minValue);
        }
    }

As explained above, if one wishes to run this computation as a background thread, the ``computeMinValue()`` method must wrapped inside some implementation of the ``Runnable`` interface. But the ``run()`` method of the ``Runnable`` interface does not accept any parameter, so we cannot directly give the ``values`` array as an argument to ``run()``. The trick is to store a reference to the ``values`` array inside a class that implements ``Runnable``:

..  code-block:: java

   static class MinComputation implements Runnable {
        private float values[];

        public MinComputation(float values[]) {
            this.values = values;
        }

        @Override
        public void run() {
            computeMinValue(values);
        }
    }

Our ``MinComputation`` class specifies how to compute the minimum of an array. We can evidently run this computation in a purely sequential way as follows:

..  code-block:: java

    public static void main(String[] args) {
        float values[] = new float[] { -2, -5, 4 };
        Runnable r = new MinComputation(values);
        r.run();
        // This prints: "Minimum value: -5.0"
    }

In this example, no additional thread was created besides the main Java thread. Thanks to the fact that ``MinComputation`` implements ``Runnable``, it is now possible to compute the minimum in a separate thread:

..  code-block:: java

    public static void main(String[] args) {
        float values[] = new float[] { -2, -5, 4 };

        // First, create a thread that specifies the computation to be done
        Thread t = new Thread(new MinComputation(values));

        // Secondly, start the thread
        t.start();

        // ...at this point, the main thread can do other stuff...
        System.out.println("This is the main thread");

        // Thirdly, wait for the thread to complete its computation
        try {
            t.join();
        } catch (InterruptedException e) {
            throw new RuntimeException("Unexpected interrupt", e);
        }

        System.out.println("All threads have finished");
    }

As can be seen in this example, doing a computation in a background thread involves three main steps:

1. Construct an object of the class ``Thread`` out of an object that implements the ``Runnable`` interface.

2. Launch the thread by using the ``start()`` method of ``Thread``. The constructor of ``Thread`` does not automatically start the thread, so we have to do this manually.

3. Wait for the completion of the thread by calling the ``join()`` method of ``Thread``. Note that ``join()`` can throw an ``InterruptedException``, which happens if the thread is interrupted by something.

The following sequence diagram (loosely inspired from `UML <https://en.wikipedia.org/wiki/Unified_Modeling_Language>`__) depicts this sequence of calls:
   
.. image:: _static/images/part5/sequence-thread.svg
  :width: 80%
  :align: center
  :alt: Sequence diagram of the computation of the minimum

In this diagram, the white bands indicate the moments where the different classes are executing code. It can be seen that between the two calls ``t.start()`` and ``t.join()``, two threads are simultaneously active: the main thread and the computation thread. Note that once the main thread calls ``t.join()``, it falls asleep until the computation thread finishes its work.

In other words, the ``t.join()`` call is a form of **synchronization** between threads. It is always a good idea for the main Java thread to wait for all of its child threads by calling ``join()`` on each of them. If a child thread launches its own set of sub-threads, it is highly advised for this child thread to call ``join()`` of each of its sub-threads before ending. The Java process will end if all its threads have ended, including the main thread.


Speeding up the computation
---------------------------

The ``MinComputation`` example creates one background thread to do a computation on a array. As explained in the :ref:`introduction <part5>`, this software architecture can have an interest to keep the user interface reactive during the computation.

However, this design does not exploit multiple CPU cores to speed up the computation: The time that is necessary to compute the minimum value is still the same as a purely sequential implementation. In order to optimize the computation itself, the basic idea is to split the array in two parts, then to process each of those parts by two distinct threads:
   
.. image:: _static/images/part5/array-threads.svg
  :width: 80%
  :align: center
  :alt: Splitting an array to improve performance

Once the two threads have finished their work, it is possible to **combine** their results to get the final result: The minimum of the whole array is the minimum of the two minimums computed on the two parts.

To implement this solution, the class that implements the ``Runnable`` interface must not only receive the ``values`` array, but it must also receive the start index and the end index of the block of interest in the array. Furthermore, the class must not *print* the minimum, but must provide access to computed minimum value. This is implemented in the following code:

..  code-block:: java

    static class MinBlockComputation implements Runnable {
        private float values[];
        private int startIndex;
        private int endIndex;
        private float minValue;

        public MinBlockComputation(float values[],
                                   int startIndex,
                                   int endIndex) {
            if (startIndex >= endIndex) {
                throw new IllegalArgumentException("Empty array");
            }

            this.values = values;
            this.startIndex = startIndex;
            this.endIndex = endIndex;
        }

        @Override
        public void run() {
            minValue = values[startIndex];
            for (int i = 1; i < endIndex; i++) {
                minValue = Math.min(values[i], minValue);
            }
        }

        float getMinValue() {
            return minValue;
        }
    }

Note that we now have to throw an exception if the array is empty, because the minimum is not defined in this case. In the previous implementation, we simply printed out the information. This is not an appropriate solution anymore, as we have to provide an access to the computed minimum value.
    
As before, the ``MinBlockComputation`` class can be invoked in a sequential way:

..  code-block:: java

    public static void main(String[] args) {
        float values[] = new float[] { -2, -5, 4 };
        MinBlockComputation r = new MinBlockComputation(values, 0, values.length);
        r.run();
        System.out.println("Minimum value: " + r.getMinValue());
    }

Thanks to this new design, it is however now possible to speed up the compution the minimum using two threads:

..  code-block:: java

    public static void main(String[] args) throws InterruptedException {
        float values[] = new float[] { -2, -5, 4 };

        MinBlockComputation c1 = new MinBlockComputation(values, 0, values.length / 2);
        MinBlockComputation c2 = new MinBlockComputation(values, values.length / 2, values.length);
        
        Thread t1 = new Thread(c1);
        Thread t2 = new Thread(c2);

        t1.start();
        t2.start();

        t1.join();
        t2.join();

        System.out.println("Minimum is: " + Math.min(c1.getMinValue(), c2.getMinValue()));
    }

This implementation works as follows:

1. We define the two computations ``c1`` and ``c2`` that must be carried on the two parts of the whole array. Importantly, the computations are only *defined*, the minimum is not computed at this point.

2. We create and launch two threads ``t1`` and ``t2`` that will respectively be in charge of calling the ``c1.run()`` and ``c2.run()`` methods. In other words, it is only *after* the calls to ``t1.start()`` and ``t2.start()`` that the search for the minimum begins.

3. Once the two threads have finished their work, the main thread collects the partial results from ``c1`` and ``c2``, then combines these partial results in order to print the final result.

Also note that this version does not catch the possible ``InterruptedException``, but reports it to the caller.


Optional results
----------------

Even though the implementation from the previous section works fine on arrays containing at least 2 elements, it fails if the ``values`` array is empty or only contains 1 element. Indeed, in this case, ``values.length / 2 == 0``, which throws the ``IllegalArgumentException`` in the constructor of ``c1``. Furthermore, if ``values.length == 0``, the constructor of ``c2`` would launch the same exception.

One could solve this problem by conditionning the creation of ``c1``, ``c2``, ``t1``, and ``t2`` according to the value of ``values.length``. This would however necessitate to deal with multiple cases that are difficult to write and maintain. This problem would also be exacerbated if we want to divide the array into more than 2 parts to better exploit the available CPU cores.



..
   Take-home messages
   ==================

   It is really important to master multithreading. Even if
