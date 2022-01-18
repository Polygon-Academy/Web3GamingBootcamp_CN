/**********************************************************************************************************************
 *
 * Copyright (c) 2010 babeltime.com, Inc. All Rights Reserved
 *
 **********************************************************************************************************************/

/**
 * @author chengliang
 * @date 2021/9/8 21:54
 * @brief
 *
 **/

package httpserver

import (
	"encoding/json"
	"fmt"
	"github.com/bright1208/monk/httpserver/log4go"
	"github.com/gorilla/mux"
	"io/ioutil"
	"net/http"
	"os"
	"path"
)

const (
	DefFaceFileName         = "monk.json"
	DefContractInfoFileName = "contract_info.json"
)

var gImgMetaMap = make(map[string]*TImgMeta, 489)
var gContractInfo map[string]string

var gLogger log4go.ILog4go

func LoadConf() {
	gLogger = log4go.NewLog()
	// 先加载
	loadContractInfo()
	loadImgMetaInfos()
	//loadImgMetaInfos_old()
}

// 读取脸谱等信息
func loadImgMetaInfos() {
	des := gContractInfo["description"]
	config := GConfig
	filePath := path.Join(config.ConfPath, DefFaceFileName)
	jsonFile, err := os.Open(filePath)
	if err != nil {
		gLogger.Panic(err)
	}
	defer jsonFile.Close()

	byteValue, err := ioutil.ReadAll(jsonFile)
	if err != nil {
		gLogger.Panic(err)
	}
	var res []map[string]string
	err = json.Unmarshal(byteValue, &res)
	if err != nil {
		gLogger.Panic(err)
	}
	gLogger.Debug(res[9])
	for _, imgAttri := range res {
		meta := &TImgMeta{
			Name:  imgAttri["name"],
			Image: fmt.Sprintf("%s/%s", config.ImgDomain, imgAttri["fileName"]),
			Desc:  des,
			Attributes: []map[string]interface{}{
				{"trait_type": "BackGround", "value": imgAttri["BackGround"]},
				{"trait_type": "UpperBody", "value": imgAttri["UpperBody"]},
				{"trait_type": "BackRarity", "value": imgAttri["BackRarity"]},
				{"trait_type": "Leg", "value": imgAttri["Leg"]},

				{"trait_type": "initPower", "value": 10, "max_value": 100},
			},
		}
		gImgMetaMap[imgAttri["id"]] = meta
	}
}

// 读取脸谱等信息
func loadImgMetaInfos_old() {
	des := gContractInfo["description"]
	config := GConfig
	filePath := path.Join(config.ConfPath, DefFaceFileName)
	jsonFile, err := os.Open(filePath)
	if err != nil {
		gLogger.Panic(err)
	}
	defer jsonFile.Close()

	byteValue, err := ioutil.ReadAll(jsonFile)
	if err != nil {
		gLogger.Panic(err)
	}
	var res []map[string]string
	err = json.Unmarshal(byteValue, &res)
	if err != nil {
		gLogger.Panic(err)
	}
	gLogger.Debug(res[9])
	for _, imgAttri := range res {
		meta := &TImgMeta{
			Name:  imgAttri["name"],
			Image: fmt.Sprintf("%s/%s", config.ImgDomain, imgAttri["fileName"]),
			Desc:  des,
			Attributes: []map[string]interface{}{
				{"trait_type": "initPower", "value": 10, "max_value": 25},
				{"trait_type": "BGRarity", "value": 2, "max_value": 100},
				{"trait_type": "upperRarity", "value": 2, "max_value": 100},
				{"trait_type": "backRarity", "value": 2, "max_value": 100},
				{"trait_type": "legRarity", "value": 2, "max_value": 100},
			},
		}
		gImgMetaMap[imgAttri["id"]] = meta
	}
}

func loadContractInfo() {
	config := GConfig
	filePath := path.Join(config.ConfPath, DefContractInfoFileName)
	jsonFile, err := os.Open(filePath)
	if err != nil {
		gLogger.Panic(err)
	}
	defer jsonFile.Close()

	byteValue, err := ioutil.ReadAll(jsonFile)
	if err != nil {
		gLogger.Panic(err)
	}

	err = json.Unmarshal(byteValue, &gContractInfo)
	if err != nil {
		gLogger.Panic(err)
	}
	fmt.Println(gLogger)
	gLogger.Info(gContractInfo)
}

// ApiHandler 返回单个face信息
func ApiHandler(w http.ResponseWriter, r *http.Request) {
	hLog := log4go.NewHttpLog(r)
	w.Header().Set("Content-Type", "application/json")
	hLog.Info(r)
	// 取id
	vars := mux.Vars(r)
	hLog.Info(vars)
	imgIdStr, ok := vars["imgid"]
	if !ok {
		err := fmt.Errorf("url error:%s", r.URL)
		hLog.Panic(err.Error())
	}
	//imgId, err := strconv.Atoi(imgIdStr)
	//if err != nil {
	//	hLog.Fatal(err)
	//	hLog.Panic(err)
	//}
	meta := gImgMetaMap[imgIdStr]
	hLog.Info(meta)
	metaByte, err := json.Marshal(meta)
	if err != nil {
		hLog.Panic(err)
	}
	w.Write(metaByte)
}

// ContractHandler 处理
func ContractHandler(w http.ResponseWriter, r *http.Request) {
	hLog := log4go.NewHttpLog(r)
	w.Header().Set("Content-Type", "text/json")
	metaByte, err := json.Marshal(gContractInfo)
	hLog.Info(metaByte)
	if err != nil {
		hLog.Panic(err)
	}
	w.Write(metaByte)
}
