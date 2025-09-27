# LeetCode Problem 448. Find All Numbers Disappeared in an Array
# Link:https://leetcode.com/problems/find-all-numbers-disappeared-in-an-array/description/

# Given an array nums of n integers where nums[i] is in the range [1, n], return an array of all the integers in the range [1, n] that do not appear in nums.

# Example 1:

# Input: nums = [4,3,2,7,8,2,3,1]
# Output: [5,6]
# Example 2:

# Input: nums = [1,1]
# Output: [2]
 

# Constraints:

# n == nums.length
# 1 <= n <= 105
# 1 <= nums[i] <= n
 

# Follow up: Could you do it without extra space and in O(n) runtime? You may assume the returned list does not count as extra space.

class Solution(object):
    def findDisappearedNumbers(self, nums):
        N = len(nums)
        cnt = [0] * (N + 1)
        for num in nums:
            cnt[num] = 1
        ans = []
        for i in range(1, N + 1):
            if cnt[i] == 0:
                ans.append(i)
        return ans
        