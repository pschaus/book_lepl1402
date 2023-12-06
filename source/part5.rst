.. _part5:


*****************************************************************
Part 5: Parallel Programming
*****************************************************************

Parallel programming is a computing technique where multiple tasks are executed simultaneously to achieve faster execution times and to improve resource utilization, compared to sequential execution.

Parallel programming involves **breaking down a task into smaller sub-tasks that can be executed independently and concurrently** across multiple processors, such as CPUs (central processing units), GPUs (graphics processing units), or distributed computing resources.

Parallel programming is often introduced as a way to optimally take advantage of the multiple computing units that are embedded in modern computers, in order to **speed up some computation that takes a lot time**.

However, besides this exploitation of multiple computing units to speed up computations, parallel programming also enables the design of **responsive user interfaces**. Indeed, most GUI (graphical user interface) frameworks are built on the top of a "main event loop" that continuously monitors user interactions and that calls application code to react to those events. If the application code takes too much time to run, the user interface appears to "freeze." Parallel programming allows to run this applicative logic in the background, hereby preserving an optimal user experience.

This concept of "main event loop" can also be encountered in **network applications**, where a software must simultaneously serve requests issued by different clients. Thanks to parallel programming, each connection with a client can be handled in the background, leaving the main server able to listen to new connections.

Finally, it may also happen that the design of a whole software can be more naturally modeled using parallel programming than using sequential programming. Think about your personal week agenda: You have a number of distinct tasks of different natures to be achieved during the week, and those tasks only have loose dependencies between them. A large-scale software is likewise: It can generally be **decomposed into a set of mostly uncoupled tasks**, where each of the individual tasks has a different objective and can be solved using sequential programming. Sequential programming has indeed the advantage of being easier to write, to :ref:`test <software_testing>`, and to correct. Nevertheless, developing the whole software using sequential programming would introduce unnecessary, arbitrary dependencies between the individual tasks, hereby reducing the performance and increasing the complexity of the design. Parallel programming can be a solution to improve such designs.


GPUs vs. CPUs
=============

In recent years, there is a growing interest in the exploitation of GPUs to carry on computations that are not related to computer graphics. Indeed, **GPUs** consist of a massive number of processing units working in parallel that are highly optimized for certain types of computations, especially those involving graphics rendering, heavy matrix operations, numerical simulations, and deep learning.

However, while GPUs are incredibly powerful for certain types of parallel computations, they are not a universal replacement for CPUs. Indeed, CPUs are much more versatile, as they are designed to handle a wide range of tasks, including general-purpose computing, running operating systems, managing I/O operations, executing single-threaded applications, and handling diverse workloads. In contrast, the processing units of GPUs focus on simpler, identical tasks that can be duplicated a large number of times. Furthermore, certain types of tasks, particularly those with sequential dependencies or requiring frequent access to shared data, might not benefit significantly from GPU acceleration. Finally, writing code for GPUs often requires the usage of specialized programming languages or libraries and the understanding of the underlying hardware architecture.

Consequently, in this course, we will only focus on **parallel programming on CPUs**. It is indeed essential to notice that thanks to hardware evolution, any consumer computer is nowadays equipped with multiple CPU cores (even if they are less numerous than processing units inside a GPU), as depicted on the following picture:

.. image:: _static/images/part5/gpu-vs-cpu.svg
  :width: 75%
  :align: center
  :alt: GPU vs. CPU

Parallel programming on CPU seeks to leverage the multiple CPU cores available inside a single computer to execute multiple tasks or portions of a single task simultaneously.


.. _multithreading:

Multiprocessing vs. multithreading
==================================

In computing, a **process** corresponds to a program that is actively running on the CPU of a computer, along with its current state. A typical operating system allows multiple independent processes to run concurrently on the available CPU cores, hereby providing an environment to achieve parallelism that is referred to as **multiprocessing**.

A process has its own memory space (including code, data, stack, and CPU registers) and its own resources that are isolated from other processes to prevent unauthorized access and interference. Distinct processes may still communicate with each other through the so-called **"interprocess communication" (IPC)** mechanisms provided by the operating system. IPCs include files, pipes, message passing, shared memory, and network communications (sockets).

Multiprocessing has two main downsides. Firstly, creating new processes incurs a high overhead due to the need for separate memory allocation and setup for each process. Secondly, because the different processes are isolated from each other, interprocess communications are relatively complex and come at a non-negligible cost.

This motivates the introduction of the concept of a **thread**. A thread refers to the smallest unit of execution within a process: A thread corresponds to a sequence of instructions that can be scheduled and executed independently by one CPU core. One single process can run multiple threads, as illustrated below:

.. image:: _static/images/part5/threads.svg
  :width: 50%
  :align: center
  :alt: Multithreading

In this picture, the blue blocks indicate at which moment the different threads are active (i.e., are executing something) within the process. A thread can indeed "fall asleep" while waiting for additional data to process, while waiting for user interaction, or while waiting for the result of a computation done by another thread.

Accordingly, **multithreading** is a programming technique where a single process is divided into multiple threads of execution. Threads can perform different operations concurrently, such as doing a computation in the background or handling different parts of the application (e.g., keeping the user interface responsive or serving requests from multiple clients).

Importantly, contrarily to processes, **threads within the same process are not isolated**: They share the same memory space and resources, which allows distinct threads to directly access the same variables and data structures. Threads are sometimes called *lightweight processes*, because creating threads within a process incurs less overhead compared to creating separate processes.

Summarizing, multithreading tends to be simpler and more lightweight than multiprocessing. This explains why this course will only cover the **basics of multithreading in Java**.

It is always worth remembering that the fact that different threads do not live in isolation can be error-prone. Multithreading notably requires the introduction of suitable synchronization and coordination mechanisms between threads when accessing shared variables. If not properly implemented, **race conditions, deadlocks, and synchronization issues can emerge**, which can be extremely hard to identify and resolve.

Also, note that all programmers are constantly confronted with threads. Indeed, even if you never explicitly create a thread by yourself, the vast majority of software frameworks (such as GUI frameworks and a software libraries that deal with network programming or scientific computations) will create threads on your behalf. For instance, in the context of Java-based GUI, both the :ref:`AWT (Abstract Window Toolkit) and the Swing frameworks <awt_swing>` will transparently create threads to handle the interactions with the user. Consequently, parallel programming should never be considered as an "advanced feature" of a programming language, because almost any software development has to deal with threads. In other words, even if you do not create your own threads, it is important to understand how to design thread-safe applications that properly coordinate the accesses to the shared memory space.


.. _runnable:

Threads in Java
===============

Java provides extensive support of multithreading.

When a Java program starts its execution, the Java Virtual Machine (JVM) starts an initial thread. This initial thread is called the **main thread** and is responsible for the execution of the ``main()`` method, which is the :ref:`entry point of most Java applications <java_main>`. Alongside the main thread, the JVM also start some private background threads for its own housekeeping (most notably the garbage collector).

Additional threads can then be created by software developers in two different ways:

* By :ref:`extending <inheritance>` the standard class ``Thread``. Note that since ``Thread`` belongs to the ``java.lang`` package, no ``import`` directive is needed. Here is the documentation of the ``Thread`` class: `<https://docs.oracle.com/javase/8/docs/api/java/lang/Thread.html>`_ 

