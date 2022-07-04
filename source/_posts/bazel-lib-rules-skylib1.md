---
title: 一步步学写Bazel lib&rules （1） - Bazel官方基础库 （workinprocess）
readmore: true
date: 2022-07-04 18:51:43
categories: Devops
tags:
- Bazel
---

```python
"""Skylib module containing functions that operate on collections."""

def _after_each(separator, iterable):
    """Inserts `separator` after each item in `iterable`.
    Args:
      separator: The value to insert after each item in `iterable`.
      iterable: The list into which to intersperse the separator.
    Returns:
      A new list with `separator` after each item in `iterable`.
    """
    result = []
    for x in iterable:
        result.append(x)
        result.append(separator)

    return result

def _before_each(separator, iterable):
    """Inserts `separator` before each item in `iterable`.
    Args:
      separator: The value to insert before each item in `iterable`.
      iterable: The list into which to intersperse the separator.
    Returns:
      A new list with `separator` before each item in `iterable`.
    """
    result = []
    for x in iterable:
        result.append(separator)
        result.append(x)

    return result

def _uniq(iterable):
    """Returns a list of unique elements in `iterable`.
    Requires all the elements to be hashable.
    Args:
      iterable: An iterable to filter.
    Returns:
      A new list with all unique elements from `iterable`.
    """
    unique_elements = {element: None for element in iterable}

    # list() used here for python3 compatibility.
    # TODO(bazel-team): Remove when testing frameworks no longer require python compatibility.
    return list(unique_elements.keys())

collections = struct(
    after_each = _after_each,
    before_each = _before_each,
    uniq = _uniq,
)
```

```python
"""Skylib module containing shell utility functions."""

def _array_literal(iterable):
    """Creates a string from a sequence that can be used as a shell array.
    For example, `shell.array_literal(["a", "b", "c"])` would return the string
    `("a" "b" "c")`, which can be used in a shell script wherever an array
    literal is needed.
    Note that all elements in the array are quoted (using `shell.quote`) for
    safety, even if they do not need to be.
    Args:
      iterable: A sequence of elements. Elements that are not strings will be
          converted to strings first, by calling `str()`.
    Returns:
      A string that represents the sequence as a shell array; that is,
      parentheses containing the quoted elements.
    """
    return "(" + " ".join([_quote(str(i)) for i in iterable]) + ")"

def _quote(s):
    """Quotes the given string for use in a shell command.
    This function quotes the given string (in case it contains spaces or other
    shell metacharacters.)
    Args:
      s: The string to quote.
    Returns:
      A quoted version of the string that can be passed to a shell command.
    """
    return "'" + s.replace("'", "'\\''") + "'"

shell = struct(
    array_literal = _array_literal,
    quote = _quote,
)
```

> 本文章为付费文章，可在微信公众号查看全文（workinprocess）