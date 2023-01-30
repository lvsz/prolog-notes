# 5. Difference Lists

- Elegant solution to reaching the end of a list.
- Arises as a side-effect of unification.
- A **_difference list_** is a list which is expressed as the difference between two lists.
  - Example: the ordinary list  
    `[a,b,c]`  
    might be expressed as  
    `[a,b,c,d,e]-[d,e]`  
    or as  
    `[a,b,c,a,b,c]-[a,b,c]`
- The clever part comes when we use variables in d-lists.
  - Example: `[a,b,c|X]-X`
  - This is the most general way to write a d-list containing elemenrs `a`, `b`, and `c`.
  - Aside from access to the head, we now also have access to the tail of the list by unifying with `X`.
  - _For this to be a proper difference list, the must only be one variable!_
- Consequently, we can write `append/3` as:

  - ```prolog
     % append/3 for d-lists
     append( X-Y, Y-Z, X-Z ).
    ```

  - So an _O(n)_ operation now becomes a constant-time operation!