* By :ref:`implementing <interfaces>` the standard interface ``Runnable`` that is also part of the ``java.lang`` package: `<https://docs.oracle.com/javase/8/docs/api/java/lang/Runnable.html>`_ 

In this course, we will use the second approach. The ``Runnable`` interface is quite intuitive:

..  code-block:: java

    public interface Runnable {
        public void run();
    }

This snippet indicates that to create a thread, we first have to define a class providing a ``run()`` method that will take care of the computations. Once a concrete class implementing this ``Runnable`` interface is available, it can be executed as a thread by instantiating an object of the ``Thread`` class.


.. _MinComputation:

Using a thread to compute the minimum
-------------------------------------

As an illustration, let us consider the task of computing the minimum value of an array of floating-point numbers. It is straightforward to implement a sequential method to do this computation:

..  code-block:: java

    static public void computeMinValue(float values[]) {
        if (values.length == 0) {
            System.out.println("This is an empty array");
        } else {
            float minValue = values[0];
            for (int i = 1; i < values.length; i++) {
                if (values[i] < minValue) {
                    minValue = values[i];
                }
                // One could have written more compactly: minValue = Math.min(minValue, values[i]);
            }
            System.out.println("Minimum value: " + minValue);
        }
    }

As explained above, if one wishes to run this computation as a background thread, the ``computeMinValue()`` method must wrapped inside some implementation of the ``Runnable`` interface. But the ``run()`` method of the ``Runnable`` interface does not accept any parameter, so we cannot directly give the ``values`` array as an argument to ``run()``. The trick is to store a reference to the ``values`` array inside the class that implements ``Runnable``:

..  code-block:: java

    class MinComputation implements Runnable {
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

In this diagram, the white bands indicate the moments where the different objects are executing code. It can be seen that between the two calls ``t.start()`` and ``t.join()``, two threads are simultaneously active: the main thread and the computation thread. Note that once the main thread calls ``t.join()``, it falls asleep until the computation thread finishes its work.

In other words, the ``t.join()`` call is a form of **synchronization** between threads. It is always a good idea for the main Java thread to wait for all of its child threads by calling ``join()`` on each of them. If a child thread launches its own set of sub-threads, it is highly advised for this child thread to call ``join()`` of each of its sub-threads before ending. The Java process will end if all its threads have ended, including the main thread.


.. _responsive:

Keeping user interfaces responsive
----------------------------------

The ``MinComputation`` example creates one background thread to run a computation on a array. As explained in the :ref:`introduction <part5>`, this software architecture can have an interest to keep the user interface responsive during some long computation. To illustrate this interest, consider a :ref:`GUI application <awt_swing>` with three buttons using Swing:

.. image:: _static/images/part5/swing.png
  :width: 320
  :align: center
  :alt: Swing application with 3 buttons

The corresponding source code is:

..  code-block:: java

    import java.awt.GridLayout;
    import java.awt.event.ActionEvent;
    import java.awt.event.ActionListener;
    import javax.swing.JButton;
    import javax.swing.JFrame;
    import javax.swing.JOptionPane;
    import javax.swing.JPanel;
    
    class SayHello implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            JOptionPane.showMessageDialog(null, "Hello world!");
        }
    }
    
    public class ButtonThread {
        public static void main(String[] args) {
            JFrame frame = new JFrame("Hello");
            frame.setSize(400,200);
            frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    
            JPanel panel = new JPanel();
            panel.setLayout(new GridLayout(3, 1));
            frame.add(panel);
    
            JButton button1 = new JButton("Say hello!");
            button1.addActionListener(new SayHello());
            panel.add(button1);
    
            JButton button2 = new JButton("Run the computation without a thread");
            button2.addActionListener(new RunWithoutThread());
            panel.add(button2);
    
            JButton button3 = new JButton("Run the computation using a thread");
            button3.addActionListener(new RunUsingThread());
            panel.add(button3);
    
            frame.setVisible(true);
        }
    }

Once the user clicks on the "Say hello!" button, a message box appears saying "Hello world!". Let us now implement the button entitled "Run the computation without a thread". In the ``ActionListener`` observer associated with this button, a long computation is emulated by waiting for 3 seconds:

..  code-block:: java

    static public void expensiveComputation() {
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
        }
        JOptionPane.showMessageDialog(null, "Phew! I've finished my hard computation!");
    }

    class RunWithoutThread implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            expensiveComputation();
        }
    }

If you try and run this example, if clicking on this second button, it becomes impossible to do any other interaction with the "Say hello!" button. The user interface is totally frozen until the ``expensiveComputation()`` method finishes its work.

In order to turn this non-responsive application into a responsive application, one can simply start a thread that runs the ``expensiveComputation()`` method:

..  code-block:: java

    class Computation implements Runnable {
        @Override
        public void run() {
            expensiveComputation();
        }
    }

    class RunUsingThread implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            Thread t = new Thread(new Computation());
            t.start();
        }
    }

This way, even when the computation is running, it is still possible to click on "Say hello!".
                 

.. _MinBlockComputation:

Speeding up the computation
---------------------------

Even though starting a background thread can be interesting to improve the responsiveness of an application (:ref:`as illustrated above <responsive>`), this does not speed up the computation. For instance, the time that is necessary to :ref:`compute the minimum value <MinComputation>` using ``MinComputation`` is still the same as the purely sequential implementation of method ``computeMinValue()``. In order to reduce the computation time, it is needed to modify the sequential algorithm so that it can exploit multiple CPU cores.

For algorithms working on an array, the basic idea is to split the array in two parts, then to process each of those parts by two distinct threads:
   
.. image:: _static/images/part5/array-threads.svg
  :width: 80%
  :align: center
  :alt: Splitting an array to improve performance

Once the two threads have finished their work, we need to **combine** their results to get the final result. In our example, the minimum of the whole array is the minimum of the two minimums computed on the two parts.

To implement this solution, the class that implements the ``Runnable`` interface must not only receive the ``values`` array, but it must also receive the start index and the end index of the block of interest in the array. Furthermore, the class must not *print* the minimum, but must provide access to computed minimum value in either block. This is implemented in the following code:

..  code-block:: java

    class MinBlockComputation implements Runnable {
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
            for (int i = startIndex + 1; i < endIndex; i++) {
                minValue = Math.min(values[i], minValue);
            }
        }

        float getMinValue() {
            return minValue;
        }
    }

Note that we now have to throw an exception if the array is empty, because the minimum is not defined in this case. In the previous implementation, we simply printed out the information. This is not an appropriate solution anymore, as we have to provide an access to the computed minimum value.
    
Thanks to this new design, it is now possible to speed up the computation the minimum using two threads:

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

The implementation works as follows:

1. We define the two computations ``c1`` and ``c2`` that must be carried on the two parts of the whole array. Importantly, the computations are only *defined*, the minimum is not computed at this point.

2. We create and launch two threads ``t1`` and ``t2`` that will respectively be in charge of calling the ``c1.run()`` and ``c2.run()`` methods. In other words, it is only *after* the calls to ``t1.start()`` and ``t2.start()`` that the search for the minimum begins.

3. Once the two threads have finished their work, the main thread collects the partial results from ``c1`` and ``c2``, then combines these partial results in order to print the final result.

Also note that this version does not catch the possible ``InterruptedException``, but reports it to the caller.


.. _MinMaxResult:

