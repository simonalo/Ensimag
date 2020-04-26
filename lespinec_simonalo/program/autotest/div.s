# TAG = div

	.text

	li x1, 0x00000001
	li x2, 0x00000001
    mul x31, x2, x1

	li x1, 0x80000000
	li x2, 0x00000002
    mul x31, x2, x1

	li x1, 0x80000000
	li x2, 0x80000000
    mul x31, x2, x1

	# max_cycle 500
	# pout_start
	# 00000001 
	# C0000000 
	# 00000001
	# pout_end
