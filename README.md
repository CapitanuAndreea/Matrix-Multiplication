# Matrix Multiplication in Assembly
**"MatrixMul.s"** generates the adjacency matrix for a given input and outputs it.

**"Distances.s"** calculates the paths of distance n, by multiplying the adjacency matrix n times. 
                  The space needed for the auxiliary matrix calculated is allocated with **mmap2** and deallocated with **munmap**.