Dealing with empty parts
------------------------

Even though the implementation from the previous section works fine on arrays containing at least 2 elements, it fails if the ``values`` array is empty or only contains 1 element. Indeed, in this case, ``values.length / 2 == 0``, which throws the ``IllegalArgumentException`` in the constructor of ``c1``. Furthermore, if ``values.length == 0``, the constructor of ``c2`` would launch the same exception.

One could solve this problem by conditioning the creation of ``c1``, ``c2``, ``t1``, and ``t2`` according to the value of ``values.length``. This would however necessitate to deal with multiple cases that are difficult to write and maintain. This problem would also be exacerbated if we decide to divide the array into more than 2 parts to better exploit the available CPU cores.

A simpler, more scalable solution consists in introducing a Boolean flag that indicates whether a result is present for each part of the array. Instead of throwing the ``IllegalArgumentException`` in the constructor, this flag would be set to ``false`` if the search for minimum is launched on an empty block.

To illustrate this idea, let us consider the slightly more complex problem of computing both the minimum and the maximum values of an array. The first step is to define a class that will hold the result of a computation:

..  code-block:: java

    class MinMaxResult {
        private boolean isPresent;
        private float minValue;
        private float maxValue;

        private MinMaxResult(boolean isPresent,
                             float minValue,
                             float maxValue) {
            this.isPresent = isPresent;
            this.minValue = minValue;
            this.maxValue = maxValue;
        }

        public MinMaxResult(float minValue,
                            float maxValue) {
            this(true /* present */, minValue, maxValue);
        }

        static public MinMaxResult empty() {
            return new MinMaxResult(false /* not present */, 0 /* dummy min */, 0 /* dummy max */);
        }

        public boolean isPresent() {
            return isPresent;
        }

        public float getMinValue() {
            if (isPresent()) {
                return minValue;
            } else {
                throw new IllegalStateException();
            }
        }

        public float getMaxValue() {
            if (isPresent()) {
                return maxValue;
            } else {
                throw new IllegalStateException();
            }
        }

        public void print() {
            if (isPresent()) {
                System.out.println(getMinValue() + " " + getMaxValue());
            } else {
                System.out.println("Empty array");
            }
        }

        public void combine(MinMaxResult with) {
            if (with.isPresent) {
                if (isPresent) {
                    // Combine the results from two non-empty blocks
                    minValue = Math.min(minValue, with.minValue);
                    maxValue = Math.max(maxValue, with.maxValue);
                } else {
                    // Replace the currently absent result by the provided result
                    isPresent = true;
                    minValue = with.minValue;
                    maxValue = with.maxValue;
                }
            } else {
                // Do nothing if the other result is absent
            }
        }
    }

Introducing the ``MinMaxResult`` class allows us to cleanly separate the two distinct concepts of the "*algorithm to do a computation*" and of the "*results of the computation*." This separation is another example of a :ref:`design pattern <part4>`.

As can be seen in the source code, there are two possible ways to create an object of the ``MinMaxResult`` class:

* either by using the ``MinMaxResult(minValue, maxValue)`` constructor, which sets the ``isPresent`` flag to ``true`` in order to indicate the presence of a result,

* or by using the ``MinMaxResult.empty()`` static method, that creates a ``MinMaxResult`` object with the ``isPresent`` flag set to ``false`` in order to indicate the absence of a result (this is the case of an empty block).

The object throws an exception if trying to access the minimum or the maximum values if the result is absent. It is up to the caller to check the presence of a result using the ``isPresent()`` method, before calling ``getMinValue()`` or ``getMaxValue()``.

Finally, note the presence of the ``combine()`` method. This method updates the currently available minimum/maximum values with the results obtained from a different block. The ``combine()`` implements the combination of two partial results.

It is now possible to create an implementation of the ``Runnable`` interface that leverages ``MinMaxResult``:

..  code-block:: java

    class MinMaxBlockComputation implements Runnable {
        private float[] values;
        private int startIndex;
        private int endIndex;
        private MinMaxResult result;

        public MinMaxBlockComputation(float[] values,
                                      int startIndex,
                                      int endIndex) {
            this.values = values;
            this.startIndex = startIndex;
            this.endIndex = endIndex;
        }

        @Override
        public void run() {
            if (startIndex >= endIndex) {
                result = MinMaxResult.empty();
            } else {
                float minValue = values[startIndex];
                float maxValue = values[startIndex];

                for (int i = startIndex + 1; i < endIndex; i++) {
                    minValue = Math.min(minValue, values[i]);
                    maxValue = Math.max(maxValue, values[i]);
                }

                result = new MinMaxResult(minValue, maxValue);
            }        
        }

        MinMaxResult getResult() {
            return result;
        }
    }

                 
The ``MinMaxBlockComputation`` class is essentially the same as the ``MinBlockComputation`` class :ref:`defined earlier<MinBlockComputation>`. It only differs in the way the result is stored: ``MinBlockComputation`` uses a ``float`` to hold the result of the computation on a block, whereas ``MinMaxBlockComputation`` uses an object of the ``MinMaxResult`` class. This allows ``MinMaxBlockComputation`` not only to report both the minimum and maximum values of part of an array, but also to indicate whether that part was empty or non-empty.
                 
It is now easy to run the computation using two threads in a way that is also correct when the ``values`` array contains 0 or 1 element:

..  code-block:: java

    public static void main(String[] args) throws InterruptedException {
        float values[] = new float[1024];
        // Fill the array

        MinMaxBlockComputation c1 = new MinMaxBlockComputation(values, 0, values.length / 2);
        MinMaxBlockComputation c2 = new MinMaxBlockComputation(values, values.length / 2, values.length);
        Thread t1 = new Thread(c1);
        Thread t2 = new Thread(c2);
        t1.start();
        t2.start();
        t1.join();
        t2.join();

        MinMaxResult result = c1.getResult();
        result.combine(c2.getResult());
        result.print();
    }


Optional results
----------------

The ``MinMaxResult`` class :ref:`was previously introduced <MinMaxResult>` as a way to deal with the absence of a result in the case of an empty part of an array. More generally, dealing with the absence of a value is a common pattern in software architectures. For this reason, Java introduces the ``Optional<T>`` generic class: `<https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html>`_ 

The ``Optional<T>`` class does exactly the same stuff as the ``isPresent`` Boolean flag that we manually introduced into the ``MinMaxResult`` class. The four main operations of ``Optional<T>`` are:

* ``of(T t)`` is a static method that constructs an ``Optional<T>`` object embedding the given object ``t`` of class ``T``.
* ``empty()`` is a static method that constructs an ``Optional<T>`` object indicating the absence of an object of class ``T``.
* ``isPresent()`` is a method that indicates whether the ``Optional<T>`` object contains an object.
* ``get()`` returns the embedded object of class ``T``. If the ``Optional<T>`` does not contains an object, an exception is thrown.

Consequently, we could have defined a simplified version of ``MinMaxResult`` without the ``isPresent`` Boolean flag as follows:

..  code-block:: java

    class MinMaxResult2 {
        private float minValue;
        private float maxValue;

        public MinMaxResult2(float minValue,
                             float maxValue) {
            this.minValue = minValue;
            this.maxValue = maxValue;
        }

        public float getMinValue() {
            return minValue;
        }

        public float getMaxValue() {
            return maxValue;
        }
    }

