def selection_sort(a):
  n = len(a)
  for i in range(n - 1):
      Min_idx = i
      for j in range(i + 1, n):
          if a[j] < a[min_idx]:
              min_idx = j
      if min_idx != i:
              a[i], a[min_idx] = a[min_idx], a[i]
