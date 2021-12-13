# Github PR提交流程 #

这个流程原版来源于[这里](https://github.com/WhiteMatrixTech/Metaverse-Developers/blob/main/README.md)

<strong>PR提交截止日期：北京时间 2021年1月3日23：59</strong>

### 1. [创建一个github账户](https://github.com/)

### 2. [（仅windows用户需要）下载gitbash客户端，并在本地配置github](https://gitforwindows.org/)

   打开gitbash，在终端输入以下命令行（name及email均按照github账户填写）

    git config --global user.name xxx
       
    git config --global user.email xxxxxx@xxx.com

 ![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8201.png)

   创建本地ssh

    ssh-keygen -t rsa -C "xxxxxx@xxx.com" 
 ![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8266.png)

   将ssh配置到Github中

   在mac os X 下前往文件夹，/Users/自己电脑用户名/.ssh。

   windows应该是（C:\Documents and Settings\Administrator\.ssh （或者 C:\Users\自己电脑用户名\\.ssh）中）。

   linux是/home/自己电脑用户名/.ssh


 ![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8203.png)

   用记事本打开id_rsa.pub文件，复制文件内容：
> ssh-rsa XXXXX....XXX
>
>  xxxxxx@xxx.com

   登录github网址，个人账户的settings-SSH and GPG keys，点击New SSH key并粘贴id_rsa.pub文件中内容，点击Add SSH key, title随便写。

   ![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8204.png)

   ![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8205.png)

   验证是否配置成功

    ssh -T git@github.com

![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8207.png)

### 3.fork开源代码到自己的远程仓库

仓库地址：https://github.com/Polygon-Academy/Web3GamingBootcamp_CN

  ![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8208.png)



### 4.通过SSH的方法Clone自己的仓库到本地电脑

  ![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8209.png)

    git clone git@github.com:XXXxx

进入到该文件夹下

``` 
cd xxxxxxxxxxx
```

### 5.在projects中创建一个文件夹，以你们队伍编号命名（如：1），

并在该目录下生成一个README.md文件，其中必须包含以下信息：

```
队伍编号：
选择的Bounty：
队内分工：
项目简介：
视频链接：（建议bilibili视频或者youtube视频链接）
仓库地址（含ppt）：
```

样例：
- https://github.com/WhiteMatrixTech/Metaverse-Developers/tree/main/projects/1
- https://github.com/BottomlessData/Aster-Chainlink

保存好该文件后，输入以下命令，将修改上传到自己的fork的仓库中

```
git add .
git commit -m 'update'
git push
```


![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8233.png)

  此时github端就生成了README.md文件

![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8239.png)

### 6.点击New pull request, 创建一个 PR（pull request）

![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8213.png)

点击Create pull request,进行提交

### 7.在 Github 上将 PR 转成 Draft，之后将所有参赛相关信息放在其中

![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8236.png)





![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8237.png)

### 8.在个人端完成项目，修改内容，提交

### 9.当完成作品时请修改 PR 状态为 Ready For Review，会有工作人员合并 PR
![](https://chainide-forum-img.s3.ap-northeast-1.amazonaws.com/8238.png)