By combining ``MinMaxResult2`` with ``Optional<T>``, the sequential algorithm to be integrated inside the ``run()`` method of the ``Runnable`` class could have been rewritten as:

..  code-block:: java

    import java.util.Optional;

    public static Optional<MinMaxResult2> computeMinMaxSequential(float values[],
                                                                  int startIndex,
                                                                  int stopIndex) {
        if (startIndex >= stopIndex) {
            return Optional.empty();
        } else {
            float minValue = values[startIndex];
            float maxValue = values[startIndex];

            for (int i = startIndex + 1; i < stopIndex; i++) {
                minValue = Math.min(minValue, values[i]);
                maxValue = Math.max(maxValue, values[i]);
            }

            return Optional.of(new MinMaxResult2(minValue, maxValue));
        }
    }

    public static void main(String[] args) {
        float values[] = new float[] { -2, -5, 4 };

        Optional<MinMaxResult2> result = computeMinMaxSequential(values, 0, values.length);
        if (result.isPresent()) {
            System.out.println(result.get().getMinValue() + " " + result.get().getMaxValue());
        } else {
            System.out.println("Empty array");
        }
    }

This alternative implementation would have been slightly shorter and would have avoided any possible bug in our manual implementation of the ``isPresent`` flag.
    
.. admonition:: Exercise
   :class: note

   Reimplement the ``MinMaxBlockComputation`` class by replacing ``MinMaxResult`` with ``Optional<MinMaxResult2>``, and launch threads based on this new class.


.. _thread_pools:
   
Thread pools
============

So far, we have only created two threads, but a modern CPU will typically have at least 4 cores. One could launch more threads to benefit from those additional cores. For instance, the following code would use 4 threads by dividing the array in 4 parts:
   
..  code-block:: java

    public static void main(String[] args) throws InterruptedException {
        float values[] = new float[1024];
        // Fill the array

        int blockSize = values.length / 4;
        MinMaxBlockComputation c1 = new MinMaxBlockComputation(values, 0, blockSize);
        MinMaxBlockComputation c2 = new MinMaxBlockComputation(values, blockSize, 2 * blockSize);
        MinMaxBlockComputation c3 = new MinMaxBlockComputation(values, 2 * blockSize, 3 * blockSize);
        MinMaxBlockComputation c4 = new MinMaxBlockComputation(values, 3 * blockSize, values.length);
        Thread t1 = new Thread(c1);
        Thread t2 = new Thread(c2);
        Thread t3 = new Thread(c3);
        Thread t4 = new Thread(c4);
        t1.start();
        t2.start();
        t3.start();
        t4.start();
        t1.join();
        t2.join();
        t3.join();
        t4.join();

        MinMaxResult result = MinMaxResult.empty();
        result.combine(c1.getResult());
        result.combine(c2.getResult());
        result.combine(c3.getResult());
        result.combine(c4.getResult());
        result.print();
    }

Note that the definition of ``c4`` uses the size of the array (i.e., ``values.length``) as its stop index, instead of ``4 * blockSize``, in order to be sure that the last items in the array get processed if the size of the array is not a multiple of 4.

We could continue adding more threads in this way (for instance, 8, 16, 32...). But if we use, say, 100 threads, does that mean that our program will run 100 faster? The answer is no, for at least two reasons:

* Obviously, the level of parallelism is limited by the number of CPU cores that are available. If using a CPU with 4 cores, you cannot expect a speed up of more than 4.

* Even if threads are lightweight, there is still an overhead associated with the creation and management of a thread. On a modern computer, creating a simple thread (without any extra object) takes around 0.05-0.1 ms. That is approximately the time to calculate the sum from 1 to 100,000.

We can conclude that threads only improve the speed of a program if the tasks for the threads are longer than the overhead to create and manage them. This motivates the introduction of **thread pools**. A thread pool is a group of threads that are ready to work:

.. image:: _static/images/part5/thread-pool.svg
  :width: 80%
  :align: center
  :alt: Thread pool

In this drawing, we have a thread pool that is made of 2 threads. Those threads are continuously monitoring a queue of pending tasks. As soon as some task is enqueued and as soon as some thread becomes available, the available thread takes care of this task. Once the task is over, the thread informs the caller that the result of the task is available, then it goes back to listening to the queue, waiting for a new task to be processed.

Thread pools are an efficient way to avoid the overhead associated with the initialization and finalization of threads. It also allows to write user code that is uncoupled from the number of threads or from the number of CPU cores.


Thread pools in Java
--------------------

In Java, three different interfaces are generally combined to create a thread pool:

* ``java.util.concurrent.ExecutorService`` implements the thread pool itself, including the queue of requests and its background threads: `<https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ExecutorService.html>`_.

* ``java.util.concurrent.Callable<T>`` is a generic interface that represents the task to be run. The task must return an object of type ``T``: `<https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Callable.html>`_.

* ``java.util.concurrent.Future<T>`` is a generic interface that represents the result of a task that is in the process of being computed: `<https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Future.html>`_.

The :ref:`Java Development Kit (JDK) <jdk>` provides concrete implementations of ``ExecutorService`` and ``Future``, so we (fortunately!) do not have to implement them by ourselves. A concrete thread pool can be created as follows:

..  code-block:: java

    ExecutorService executor = Executors.newFixedThreadPool(4 /* numberOfThreads */);

                 
As developers, our sole responsibility consists in choosing the generic type ``T`` and in providing an implementation of interface ``Callable<T>`` that describes the task to be achieved. The interface ``Callable<T>`` looks as follows:

..  code-block:: java

    public interface Callable<T> {
        public T call();
    }

This looks extremely similar to the ``Runnable`` interface that :ref:`we have been using so far <runnable>`! The difference between the ``Runnable`` and a ``Callable<T>`` interfaces is that the former has no return value, whereas the latter returns a result of type ``T``.

Once a concrete implementation of ``Callable<T>`` is available, tasks can be submitted to the thread pool. The pattern is as follows:

..  code-block:: java

    Future<T> future1 = executor.submit(new MyCallable(...));

Threads in thread pool are like chefs in the kitchen of a restaurant waiting for orders. If you submit one task to the pool using the call above, one of the chefs will take the task and it will immediately start working on it. You can submit more tasks, but they might have to wait until one chef has finished dealing with its current task:

..  code-block:: java

    Future<T> future2 = executor.submit(new MyCallable(...));
    Future<T> future3 = executor.submit(new MyCallable(...));
    Future<T> future4 = executor.submit(new MyCallable(...));
    // ...

You can obtain the result of the futures with their ``get()`` method:

..  code-block:: java

    T result1 = future1.get();
    T result2 = future2.get();
    T result3 = future3.get();
    T result4 = future4.get();
    // ...

If the task is not finished yet, the method ``get()`` will wait. This contrast with the ``executor.submit()`` method that always returns immediately.

At the end of the program or when you do not need the thread pool anymore, you have to shut it down explicitly to stop all its threads, otherwise the software might not properly exit:

..  code-block:: java

    executor.shutdown();


Thread pool for computing the minimum and maximum
-------------------------------------------------

It is straightforward to turn the ``MinMaxBlockComputation`` runnable that :ref:`was defined above<MinMaxResult>` into an callable:

