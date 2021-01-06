class Solution {
  public int mySqrt(int x) {
    if (x == 1) {
      return 1;
    }

    int lo = 0;
    int hi = x / 2 + 1;

    while (lo < hi) {
      int mid = lo + (hi - lo) / 2;
      // mid can overflow an integer
      if ((long)mid * mid > x) {
        hi = mid;
      } else {
        lo = mid + 1;
      }
    }

    return lo - 1;
  }
}