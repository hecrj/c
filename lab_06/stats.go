package main

import (
	"crypto/sha512"
	"encoding/hex"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func differences(a []byte, b []byte) (bits int, pos []string) {
	bits = 0
	pos = make([]string, 0)

	for i := 0; i < len(a); i++ {
		for j := 0; j < 8; j++ {
			if a[i]&(1<<uint(j)) != b[i]&(1<<uint(j)) {
				bits++
				pos = append(pos, strconv.Itoa(i*8+j))
			}
		}
	}

	return
}

func main() {
	if len(os.Args) < 2 {
		return
	}

	s := os.Args[1]

	m, _ := hex.DecodeString(s)

	h := sha512.New()
	h.Write(m)

	o := h.Sum(nil)

	fmt.Println("input_bit_changed", "hash_num_bits_changed", "hash_pos_bits_changed")
	for i := 0; i < 64; i++ {
		for j := 0; j < 8; j++ {
			var mc [64]byte
			copy(mc[:], m)

			mc[i] ^= 1 << uint(j)

			h.Reset()
			h.Write(mc[:])

			bits, pos := differences(o, h.Sum(nil))
			fmt.Println(i*8+j, bits, strings.Join(pos, ","))
		}
	}
}
