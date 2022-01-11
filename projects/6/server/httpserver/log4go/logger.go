package log4go

import (
	"github.com/bright1208/monk/httpserver/token"
	"github.com/lestrrat-go/file-rotatelogs"
	log "github.com/sirupsen/logrus"
	"net/http"
	"sync"

	"time"
)

var (
	gLogLevel int
	gLogFile  string
)

const (
	DefRotationTime = time.Hour
	DefMaxAge       = time.Hour * 24 * 30
)

var gWriter *rotatelogs.RotateLogs

var glogPool *sync.Pool

func init() {
	glogPool = &sync.Pool{
		New: func() interface{} {
			return NewLog()
		},
	}
}

func FreeLogger() {

}

func InitLog(aLogFile string, aLogLevel int) {
	gLogFile = aLogFile
	gLogLevel = aLogLevel
	gWriter, _ = rotatelogs.New(
		gLogFile+".%Y%m%d%H",
		rotatelogs.WithLinkName(gLogFile),
		rotatelogs.WithMaxAge(DefMaxAge),
		rotatelogs.WithRotationTime(DefRotationTime),
	)
	log.SetOutput(gWriter)
	log.SetLevel(log.Level(gLogLevel))
}

type ILog4go interface {
	Trace(args ...interface{})
	Debug(args ...interface{})
	Info(args ...interface{})
	Warn(args ...interface{})
	Error(args ...interface{})
	Fatal(args ...interface{})
	Panic(args ...interface{})
}

type Test struct {
	log   *log.Logger
	entry *log.Entry
}

func NewHttpLog(r *http.Request) ILog4go {
	logger := log.New()
	logger.SetOutput(gWriter)
	hook := &lineHook{Field: "code", Skip: 8}
	logger.AddHook(hook)
	logger.SetLevel(log.Level(gLogLevel))

	return logger.WithFields(log.Fields{
		"token": token.GenNextToken(),
		"host":  r.Host,
	})
}

func NewLog() ILog4go {
	logger := log.New()
	hook := &lineHook{Field: "code", Skip: 9}
	logger.AddHook(hook)
	logger.SetOutput(gWriter)
	logger.SetLevel(log.Level(gLogLevel))

	return logger
}