..  code-block:: java

    class MinMaxBlockCallable implements Callable<MinMaxResult> {
        private float[] values;
        private int startIndex;
        private int endIndex;
        // Removed member: MinMaxResult result;

        public MinMaxBlockCallable(float[] values,
                                   int startIndex,
                                   int endIndex) {
            this.values = values;
            this.startIndex = startIndex;
            this.endIndex = endIndex;
        }

        @Override
        public MinMaxResult call() {
            if (startIndex >= endIndex) {
                return MinMaxResult.empty();
            } else {
                float minValue = values[startIndex];
                float maxValue = values[startIndex];

                for (int i = startIndex + 1; i < endIndex; i++) {
                    minValue = Math.min(minValue, values[i]);
                    maxValue = Math.max(maxValue, values[i]);
                }

                return new MinMaxResult(minValue, maxValue);
            }        
        }
    }
 
The only differences are:

* The ``Runnable`` interface is replaced by the ``Callable<MinMaxResult>`` interface.

* The method ``run()`` is replaced by method ``call()``.

* The member variable ``result`` and the method ``getResult()`` are removed. These elements are replaced by the return value of ``call()``.

Thanks to the newly defined ``MinMaxBlockCallable`` class, it is now possible to use a thread pool:

..  code-block:: java

    public static void main(String[] args) throws InterruptedException, ExecutionException {
        // Create a thread pool with 4 threads (the thread pool could be shared with other methods)
        ExecutorService executor = Executors.newFixedThreadPool(4);

        float values[] = new float[1024];
        // Fill the array

        // Create two tasks that work on two distinct parts of the whole array
        Future<MinMaxResult> partialResult1 = executor.submit(new MinMaxBlockCallable(values, 0, values.length / 2));
        Future<MinMaxResult> partialResult2 = executor.submit(new MinMaxBlockCallable(values, values.length / 2, values.length));

        // Combine the partial results on the two parts to get the final result
        MinMaxResult finalResult = MinMaxResult.empty();
        finalResult.combine(partialResult1.get());  // This call blocks the main thread until the first part is processed
        finalResult.combine(partialResult2.get());  // This call blocks the main thread until the second part is processed
        finalResult.print();

        // Do not forget to shut down the thread pool
        executor.shutdown();
    }
    

This solution looks extremely similar to the previous solution using ``Runnable`` and ``Thread``. However, in this code, we do not have to manage the threads by ourselves, and the thread pool could be shared with other parts of the software.

The ``throws`` construction is needed because the ``get()`` method of futures can possibly throw an ``InterruptedException`` (if the future was interrupted while waiting) or an ``ExecutionException`` (if there was a problem during the calculation).


.. _pool_multiple_blocks:

Dividing the array into multiple blocks
---------------------------------------

So far, we have divided the array ``values`` into 2 or 4 blocks, because we were guided by the number of CPU cores. In practice, it is a better idea to divide the array into blocks of a fixed size to become agnostic of the underlying number of cores. A thread pool can be used in this situation to manage the computations, while preventing the number of threads to exceed the CPU capacity.

To this end, we can create a separate data structure (e.g., a stack or a list) that keeps track of the pending computations by storing the ``Future<MinMaxResult>`` objects:

..  code-block:: java

    public static void main(String[] args) throws InterruptedException, ExecutionException {
        ExecutorService executor = Executors.newFixedThreadPool(4);

        float values[] = new float[1024];
        // Fill the array

        int blockSize = 128;

        Stack<Future<MinMaxResult>> pendingComputations = new Stack<>();

        for (int block = 0; block < numberOfBlocks; block++) {
            int startIndex = block * blockSize;
            int endIndex;
            if (block == numberOfBlocks - 1) {
                endIndex = values.length;
            } else {
                endIndex = (block + 1) * blockSize;
            }
            
            pendingComputations.add(executor.submit(new MinMaxBlockCallable(values, startIndex, endIndex)));
        }

        MinMaxResult result = MinMaxResult.empty();

        while (!pendingComputations.empty()) {
            Future<MinMaxResult> partialResult = pendingComputations.pop();
            result.combine(partialResult.get());
        }

        result.print();
        
        executor.shutdown();
    }

Note that the end index of the last block is treated specifically, because ``values.length`` might not be an integer multiple of ``blockSize``.


Computing the mean of an array
------------------------------

Up to now, this chapter has been almost entirely focused on the task of finding the minimum and maximum values in an array. We have explained how the introduction of the separate class ``MinMaxResult`` that is dedicated to the storage of partial results leads to a natural use of thread pools by implementing the ``Callable<MinMaxResult>`` interface. An important trick was to define the ``combine()`` method that is responsible for combining the partial results obtained from different parts of the array.

How could we compute the mean of the array using a similar approach?

The first thing is to define a class that stores the partial result over a block of the array. One could decide to store only the mean value itself. Unfortunately, this choice would not give enough information to implement the ``combine()`` method. Indeed, in order to combine two means, it is necessary to know the number of elements upon which the individual means were computed.

The solution consists in storing the sum and the number of elements in a dedicated class:

..  code-block:: java

    class MeanResult {
        private double sum;  // We use doubles as we might be summing a large number of floats
        private int count;

        public MeanResult() {
            sum = 0;
            count = 0;
        }

        public void addValue(float value) {
            sum += value;
            count++;
        }

        public boolean isPresent() {
            return count > 0;
        }

        public float getMean() {
            if (isPresent()) {
                return (float) (sum / (double) count);
            } else {
                throw new IllegalStateException();
            }
        }

        public void combine(MeanResult with) {
            sum += with.sum;
            count += with.count;
        }

        public void print() {
            if (isPresent()) {
                System.out.println(getMean());
            } else {
                System.out.println("Empty array");
            }
        }    
    }

Thanks to the ``MeanResult`` class, the source code of ``MinMaxBlockCallable`` can be adapted in order to define a callable that computes the mean of a block of an array:

..  code-block:: java

    class MeanUsingCallable implements Callable<MeanResult> {
        private float[] values;
        private int startIndex;
        private int endIndex;

        public MeanUsingCallable(float[] values,
                                 int startIndex,
                                 int endIndex) {
            this.values = values;
            this.startIndex = startIndex;
            this.endIndex = endIndex;
        }

        @Override
        public MeanResult call() {
            MeanResult result = new MeanResult();
            for (int i = startIndex; i < endIndex; i++) {
                result.addValue(values[i]);
            }
            return result;
        }
    }
  
This callable can be used as a drop-in replacement in the :ref:`source code to compute the minimum/maximum <pool_multiple_blocks>`.

.. admonition:: Exercise
   :class: note

   The classes ``MinMaxBlockCallable`` and ``MeanUsingCallable`` share many similarities: They both represent a computation that can be done on a part of an array, they both use a dedicated class to store their results, and they both support the operation ``combine()`` to merge partial results. However, the :ref:`source code to compute the minimum/maximum <pool_multiple_blocks>` must be adapted for each of them.

   Implement a hierarchy of classes/interfaces that can be used to implement a single source code that is compatible with both ``MinMaxBlockCallable`` and ``MeanUsingCallable``. Furthermore, validate your approach by demonstrating its compatibility with the computation of the standard deviation.

   Hint: Standard deviation can be derived from the variance, which can be computed from the number of elements in the block, from the sum of elements in the block, and from the sum of the squared elements in the block: `<https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance>`_ (cf. naive algorithm).

    
