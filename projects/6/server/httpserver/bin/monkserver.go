/**
 * @author chengliang
 * @date 2021/9/8 20:36
 * @brief
 *
 **/

package main

import (
	"flag"
	"fmt"
	"github.com/bright1208/monk/httpserver"
	"github.com/bright1208/monk/httpserver/log4go"
	"log"
	"os"
	"os/signal"
	"path"
	"runtime/debug"
	"syscall"
)

var (
	COMPILE_TIME string
	PLATFORM     string
)

func version() {
	fmt.Println("Time: " + COMPILE_TIME)
	fmt.Println("Platform: " + PLATFORM)
}

func main() {
	//panic处理
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf(" recover:%v, stack:\n%s\n", r, debug.Stack())
		}
	}()

	// package 信息
	if len(os.Args) >= 2 && os.Args[1] == "version" {
		version()
		return
	}

	var host = flag.String("host", "0.0.0.0", "host")
	var port = flag.Int("post", 4001, "port")
	var imgDomain = flag.String("imgdomain", "https://img.battlemonk.io", "conf path")
	var confPath = flag.String("confpath", "bin/conf", "conf path")
	var logPath = flag.String("logpath", "bin/log", "log path")
	var logLevel = flag.Int("loglevel", 6, "log level")

	flag.Parse()

	config := &httpserver.GConfig
	config.Host = *host
	config.Port = *port
	config.ConfPath = *confPath
	config.ImgDomain = *imgDomain

	// 初始化log
	logPathFile := path.Join(*logPath, "monkserver.log")
	log4go.InitLog(logPathFile, *logLevel)

	httpserver.LoadConf()

	addr := fmt.Sprintf("%s:%d", *host, *port)
	// start server
	httpServer := httpserver.THttpServer{
		Addr: addr,
	}
	httpServer.Start()

	fmt.Println("start success")

	//等待退出信号
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, os.Kill, syscall.SIGTERM)
	s := <-quit
	if s == syscall.SIGTERM || s == os.Interrupt {
		log.Println("stoping server")
	}

}
