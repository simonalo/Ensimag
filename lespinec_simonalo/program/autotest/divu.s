# TAG = divu

	.text

	li x1, 0x00000001
	li x2, 0x00000001
    divu x31, x2, x1

	li x1, 0x80000000
	li x2, 0x00000002
    divu x31, x1, x2

	li x1, 0x80000000
	li x2, 0x80000000
    divu x31, x1, x2

	# max_cycle 500
	# pout_start
	# 00000001 
	# 40000000 
	# 00000001
	# pout_end