Shared memory
=============

In the solutions presented so far, the strategy was to make ``Runnable`` or ``Callable<T>`` responsible for computing the partial results, then to make the main Java thread responsible to combine those partial results. But, :ref:`as explained earlier <multithreading>`, threads that belong to the same process share the same memory space. This means that **threads can access the same variables**.


.. _shared_partial:

Using a shared variable to collect the partial results
------------------------------------------------------

According to this discussion, it should be possible to make the threads merge *directly* their partial results into a shared variable, freeing the main thread from this combination task. This is a perfectly valid idea, that is implemented in the following ``Runnable``:

..  code-block:: java

    class SharedMinMaxComputation implements Runnable {
        private SharedMinMaxResult target;
        private float[] values;
        private int startIndex;
        private int endIndex;

        public SharedMinMaxComputation(SharedMinMaxResult target,
                                       float[] values,
                                       int startIndex,
                                       int endIndex) {
            this.target = target;
            this.values = values;
            this.startIndex = startIndex;
            this.endIndex = endIndex;
        }

        @Override
        public void run() {
            if (startIndex < endIndex) {
                float minValue = values[startIndex];
                float maxValue = values[startIndex];

                for (int i = startIndex + 1; i < endIndex; i++) {
                    minValue = Math.min(minValue, values[i]);
                    maxValue = Math.max(maxValue, values[i]);
                }

                target.combine(new SharedMinMaxResult(minValue, maxValue));
            }
        }
    }

The ``SharedMinMaxComputation`` can be executed exactly the same way as ``MinMaxBlockComputation`` (cf. :ref:`above <MinMaxResult>`), except that the main Java thread has to create the ``target`` variable and to provide it to the individual ``Runnable``:

..  code-block:: java

    public static void main(String[] args) throws InterruptedException {
        float values[] = new float[1024];
        // Fill the array

        SharedMinMaxResult result = SharedMinMaxResult.empty();

        SharedMinMaxComputation c1 = new SharedMinMaxComputation(result, values, 0, values.length / 2);
        SharedMinMaxComputation c2 = new SharedMinMaxComputation(result, values, values.length / 2, values.length);
        Thread t1 = new Thread(c1);
        Thread t2 = new Thread(c2);
        t1.start();
        t2.start();
        t1.join();
        t2.join();

        // No more call to "combine()" here!
        result.print();
    }

Note that it does not make much sense to use a ``Callable<T>`` in this approach. Indeed, because the individual computations directly merge their partial results with a shared variable, they never have to report a result to their caller. However, it still makes much sense to use a thread pool to avoid manipulating the threads directly.

This is why the standard interface ``ExecutorService`` that :ref:`implements thread pools <thread_pools>` accepts not only implementations of the ``Callable<T>`` interface in its ``submit()`` method, but also implementations of the ``Runnable`` interface. In this case, the futures do not convey any result, so ``Future<T>`` must simply be replaced by ``Future``. This is illustrated in the following code:

..  code-block:: java
                 
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        float values[] = new float[1024];
        // Fill the array

        ExecutorService executor = Executors.newFixedThreadPool(4);

        SharedMinMaxResult result = SharedMinMaxResult.empty();

        SharedMinMaxComputation c1 = new SharedMinMaxComputation(result, values, 0, values.length / 2);
        SharedMinMaxComputation c2 = new SharedMinMaxComputation(result, values, values.length / 2, values.length);
        Future future1 = executor.submit(c1);
        Future future2 = executor.submit(c2);

        future1.get();  // The "Future" does not convey any result, so we just wait here
        future2.get();

        executor.shutdown();
    }


Race conditions, mutual exclusion, and monitors
-----------------------------------------------

There is however an important danger in the use of shared variables! Let us consider the following code, in which two threads are incrementing the same counter:

..  code-block:: java

    public class BadCounter {
        private static int counter = 0; // Both threads use the same counter
    
        private static void incrementCounter() {
            counter++;
        }
        
        private static class Counter implements Runnable {
            @Override
            public void run() {
                for (int i = 0; i < 100000; i++) {
                    incrementCounter();
                }
            }
        }
    
        public static void main(String[] args) throws InterruptedException {
            Thread t1 = new Thread(new Counter());
            Thread t2 = new Thread(new Counter());
            t1.start();
            t2.start();
            t1.join();
            t2.join();
            System.out.println(counter);
        }
    }

One would expect that at the end of the computation, the software would print ``200000``: The two threads count from ``0`` to ``100000``, so the result should be ``2 * 100000``. However, if you run this software, the printed result is different between each execution and is never equal to ``200000`` (it is even closer to ``100000`` than to ``200000``). Why so?

This is because of **race conditions**. The line ``counter++`` actually corresponds to 3 low-level instructions:

1. Read the value of the variable ``counter``,

2. Add 1 to the read value,

3. Store the incremented value to the variable ``counter``.

This decomposition implies that the following sequence of low-level instructions can happen:

.. image:: _static/images/part5/race-condition.png
  :width: 320
  :align: center
  :alt: Race condition

In such a sequence, the first thread would overwrite the change made by the second thread to ``counter``: There is an interference between the two threads! Race conditions depend on the way the instructions are dispatched and ordered between the different CPU cores. 

Fortunately, operating systems and thread libraries offer primitives to prevent such race conditions to occur. The idea is to define so-called **critical sections** in the source code, in which at most one thread can be present at any time. In our example, method ``incrementCounter()`` should correspond to a critical section: Thread 1 should have waited for thread 2 to write its result to the shared variable before starting its computation.

In Java, critical sections can be defined by adding the ``synchronized`` keyword to the methods associated with a shared object. Our example can be made correct simply by replacing:

..  code-block:: java

    public void incrementCounter() {
        counter++;
    }

by:

..  code-block:: java

    public synchronized void incrementCounter() {
        counter++;
    }

Intuitively, adding the ``synchronized`` keyword means that a thread entering the method "locks a padlock". As a consequence, any other thread arriving later on cannot enter the method, because the padlock is locked. Once the first thread exits the method, it "unlocks the padlock", leaving the opportunity to one of the waiting threads to enter the method in its turn.

Internally, each Java object is automatically equipped with one padlock that is shared between all the methods of the object. This padlock is referred to as the **monitor** of the object. The process of locking/unlocking the monitor is referred to as **running in mutual exclusion**.

Another reason for using ``synchronized`` consists in ensuring the **visibility** of variable modifications done by one thread to the other threads. For instance, let us consider the following source code:

..  code-block:: java

    public class Visibility {
        private static boolean ready;
        private static String name = "Hello";
        
        private static class MyRunnable implements Runnable {
            public void run() {
                while (!ready) {
                    // Wait for "ready" to become "true"
                }
                System.out.println(name);
            }
        }
        
        public static void main(String[] args) {
            Runnable r = new MyRunnable();
            Thread t = new Thread(r);
            
            t.start();
            name = "World";
            ready = true;
        }
    }

While it may seem obvious that the software will print ``World``, it is in fact possible that it will print ``Hello``, or never terminate at all! The problem is that the Java specification does not guarantee that some thread sees the modifications made by another thread, unless both threads synchronize (for example with a ``synchronized`` statement). In other words, the ``synchronized`` keyword also implies that threads *publish* their changes to other threads.

