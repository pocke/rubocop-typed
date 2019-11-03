arr = [1, 2, 3]

elm = arr.find {|x| x == 1}

# unnecessary safe navigation operator
arr&.first

# It is necessary
elm&.chr

