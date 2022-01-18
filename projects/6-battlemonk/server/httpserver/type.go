/**
 * @author chengliang
 * @date 2021/9/8 20:43
 * @brief
 *
 **/

package httpserver

import "net/http"

type Route struct {
	Name        string
	Methods     []string
	Pattern     string
	HandlerFunc http.HandlerFunc
}

// TMetaAttr 属性
type TMetaAttr struct {
	TraitType string  `json:"trait_type""`
	Value     float64 `json:"value"`
	MaxValue  float64 `json:"max_value"`
}

// TImgMeta 基本信息
type TImgMeta struct {
	Name       string      `json:"name"`
	Desc       string      `json:"description"`
	Image      string      `json:"image"`
	Attributes []map[string]interface{} `json:"attributes"`
}