In the program above, the ``while (!ready)`` loop might go on forever because the modification ``ready = true`` done by the main thread might never become visible to ``MyRunnable``. Even worse, the JVM might decide to swap the statements ``name = "World"`` and ``ready = true`` in the main thread to apply some low-level hardware optimization: The Java specification allows such *reorderings*, as long as the reordering does not change the semantics of the code within *that* thread. As our source code does not enforce the visibility of the changes to ``ready``, the JVM will notice that the reordering has no side-effect on the main thread and might decide to first execute ``ready = true``, which will make ``MyRunnable`` print ``Hello`` instead of ``World``.

The solution is to make sure that the two threads access the shared variables only through ``synchronized`` methods, as in the following source code:

..  code-block:: java
                 
    public class FixedVisibility {
        private static boolean ready;
        private static String name = "Hello";
    
        public static synchronized void start(String newName) {
            ready = true;
            name = newName;
        }
    
        public static synchronized boolean isReady() {
            return ready;
        }
    
        public static synchronized String getName() {
            return name;
        }
        
        private static class MyRunnable implements Runnable {
            public void run() {
                while (!isReady()) {
                    // Wait for "ready" to become "true"
                }
                System.out.println(getName());
            }
        }
        
        public static void main(String[] args) {
            Runnable r = new MyRunnable();
            Thread t = new Thread(r);
            
            t.start();
            start("World");
        }
    }

Summarizing, as a general rule of thumb in this course, make sure that **shared variables are only accessed through synchronized methods**. This will both prevent race conditions and ensure the visibility of the changes.

There is one main caveat associated with the ``synchronized`` keyword: Because ``synchronized`` methods limit the concurrency between threads, they also reduce the overall performance of multithreaded software. In other words, synchronized methods represent a **bottleneck** in the execution of a multithreaded software. For instance, you should try and avoid making a complex computation in a ``synchronized`` method, if possible. Nevertheless, always remember that it is less important to have a program that is *fast* than a program that *works properly*! **Correctness is always more important than speed**.

Finally, note that the ``synchronized`` keyword is only the most basic of the multiple synchronization mechanisms for multithreading that are offered by Java. It is however the most important one, as it allows one to develop thread-safe software without diving too much into the complexity of parallel programming. As such, ``synchronized`` should be mastered by any Java developer. As this course is about the basics of multithreading, more advanced constructions will not be covered.


Shared object for computing the minimum and maximum
---------------------------------------------------

We now apply mutual exclusion to our example of :ref:`computing the minimum and maximum using a shared variable <shared_partial>`. Note that in the version that uses the shared ``result`` variable, the original class ``MinMaxResult`` was replaced by the ``SharedMinMaxResult`` class. The latter class is exactly the same as ``MinMaxResult``, but with the addition of the ``synchronized`` keyword in each of its methods:

..  code-block:: java

    class SharedMinMaxResult {
        private boolean isPresent;
        private float minValue;
        private float maxValue;

        private SharedMinMaxResult(boolean isPresent,
                                   float minValue,
                                   float maxValue) {
            this.isPresent = isPresent;
            this.minValue = minValue;
            this.maxValue = maxValue;
        }

        public SharedMinMaxResult(float minValue,
                                  float maxValue) {
            this(true /* present */, minValue, maxValue);
        }

        static public SharedMinMaxResult empty() {
            return new SharedMinMaxResult(false /* not present */, 0 /* dummy min */, 0 /* dummy max */);
        }

        public synchronized boolean isPresent() {
            return isPresent;
        }

        public synchronized float getMinValue() {
            if (isPresent()) {
                return minValue;
            } else {
                throw new IllegalStateException();
            }
        }

        public synchronized float getMaxValue() {
            if (isPresent()) {
                return maxValue;
            } else {
                throw new IllegalStateException();
            }
        }

        public synchronized void print() {
            if (isPresent()) {
                System.out.println(getMinValue() + " " + getMaxValue());
            } else {
                System.out.println("Empty array");
            }
        }

        public synchronized void combine(SharedMinMaxResult with) {
            if (with.isPresent) {
                if (isPresent) {
                    // Combine the results from two non-empty blocks
                    minValue = Math.min(minValue, with.minValue);
                    maxValue = Math.max(maxValue, with.maxValue);
                } else {
                    // Replace the currently absent result by the provided result
                    isPresent = true;
                    minValue = with.minValue;
                    maxValue = with.maxValue;
                }
            } else {
                // Do nothing if the other result is absent
            }
        }
    }

The addition of ``synchronized`` prevents any race condition between the threads when they combine their partial results with the final result. Also note that the ``synchronized`` methods are only part of the class holding the final result: The threads still make their computation in full parallelism. It is only when the partial results are combined that mutual exclusion occurs, which does not represent a large bottleneck.

The downside of this source code is that the classes ``MinMaxResult`` and ``SharedMinMaxResult`` share almost all of their source code, which is highly redundant. One could avoid this redundancy by wrapping an object of class ``MinMaxResult`` inside a class with the same set of methods, but with the ``synchronized`` keyword added:

..  code-block:: java

    class SharedMinMaxResult {
        private MinMaxResult wrapped;

        private SharedMinMaxResult(MinMaxResult wrapped) {
            this.wrapped = wrapped;
        }

        public SharedMinMaxResult(float minValue,
                                   float maxValue) {
            this(new MinMaxResult(minValue, maxValue));
        }

        static public SharedMinMaxResult empty() {
            return new SharedMinMaxResult(MinMaxResult.empty());
        }

        public synchronized boolean isPresent() {
            return wrapped.isPresent();
        }

        public synchronized float getMinValue() {
            return wrapped.getMinValue();
        }

        public synchronized float getMaxValue() {
            return wrapped.getMaxValue();
        }

        public synchronized void print() {
            wrapped.print();
        }

        public synchronized void combine(SharedMinMaxResult with) {
            wrapped.combine(with.wrapped);
        }
    }


.. _matrix_multiplication:

Application to matrix multiplication
------------------------------------

Linear algebra is a mathematical domain that can greatly benefit from parallel programming. This section gives an example about how multithreading can be used to implement matrix multiplication.

Let us consider the following basic implementation of a matrix in Java:

..  code-block:: java

    public class SynchronizedMatrix {
        private float values[][];
    
        private void checkPosition(int row,
                                   int column) {
            if (row >= getRows() ||
                column >= getColumns()) {
                throw new IllegalArgumentException();
            }
        }
    
        public SynchronizedMatrix(int rows,
                                  int columns) {
            if (rows <= 0 ||
                columns <= 0) {
                throw new IllegalArgumentException();
            } else {
                values = new float[rows][columns];
            }
        }
    
        public synchronized int getRows() {
            return values.length;
        }
    
        public synchronized int getColumns() {
            // "values[0]" is guaranteed to exist, because "columns > 0" in the constructor
            return values[0].length;
        }
    
        public synchronized float getValue(int row,
                                           int column) {
            checkPosition(row, column);
            return values[row][column];
        }
    
        public synchronized void setValue(int row,
                                          int column,
                                          float value) {
            checkPosition(row, column);
            values[row][column] = value;
        }
    }

Note that the ``SynchronizedMatrix`` class has each of its methods tagged with the ``synchronized`` keyword, so it is suitable for use as a shared variable between multiple threads.

