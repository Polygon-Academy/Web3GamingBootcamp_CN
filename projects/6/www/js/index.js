// <!--用jQuery绑定点击事件-->
// $('.header').click(function () {
//     //移除下一个标签的hide
//     $(this).next().removeClass('hide');
//     //找到当前标签的父标签parent--找到父标签的兄弟标签siblings--找到兄弟标签中class为content的标签
//     $(this).parent().siblings().find('.content').addClass('hide');
// })

(function () {
    'use strict';

    // var polygonNetwork = 137
    var polygonNetwork = 80001
    var curNetVersion = 0
    var mainAddr = '0xB5F8BE00717Cf3BD5A0c168D083066DD0f6aA445'
    var monkAddr = mainAddr

    var prebuy = document.getElementById('prebuy');
    var bugDialog = document.getElementById('J-buyDialog');
    var closeBtn = document.getElementById('J-closeBtn');
    var buyBtn = document.getElementById('J-buyBtn');

    var connectBtn = document.getElementById('J-connect');
    var addressLi = document.getElementById('J-address')

    var account

    async function getAccount() {
        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
        account = accounts[0];
        console.log(account)
        var displayAccount = getSubStr(account)
        console.log(displayAccount)
        addressLi.innerText= "Account: "+displayAccount
        connectBtn.hidden=true

        checkNetVersion()
    }

    // 监听测试和主网切换钱包
    ethereum.on('chainChanged', (chainId) => {
        console.log("chainChanged", chainId)
        checkNetVersion()
    });

    async function checkNetVersion(){
        var net_version = await ethereum.request({ method: 'net_version' });

        curNetVersion = net_version
        if (curNetVersion != polygonNetwork) {
            alert("Please use polygon Network!")
        }
    }

    connectBtn.addEventListener('click', function () {
        console.log("connect")
        getAccount()
    })

    var reduceBtn = document.getElementById('J-reduceBtn')
    var addBtn = document.getElementById('J-addBtn')
    var numText = document.getElementById('J-numText')
    var totalNum = document.getElementById('J-totalNum')

    var hideDialog = function hideDialog() {
        bugDialog.classList.add('fn-hidden');
    };
    var showDialog = function showDialog() {
        bugDialog.classList.remove('fn-hidden');
    };

    prebuy.addEventListener('click', function (){
        if ( account == null ||  account == undefined || account == '' ){
            getAccount()
        }
        showDialog()
    });
    closeBtn.addEventListener('click', hideDialog);

    var price = 0.01;
    var number = 1;
    function doCount() {
        numText.innerText = number;
        totalNum.innerText = number * price;
    }
    doCount();
    reduceBtn.addEventListener('click', function () {
        if (number <= 1) {
            return;
        }
        number--;
        doCount();
    });
    addBtn.addEventListener('click', function () {
        if (number >= 20) {
            return;
        }
        number++;
        doCount();
    });

    const NFT_ABI = [
        {
            "inputs": [
                {
                    "internalType": "uint256",
                    "name": "_num",
                    "type": "uint256"
                }
            ],
            "name": "claim",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
        }
    ];


    buyBtn.addEventListener('click', function (){
        sendTransaction(number)
        hideDialog()
    });

    var abiInterface = new ethers.utils.Interface(NFT_ABI)

    function sendTransaction(num, callback){
        // if (curNetVersion != polygonNetwork) {
        //     alert("Please use polygon Network!" + curNetVersion + " " + polygonNetwork)
        //     return
        // }
        var value = price * num
        const params = [
            {
                from:ethereum.selectedAddress,
                to:monkAddr,
                // value:'0x'+value.toString(16),
                data:abiInterface.encodeFunctionData("claim", [num])
            },
        ];
        console.log(params)
        ethereum
            .request({
                method: 'eth_sendTransaction',
                params,
            })
            .then((result) => {
                console.log(result)
                // The result varies by RPC method.
                // For example, this method will return a transaction hash hexadecimal string on success.
            })
            .catch((error) => {
                // If the request fails, the Promise will reject with an error.
                console.log(error)
            });
    }


    function getSubStr (str){
        //var str = "可以用详细代码解决吗？急需，谢谢!";
        var subStr1 = str.substr(0,5);
        var subStr2 = str.substr(str.length-4,4);
        var subStr = subStr1 + "..." + subStr2 ;
        return subStr;
    }

    function copy(str){
        var input = document.createElement('input');
        input.value = str;
        document.body.appendChild(input);
        input.select();
        document.execCommand("Copy");
        input.className = 'input';
        input.style.display = 'none';

    }

}());

