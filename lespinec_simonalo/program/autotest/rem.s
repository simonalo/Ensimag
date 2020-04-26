# TAG = rem

	.text

	li x1, 0x00000001
	li x2, 0x00000001
    rem x31, x1, x2

    li x1, 0x00000001
	li x2, 0x00000000
    rem x31, x1, x2

    li x1, 0x00000004
	li x2, 0x00000002
    rem x31, x1, x2

	li x1, 0x00000005
	li x2, 0x00000003
    rem x31, x1, x2

	# max_cycle 500
	# pout_start
	# 00000000
	# 00000001
	# 00000000 
	# 00000002
	# pout_end
