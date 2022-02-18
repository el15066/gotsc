// Copyright 2016 David Terei.  All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// See https://www.felixcloutier.com/x86/rdtscp

#include "textflag.h"

// func BenchStart() uint64
TEXT ·BenchStart(SB),NOSPLIT,$0-8
	// No LFENCE: The RDTSCP instruction is not a serializing instruction, but it does wait until all previous instructions have executed and all previous loads are globally visible,
	// MFENCE  // ... but it does not wait for previous stores to be globally visible (in our case we don't care, uncomment if you do)
	RDTSCP
	LFENCE     // ... and subsequent instructions may begin execution before the read operation is performed. (so we need LFENCE)
	SHLQ	$32, DX
	ADDQ	DX, AX
	MOVQ	AX, ret+0(FP)
	RET

// func BenchEnd() uint64
TEXT ·BenchEnd(SB),NOSPLIT,$0-8
	RDTSCP
	SHLQ	$32, DX
	ADDQ	DX, AX
	MOVQ	AX, ret+0(FP)
	RET
