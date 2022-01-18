/**********************************************************************************************************************
 *
 * Copyright (c) 2010 babeltime.com, Inc. All Rights Reserved
 *
 **********************************************************************************************************************/

/**
 * @author chengliang
 * @date 2021/9/13 17:28
 * @brief
 *
 **/
package main

import (
"time"

rotatelogs "github.com/lestrrat-go/file-rotatelogs"
log "github.com/sirupsen/logrus"
)
var writer *rotatelogs.RotateLogs

func init() {
	path := "/tmp/log/httpserver.log"
	/* 日志轮转相关函数
	`WithLinkName` 为最新的日志建立软连接
	`WithRotationTime` 设置日志分割的时间，隔多久分割一次
	WithMaxAge 和 WithRotationCount二者只能设置一个
	 `WithMaxAge` 设置文件清理前的最长保存时间
	 `WithRotationCount` 设置文件清理前最多保存的个数
	*/
	// 下面配置日志每隔 1 分钟轮转一个新文件，保留最近 3 分钟的日志文件，多余的自动清理掉。
	writer, _ = rotatelogs.New(
		path+".%Y%m%d%H",
		rotatelogs.WithLinkName(path),
		rotatelogs.WithMaxAge(time.Duration(180)*time.Hour),
		rotatelogs.WithRotationTime(time.Hour),
	)
	log.SetOutput(writer)
	//log.SetFormatter(&log.JSONFormatter{})
}

func main() {
	logger := log.New()

	logger.SetOutput(writer)
	log.Info(writer)
	for {
		logger.Info("hello, world!")
		time.Sleep(time.Duration(2) * time.Second)
	}
}