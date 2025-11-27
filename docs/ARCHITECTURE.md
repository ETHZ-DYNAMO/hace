# Architecture Overview

This implementation of the HACE algorithm is purposefully
structured in direct correspondence with the accompaning Paper.
The hace algorithm is grouped into multiple parts.

1. From RTL to Assignment Graph
2. Rebuilding the Finite-State Machine
3. Reconstructing the CDFG

which correspond to the three parts of section 3 of the paper. In particular, each python code in the format ``hace/Step_<A>_<B>.py`` corresponds to a different step of this section where A is the subsection and B is the Step in that subsection.

## Usage of Types

There are a couple of peculiar things in this code base that need to be outlined for
better understanding.

1. The use of subclasses as Tagged Union kind of objects
2. The use of decorators to enforce the algorithms pre/post conditions.


### Subclasses as Tagged Unions
In order to incapsulate graph information in the most clear and bug-free method we introduced these two key features:

1. Add helper procedures which carry out common operations.
	This avoids, hopefully, making the same silly common mistakes
	of e.g. numbering nodes wrong.
2. Encapsulate state in a Graph object, which contains all associated data.
	So that associated data, which does not neatly fit on nodes can be easily
	kept track of.

To achive this we use a very shallow Object hierarchy as a poor mans Tagged Union.
The Top level in ``hace/type_info.py`` is the class ``BaseGraph``.
It contains everything that is common to all variants of graphs needed
in the HACE algorithm.
- a Networkx Graph
- a set of nodes that need to remain in the graph
- the name of the original rtl module
- the input and output nodes of the rtl module

This Basegraph is never meant to be directly instantiated, but only initialized
as the ``super()`` of an actually valid Tagged Union member.

For example the class ``AssignmentGraph(BaseGraph)`` adds which nodes are 
control io. This is needed in the first few steps of the algorithm.

The subtyping relation ship allows us to write code that works on
''any'' graph, given it is of base class ``BaseGraph`` and do 'some' meaningful
operations with it. (for example, generate a debug graphviz represenation)
The ``isinstance(graph, X)`` syntax allows us to then differentiate further what
actual Union Variant ``graph`` is.


### The use of decorators to enforce pre and post conditions of the Algorithm

The algorithm uses two decorators to run code before/after each
Stage.
- ``check_invariants`` checks the invariants, pre and post conditions, 
	which are detailed in ``hace/invariants.py``
- ``visualize_graph`` produces debug output when ``--debug`` is passed to 
	the default flow script


The invariants are divided per Subtype of the ``BaseGraph`` class,
as for certain Graphs only some invariants are important/valid.
For example the subtype ``SplitCFDFGraph`` has the invariant that
all nodes are either in the Control Flow or the Data Flow Subgraph.
This is checked and upon a failure an errorstate serialization of the graph 
is produced so that a gitlab issue can be opened.

In normal execution these should never fire, but given that this is research code
some edgecases might not have been caught during the developement.
It can also be the case that we cannot detect whether some input
is wellformed with regards to the Assumptions that HACE makes. If these are
violated the result is a similar invariant error.

Admittedly this is not a great user experience, but this can be improved 
in future iterations.


## Mypy

There was an attempt made at incorporating mypy into the validation of the HACE
algorithm implementation, but mypy's errors are so unstable between machines that
this has been partially dropped.
Things that 'passed' on one machine do not pass on another machine with the same
python version, networkx version etc...

We will add a more clean mypy integration in the future.
