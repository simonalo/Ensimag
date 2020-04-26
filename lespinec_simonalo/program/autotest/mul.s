# TAG = mul

	.text

	li x1, 0 
	li x2, 0 
    mul x31, x1, x2

	li x1, 0x00000001
	li x2, 0x00000001
    mul x31, x2, x1

	li x1, 0x00000003
	li x2, 0x00000002
    mul x31, x2, x1

	li x1, 0xF0000000
	li x2, 0x00000002
    mul x31, x2, x1

	# max_cycle 500
	# pout_start
	# 00000000 
	# 00000001 
	# 00000006 
	# E0000000
	# pout_end
