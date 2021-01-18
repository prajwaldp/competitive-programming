# Observations
# 1. Define T(i, j) as the maximum number of points you can get by removing boxes[i..j]
# 2. T(i, i) = 1, points obtained by removing 1 box
# 3. T(i, i - 1) = 0, when there are no boxes left
#
# Suppose you remove just boxes[i], max points = 1 + T(i + 1, j)
# Suppose you want to group boxes[i] with boxes[m] (as boxes[i] = boxes[m]),
# max points = T(i + 1, m - 1) + max points from concatenation_of(boxes[i], boxes[m, j])
# Important Observation: boxes[m, j] is a not a self-contained sub-problem, i.e
# its solution depends on extra information external to the sub-problem
# The extra information is the number of boxes of the same color to the left of boxes[i]
#
# Re-framing the problem to include the extra information
# T(i, j, k) is the maximum number of points you can get by removing boxes[i..j]
# with k boxes to the left of boxes[i..j] with the same color as boxes[i]
#
# Base cases
# ==========
# T(i, i - 1, k) = 0
# T(i, i, k) = (k + 1) * (k + 1)
#
# Recurrence relation
# ===================
# Option 1. Removes boxes[i]
# Max points = (k + 1) * (k + 1) + T(i + 1, j, 0)
#
# Option 2. Attach boxes[i] with boxes[m]
# Max points =
#   T(i + 1, m - 1, 0)
# + T(m, j, k + 1)
#
# But there could be multiple boxes of the same color as boxes[i] in boxes[i..j]
# Therefore, final ans for option 2 =
#   max(T(i + 1, m - 1, 0) + T(m, j, k + 1) for m in i..j if boxes[i] == boxes[m])

# TLE on Leetcode
def top_down_impl(boxes)
  n = boxes.length
  dp = Array.new(n) { Array.new(n) { Array.new(n, 0) } }
  top_down_impl_sub(boxes, 0, n - 1, 0, dp)
end

def top_down_impl_sub(boxes, i, j, k, dp)
  return 0 if i > j
  return dp[i][j][k] if dp[i][j][k] > 0

  while i + 1 <= j && boxes[i] == boxes[i + 1]
    i += 1
    k += 1
  end

  res = (k + 1) * (k + 1) + top_down_impl_sub(boxes, i + 1, j, 0, dp)

  (i + 1).upto(j).each do |m|
    res = [
      res,
      top_down_impl_sub(boxes, i + 1, m - 1, 0, dp) + top_down_impl_sub(boxes, m, j, k + 1, dp)
    ].max if boxes[i] == boxes[m]
  end

  dp[i][j][k] = res
end

# TLE on Leetcode (check Python implementation for an AC version)
def bottom_up_impl(boxes)
  n = boxes.length
  dp = Array.new(n) { Array.new(n) { Array.new(n, 0) } }

  n.times do |i|
    0.upto(i) do |k|
      dp[i][i][k] = (k + 1) * (k + 1)
    end
  end

  1.upto(n - 1) do |l|
    l.upto(n - 1) do |j|
      i = j - l

      0.upto(i) do |k|
        res = (k + 1) * (k + 1) + dp[i + 1][j][0]

        (i + 1).upto(j) do |m|
          res = [
            res,
            dp[i + 1][m - 1][0] + dp[m][j][k + 1]
          ] if boxes[i] == boxes[m]
        end

        dp[i][j][k] = res
      end
    end
  end

  n == 0 ? 0 : dp[0][n - 1][0]
end

def remove_boxes(boxes)
  top_down_impl(boxes)
end
