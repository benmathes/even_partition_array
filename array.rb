class Array
 
  # given an array of arrays, splits into num_columns buckets of buckets, with
  # an as-even-as-possible partitioning based on 2nd-level size, preserving order.
  # e.g. [[1,2], [3,4], [4,5,6,7,8,9], [1,2], [3,4]].even_partition_by_size(3)
  #   => [
  #        [[1,2], [3,4]],
  #        [[4,5,6,7,8,9]],
  #        [[1,2], [3,4]]
  #      ]
  # if a block is given, the argument is one of the arrays, e.g. [1,2], and [3,4],
  # and the block return the "size" of one of the elements. default is .size
  # e.g. [[1,2], [3,4], [4,5,6,7,8,9], [3,2], [3,5]].even_partition_by_size(3){|a| a.select(&:even?).size }
  def even_partition_by_size(num_partitions)
    total_deep_size = self.map{|a| (block_given? ? yield(a) : a.try(:size)) || 0 }.inject(&:+)
    ideal_partition = (total_deep_size.to_f / num_partitions).ceil

    partitioned = []
    i = 0
    partitioned[i] ||= []
    p_i_size = 0

    self.each do |array|
      size_of_array = (block_given? ? yield(array) : array.size) || 0
      # if this sub-array belongs in this partition or the next.
      if (size_of_array.to_f/2).ceil + p_i_size > ideal_partition && i+1 < num_partitions
        i += 1
        p_i_size = 0
        partitioned[i] = []
      end
      partitioned[i] << array
      p_i_size += size_of_array
    end
    partitioned
  end
end
