/**********************************************************************************************************************
 *
 * Copyright (c) 2010 babeltime.com, Inc. All Rights Reserved
 *
 **********************************************************************************************************************/

/**
 * @author chengliang
 * @date 2021/9/9 10:26
 * @brief
 *
 **/

package httpserver

type TConfig struct {
	Host      string
	Port      int
	ConfPath  string //配置路径
	ImgDomain string
}

var GConfig TConfig
