.. _part5:


*****************************************************************
Part 5: Parallel Programming
*****************************************************************

Parallel programming is a computing technique where multiple tasks are executed simultaneously to achieve faster execution times and to improve resource utilization compared to sequential execution.

Parallel programming involves **breaking down a task into smaller sub-tasks that can be executed independently and concurrently** across multiple processing units, such as CPUs (central processing units), GPUs (graphics processing units), or distributed computing resources.

In particular, there is a growing interest in the exploitation of GPUs to carry on computations that are not related to computer graphics. Indeed, **GPUs** consist of a massive number of processing units working in parallel that are highly optimized for certain types of computations, especially those involving heavy numerical calculations, matrix operations, simulations, graphics rendering, and deep learning.

However, while GPUs are incredibly powerful for certain types of parallel computations, they are not a universal replacement for CPUs. Indeed, CPUs are much more versatile compared to GPUs, as they are designed to handle a wide range of tasks, including general-purpose computing, running operating systems, managing I/O operations, executing single-threaded applications, and handling diverse workloads. Furthermore, certain types of tasks, particularly those with sequential dependencies or requiring frequent access to shared data, might not benefit significantly from GPU acceleration. Finally, writing code for GPUs often requires the usage of specialized programming languages or libraries and the understanding of the underlying hardware architecture.

Consequently, in this course, we will only focus on **parallel programming on CPU**. It is indeed essential to notice that thanks to hardware evolution, any consumer computer is nowadays equipped with multiple CPU cores (even if they are less numerous than processing units inside a GPU), as depicted on the following picture:

.. image:: _static/images/part5/gpu-vs-cpu.svg
  :width: 75%
  :align: center
  :alt: GPU vs. CPU

Parallel programming on CPU seeks to leverage the multiple CPU cores available inside a single computer to execute multiple tasks or portions of a single task simultaneously.

Besides the exploitation of multiple CPU cores to speed up computations, parallel programming on CPU also enables more responsive user interfaces. Indeed, most GUI (graphical user interface) frameworks are built on the top of a "main event loop" that continuously monitors user interactions and that call application code to react to those events. If the application code takes too much time to run, the user interface appears to "freeze." Parallel programming allows to run the application code in the background, hereby maintaining an optimal user experience.

This concept of "main event loop" can also be encountered in network applications, where a software must serve requests from different clients. In such software servers, each connection with a client can be handled in the background, leaving the main server listen to new connections.


Multiprocessing vs. multithreading
==================================

In computing, a **process** corresponds to a program that is actively running on the CPU of a computer, along with its current state. A typical operating system allows multiple independent processes to run concurrently on the available CPU cores, hereby providing an environment to achieve parallelism that is referred to as **multiprocessing**.

A process has its own memory space (including code, data, stack, and CPU registers) and its own resources that are isolated from other processes to prevent unauthorized access and interference. Distinct processes may still communicate with each other through the so-called **"interprocess communication" (IPC)** mechanisms provided by the operating system, such as files, pipes, message passing, shared memory, or network communications (sockets).

Multiprocessing has two main downsides. Firstly, creating new processes incurs a high overhead due to the need for separate memory allocation and setup for each process. Secondly, because different processes are isolated from each other, interprocess communications are relatively complex and come at a non-negligible cost.

This motivates the introduction of the concept of a **thread**. A thread refers to the smallest unit of execution within a process. A thread corresponds to a sequence of instructions that can be scheduled and executed independently by one CPU. One single process can run multiple threads, as illustrated below:

.. image:: _static/images/part5/threads.svg
  :width: 50%
  :align: center
  :alt: Multithreading


Accordingly, **multithreading** is a programming technique where a single process is divided into multiple threads of execution. Threads can perform different operations simultaneously, such as handling different parts of an application (e.g., keeping the user interface responsive while performing a background computation).

Importantly, threads within the same process are not isolated: They share the same memory space and resources, which allows distinct threads to directly access the same variables and data structures. Threads are sometimes called *lightweight processes*, because creating threads within a process incurs less overhead compared to creating multiple processes.

Summarizing, multithreading tends to be simpler and more lightweight than multiprocessing. This explains why this course will only cover the **basics of multithreading in Java**.

It is however worth remembering that the fact that different threads do not live in isolation can be error-prone. Multithreading notably requires the introduction of suitable synchronization and coordination mechanisms between threads when accessing shared variables. If not properly implemented, race conditions, deadlocks, and synchronization issues can emerge, which can be extremely hard to identify, debug, and resolve.
 

Threads in Java
===============

Java provides extensive support of multithreading. When a Java program starts its execution, the Java Virtual Machine (JVM) starts an initial thread. This initial thread is called the **main thread** and is responsible for the execution of the ``main()`` method, which is the :ref:`entry point of most Java applications <java_main>`.

Additional threads can then be created in two different ways:

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

As explained above, if one wishes to run this computation as a background thread, the ``computeMinValue()`` method must wrapped inside some implementation of the ``Runnable`` interface. But the ``run()`` method of the ``Runnable`` interface doesn't accept any parameter, so we cannot directly give the ``values`` array as an argument to ``run()``. The trick is to store a reference to the ``values`` array inside a class that implements ``Runnable``:

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

Our ``MinComputation`` class specifies how to compute the minimum of an array. We can evidently run it in a purely sequential way as follows:

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

2. Launch the thread by using the ``start()`` method of ``Thread``. The constructor of ``Thread`` does not automatically start the thread, so we need to do this manually.

3. Wait for the completion of the thread by calling the ``join()`` method of ``Thread``. Note that ``join()`` can throw an ``InterruptedException``, which happens if the thread is interrupted by something.

The following sequence diagram (loosely inspired from `UML <https://en.wikipedia.org/wiki/Unified_Modeling_Language>`__) depicts this sequence of calls:
   
.. image:: _static/images/part5/sequence-thread.svg
  :width: 80%
  :align: center
  :alt: Sequence diagram of the computation of the minimum

In this diagram, the white bands indicate the moments where the different classes are executing code. It can be seen that between the two calls ``t.start()`` and ``t.join()``, two threads are simultaneously active: the main thread and the computation thread. Note that once the main thread calls ``t.join()``, it falls asleep until the computation thread finishes its work. In other words, the ``t.join()`` call is a form of **synchronization** between threads.
