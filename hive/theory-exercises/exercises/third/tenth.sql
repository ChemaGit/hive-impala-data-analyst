/*
You are given a table, BST, containing two columns: N and P,
where N represents the value of a node in Binary Tree, and P is the parent of N.

Column   Type
N 	Integer
P	Integer

Write a query to find the node type of Binary Tree ordered 
by the value of the node. Output one of the following for each node:

Root: If node is root node.
Leaf: If node is leaf node.
Inner: If node is neither root nor leaf node.

Sample input

N	P
1	2
3	2
6	8
9	8
2	5
8	5
5	Null

Sample Output

1 Leaf
2 Inner
3 Leaf
5 Root
6 Leaf
8 Inner
9 Leaf

Explanation

The Binary Tree below illustrates the sample:

			            5
		               / \
                      /   \
                     2     8
                    / \   / \
                   1   3 6   9
*/
SELECT t.node, t.roll
FROM
(SELECT node, 'Root' AS roll
FROM binary_tree
WHERE parent is null
UNION
SELECT node, 'Leaf' AS roll
FROM binary_tree
WHERE node NOT IN(SELECT parent FROM binary_tree WHERE parent IS NOT null)
UNION
SELECT node, 'Inner' AS roll
FROM binary_tree
WHERE node in(SELECT parent FROM binary_tree WHERE parent IS NOT null) AND
      node not in(SELECT node FROM binary_tree WHERE parent is null)) AS t
ORDER BY node;