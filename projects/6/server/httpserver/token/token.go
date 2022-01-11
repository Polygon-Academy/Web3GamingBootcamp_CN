/**
 * @author chengliang
 * @date 2021/9/13 16:06
 * @brief
 *
 **/

package token

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

var gLocker sync.Mutex
var gTokenGenerator *TTokenGenerator

func GenNextToken() string {
	gLocker.Lock()
	defer gLocker.Unlock()
	if gTokenGenerator == nil {
		gTokenGenerator = NewTokenGenerator()
	}
	return gTokenGenerator.NextToken()
}

func NewTokenGenerator() *TTokenGenerator {
	return &TTokenGenerator{
		rand: rand.New(rand.NewSource(time.Now().Unix())),
	}
}


type TTokenGenerator struct {
	rand *rand.Rand
}

func (this *TTokenGenerator) NextToken()string  {
	now := time.Now()
	r := this.rand.Intn(9999999999)
	return fmt.Sprintf("%s%03d%d", now.Format("20060102150405"), now.Nanosecond()/1e6, r)
}