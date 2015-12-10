package main

import (
	"crypto/sha512"
	"encoding/hex"
	"fmt"
	"math/big"
	"os"
	"strings"
)

func main() {
	if len(os.Args) < 2 {
		return
	}

	p := os.Args[1]

	i := big.NewInt(0)
	o := big.NewInt(1)
	h := sha512.New()

	for true {
		i = i.Add(i, o)

		m := i.Bytes()
		m = append(m, make([]byte, 64-len(m))...)

		h.Write(m[:])

		c := hex.EncodeToString(h.Sum(nil))

		if strings.HasPrefix(string(c), p) {
			fmt.Println(hex.EncodeToString(m))
			fmt.Println(c)
			return
		}
	}
}
