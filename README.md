# Lazy priority queue

Lazy priority queue is a pure Ruby priority queue which implements a lazy binomial heap.
It supports the change priority operation, being suitable for algorithms like Dijkstra's shortest path and Prim's minimum spanning tree.
It can be instantiated as a min-priority queue as well as a max-priority queue.

## Installation

With RubyGems:

```bash
$ gem install 'lazy_priority_queue'
```

## Usage

First instantiate a priority queue.

```ruby
require 'lazy_priority_queue'

queue = MinPriorityQueue.new
```

There is also a `MaxPriorityQueue` class.

Use `push(element, priority)` to insert an element with a given priority to the queue.

```ruby
queue.push :a, 1  # => :a
queue.push :b, 2  # => :b
queue.push :c, 3  # => :c
```

`min()` will retrieve the minimum priority element without removing it from the queue;
analogously, use `max()` in case of a max-priority queue.

```ruby
queue.min  # => :a
```

`decrease_key(element, new_priority)` decreases an element's priority (trying to increase it will raise
an error). For a max-priority queue, `increase_key(element, new_priority)` modifies a priority (but will
not be able to decrease it).

```ruby
queue.decrease_key :c, 0  # => :c
```

Use `pop()` to extract the minimum priority element from the queue; or maximum, given a max-priority
queue.

```ruby
queue.pop  # => :c
queue.pop  # => :a
queue.pop  # => :b
```

Finally, there are these additional instance methods: `delete(element)`, `size` and `empty?`.

## Complexity

A lazy binomial heap has these times:

Operation | Time
--------- | ----
enqueue | O(1)
peek | O(1)
change_priority | O(log n)
dequeue | O(log n) amortized
delete | O(log n) amortized

It is worth noting that a Fibonacci heap has better amortized time for change priority, O(1) namely, theoretically providing better performance for priority queues.
On the other side, nodes in this kind of heap stores more pointers to other nodes than their binomial heap fellows, making it a more memory consuming data structure.
Hence in practice the time spent allocating memory drawbacks Fibonacci heap behind binomial heap as seen in the next section.

## Comparison

All the following libraries underwent a stress test of 1,000,000 operations: starting with 1,000 pushes/0 pops, following 999 pushes/1 pop, and so on till 0 pushes/1000 pops.
See [test/performance.rb](blob/master/test/performance.rb) for details.

library | user | system | total | real
------- | ---- | -----  | ----- | ----
Lazy priority queue | 21.53 | 0.10 | 21.63 | 21.66
Algorithms | 52.95 | 0.11 | 53.06 | 53.15
PQueue | 712.55 | 10.67 | 723.22 | 724.96
PriorityQueueCxx | 1.69 | 0.00 | 1.69 | 1.69
PriorityQueue (supertinou) | 4.33 | 0.01 | 4.34 | 4.33
PriorityQueue (ninjudd) | - | - | - | - |

**Lazy priority queue** is recommended if you are seeking a pure Ruby implementation of a priority queue capable (or not) of
modifying the priority of its elements. Otherwise, in the field of low-level extended Ruby, supertinou's **PriorityQueue**
is the right choice; and if you do not need changing priorities at all, **PriorityQueueCxx** is the one.

### [Algorithms (0.6.1)](https://github.com/kanwei/algorithms)

*Pure Ruby* | *Fibonacci heap* | *Elements are identified by their priority: change priority is not supported except through a hack.*

Lazy priority queue —which is based on a lazy binomial heap— performed 2 times better than Algorithms.
Issue [kanwei/algorithms#23](https://github.com/kanwei/algorithms/issues/23) motivated the writing of this library.


### [PQueue (2.1.0)](https://github.com/rubyworks/pqueue)

*Pure Ruby* | *Sorted array* | *Does not support change priority.*

PQueue was not as fast as the others. Anyway, it is a really simple implementation
that would sort a reduced number of elements satisfactorily.


### [PriorityQueueCxx (0.3.4)](https://github.com/boborbt/priority_queue_cxx)

*C++ extension* | *Sorted array* | *Does not support change priority.*

PriorityQueueCxx, wrapping the C++ standard library implementation,
is the fastest priority queue for Ruby out there.


### [PriorityQueue (supertinou) (0.1.2)](https://github.com/supertinou/priority-queue)

*C extension* | *Fibonacci heap* | *Supports change priority.*

supertinou/PriorityQueue outperforms Lazy priority queue.


### [PriorityQueue (ninjudd) (0.2.0)](https://github.com/ninjudd/priority_queue)

*Pure Ruby* | *Unsorted array* | *Does not support change priority.*

ninjudd/PriorityQueue did not complete the task in a reasonable amount of time.


## Acknowledgments

These two lectures on data structures were helpful for writing this library:
* http://web.stanford.edu/class/cs166/lectures/06/Slides06.pdf
* http://web.stanford.edu/class/cs166/lectures/07/Slides07.pdf

## Licence

BSD 2-Clause License

Copyright (c) 2016, Matías Battocchia

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