We are interested in the task of computing the product :math:`C \in \mathbb{R}^{m\times p}` of two matrices :math:`A \in \mathbb{R}^{m\times n}` and :math:`B \in \mathbb{R}^{n\times p}` of compatible dimensions. Remember the definition of matrix multiplication: :math:`c_{ij} = \sum_{k=1}^{n} a_{ik} b_{kj}`. This definition can directly be turned into a sequential algorithm:

..  code-block:: java

    public static void main(String args[]) {
        SynchronizedMatrix a = new SynchronizedMatrix(..., ...);
        SynchronizedMatrix b = new SynchronizedMatrix(..., ...);
        // Fill a and b

        SynchronizedMatrix c = new SynchronizedMatrix(a.getRows(), b.getColumns());

        for (int row = 0; row < c.getRows(); row++) {
            for (int column = 0; column < c.getColumns(); column++) {
                float accumulator = 0;
                for (int k = 0; k < a.getColumns(); k++) {
                    accumulator += a.getValue(row, k) * b.getValue(k, column);
                }
                c.setValue(row, column, accumulator);
            }
        }
    }

How could we leverage multithreading to speed up this computation? The main observation is that the innermost loop on ``k`` is executed for each entry of :math:`C`. Therefore, a possible solution consists in creating :math:`m\times p` tasks that will be processed by a thread pool, each of these tasks implementing the innermost loop with the accumulator.

A first possible implementation consists in creating a "result" data structure that will store the value of one cell of the matrix product:

..  code-block:: java

    class ProductAtCellResult {
        private int row;
        private int column;
        private float value;

        ProductAtCellResult(int row,
                            int column,
                            float value) {
            this.row = row;
            this.column = column;
            this.value = value;
        }

        public int getRow() {
            return row;
        }

        public int getColumn() {
            return column;
        }

        public float getValue() {
            return value;
        }
    }

We can then implement the ``Callable<T>`` interface to use this data structure in a thread pool:

..  code-block:: java

    static class ComputeProductAtCell implements Callable<ProductAtCellResult> {
        private SynchronizedMatrix a;
        private SynchronizedMatrix b;
        private int row;
        private int column;

        public ComputeProductAtCell(SynchronizedMatrix a,
                                    SynchronizedMatrix b,
                                    int row,
                                    int column) {
            this.a = a;
            this.b = b;
            this.row = row;
            this.column = column;
        }

        public ProductAtCellResult call() {
            float accumulator = 0;
            
            for (int k = 0; k < a.getColumns(); k++) {
                accumulator += a.getValue(row, k) * b.getValue(k, column);
            }

            return new ProductAtCellResult(row, column, accumulator);
        }
    }

The thread pool would then be used as follows:

..  code-block:: java

    public static void main(String args[]) throws ExecutionException, InterruptedException {
        SynchronizedMatrix a = new SynchronizedMatrix(..., ...);
        SynchronizedMatrix b = new SynchronizedMatrix(..., ...);
        // Fill a and b

        ExecutorService executor = Executors.newFixedThreadPool(10);

        Stack<Future<ProductAtCellResult>> pendingComputations = new Stack<>();
            
        for (int row = 0; row < a.getRows(); row++) {
            for (int column = 0; column < b.getColumns(); column++) {
                pendingComputations.add(executor.submit(new ComputeProductAtCell(a, b, row, column)));
            }
        }

        SynchronizedMatrix c = new SynchronizedMatrix(a.getRows(), b.getColumns());
        
        while (!pendingComputations.empty()) {
            Future<ProductAtCellResult> future = pendingComputations.pop();
            c.setValue(future.get().getRow(), future.get().getColumn(), future.get().getValue());
        }

        executor.shutdown();
    }
    
Note that this implementation would also work fine if there were no ``synchronized`` keyword in the class implementing matrices, because the threads do not apply modifications to shared variables. Even though this solution works fine, it is demanding in terms of memory. Indeed, the row, column, and value of each cell in the product will first be stored in a separate data structure (the stack of futures referring to ``ProductAtCellResult`` objects), before being copied onto the target matrix ``c``. Couldn't the results be directly written into ``c``?

The answer is obviously "yes": Thanks to the fact that the ``SynchronizedMatrix`` implements the ``synchronized`` keyword, it is thread-safe and it can be used as a shared variable into which the different threads can directly write their results.

According to this discussion, here is a second possible implementation that replaces ``Callable<ProductAtCellResult>`` by a set of ``Runnable`` objects, each of those objects writing one cell of the target matrix:

..  code-block:: java

    static class StoreProductAtCell implements Runnable {
        private SynchronizedMatrix a;
        private SynchronizedMatrix b;
        private SynchronizedMatrix c;
        private int row;
        private int column;

        public StoreProductAtCell(SynchronizedMatrix a,
                                  SynchronizedMatrix b,
                                  SynchronizedMatrix c,
                                  int row,
                                  int column) {
            this.a = a;
            this.b = b;
            this.c = c;
            this.row = row;
            this.column = column;
        }

        public void run() {
            float accumulator = 0;
            
            for (int k = 0; k < a.getColumns(); k++) {
                accumulator += a.getValue(row, k) * b.getValue(k, column);
            }

            c.setValue(row, column, accumulator);
        }
    }

Thanks to the ``StoreProductAtCell`` class, the matrix multiplication can be computed by a thread pool as follows:

..  code-block:: java

    public static void main(String args[]) throws ExecutionException, InterruptedException {
        SynchronizedMatrix a = new SynchronizedMatrix(..., ...);
        SynchronizedMatrix b = new SynchronizedMatrix(..., ...);
        // Fill a and b

        ExecutorService executor = Executors.newFixedThreadPool(10);

        Stack<Future> pendingComputations = new Stack<>();
            
        SynchronizedMatrix c = new SynchronizedMatrix(a.getRows(), b.getColumns());
        
        for (int row = 0; row < a.getRows(); row++) {
            for (int column = 0; column < b.getColumns(); column++) {
                pendingComputations.add(executor.submit(new StoreProductAtCell(a, b, c, row, column)));
            }
        }

        while (!pendingComputations.empty()) {
            Future future = pendingComputations.pop();
            future.get();
        }

        executor.shutdown();
    }

Note that in the specific example of matrix multiplication, the solution based on ``Runnable`` is both simpler and more memory efficient, as it does not require the use of an intermediate class such as ``ProductAtCellResult`` to store the partial results before writing them onto the target matrix.

.. admonition:: Remark
   :class: remark

   In practice, the parallel implementation of matrix multiplication proposed above will probably have really bad performance, possibly even worse than a purely sequential algorithm. Indeed, this implementation totally neglects the `processor cache <https://en.wikipedia.org/wiki/Cache_(computing)>`_: Because the various threads work on different areas of the matrices, the CPU will continuously have to access the RAM, which slows down the computation. Real software libraries for optimized linear algebra implement algorithms that feature **locality** in their patterns of access to the RAM. Because CPU cores include a cache memory that is much faster than the RAM, exploiting locality can dramatically increase the performance of an algorithm. Such optimized algorithms will typically leverage `block matrix multiplication <https://en.wikipedia.org/wiki/Block_matrix#Block_matrix_multiplication>`_ and `SIMD instructions <https://fr.wikipedia.org/wiki/Single_instruction_multiple_data>`_, in addition to multithreading.
