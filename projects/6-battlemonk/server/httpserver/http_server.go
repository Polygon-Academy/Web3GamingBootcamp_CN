/**
 * @author chengliang
 * @date 2021/9/8 20:38
 * @brief
 *
 **/

package httpserver

import (
	"fmt"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"runtime/debug"
)

type THttpServer struct {
	Addr string
}

func (this *THttpServer) Start() {
	go this.routineRun()
}

var routes = []Route{
	{
		Name:        "api",
		Pattern:     "/api/monk/{imgid}",
		Methods:     []string{"GET", "POST"},
		HandlerFunc: ApiHandler,
	},
	{
		Name:        "contract",
		Pattern:     "/api/contract/monk",
		Methods:     []string{"GET", "POST"},
		HandlerFunc: ContractHandler,
	},
}

func (this *THttpServer) routineRun() {
	//panic处理
	defer func() {
		if r := recover(); r != nil {
			log.Fatal(" recover:%v, stack:\n%s\n", r, debug.Stack())
		}
	}()

	router := mux.NewRouter().StrictSlash(true)
	for _, route := range routes {
		router.
			Methods(route.Methods...).
			Path(route.Pattern).
			Name(route.Name).
			Handler(route.HandlerFunc)
	}
	router.Headers("Access-Control-Allow-Origin", "*",
		"Access-Control-Allow-Headers", "Content-Type",
		"content-type", "application/json")

	http.Handle("/", router)

	//certFile := path.Join(GConfig.ConfPath, "cert", DefHttpsPemFile)
	//keyFile := path.Join(GConfig.ConfPath, "cert", DefHttpsKeyFile)
	err := http.ListenAndServe(this.Addr, nil)
	if err != nil {
		log.Fatal(fmt.Sprintf("list on %s failed. err:%s", this.Addr, err.Error()))
	}

}
