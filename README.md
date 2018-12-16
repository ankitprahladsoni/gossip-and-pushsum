# Project 2 – Gossip Simulator
**COP5615 - Distributed Operating Systems Principles**

---
## Group Info

* [Ankit Soni- 8761-9158](http://github.com/ankitprahladsoni)
* [Kumar Kunal- 5100-5964](http://github.com/kunal4892)

---

## What is working?  

* All the topologies are working as expected.

* The least time-consuming algorithm turns out to be random 2D. It converges faster than all others for higher number of nodes. The maximum number of nodes that converged without any failures: 3000.

* The above mentioned number is bound by constraints imposed by system limitations because the time taken to run is quite low: 7.85 seconds(averaged over 10 runs). The system runs 3000 processes at a time with the given implementation in place and considerable sluggishness in the system is observed. If run on a system with better configuration, it should be able to churn more number of nodes.

* The line topology works the slowest in gossip. It was hard to converge the line topology in case of pushsum but the convergence times were lesser than 3D grid, Imperfect Line and Torus. The reason behind it lies in the implementation.  As a means of failure control in line topology, after convergence of its neighbours the isolated actor sends values to itself and converges on its own. This is essential because then otherwise the entire system would've been left in a halted/hanging state. 

* The imperfect line topology in this project has 3 neighbours instead of two.
Two adjacent ones and one random. Interestingly, we found that it works better than most other topologies beacuse of a hint of randomization. It works even better than the fully connected system for both gossip and pushsum.

* Toroid topology works mostly like the fully connected topology, but for pushsum it strangely takes a lot of time to converge. We decided to make the grid length optimal by always taking a square 2D for Toroid to extract the least possible time for convergence.

---

## Instructions:

* The input provided (as command line to the program will be of the form:

>$ mix run project2.exs numNodes topology algorithm

Topologies: "full", "line", "3D", "torus", "impLine", "rand2D"  
Algorithms: "gossip", "pushsum"

---

## Result of running:

>$ *mix run project2.exs 1000 rand2D gossip*    
PID<0.2038.0> Converged, remaining: 1000  
PID<0.2086.0> Converged, remaining: 999  
.  
.  
.   
PID<0.2104.0> Converged, remaining: 2   
PID<0.1506.0> Converged, remaining: 1    
Time taken to achieve convergence: 375 milliseconds    
In case of failures, you should see:   
PID<0.2004.0> Convergence failed for a node, remaining 1   
 ---
 

