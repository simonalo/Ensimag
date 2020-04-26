# TAG = mulhsu

	.text

	li x1, 0 
	li x2, 0 
    mulhsu x31, x1, x2

	li x1, 0x00000001
	li x2, 0x00000001
    mulhsu x31, x2, x1

	li x1, 0x00000003
	li x2, 0x00000002
    mulhsu x31, x2, x1

	li x1, 0xC0000000
	li x2, 0x00000002
    mulhsu x31, x1, x2


	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000001 
	# 00000006
	# 80000000
	# pout_end
