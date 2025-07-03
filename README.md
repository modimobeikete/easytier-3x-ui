**一个简易容器配置以及镜像，能够确保能够同时运行tailscale，easytier的同时运行3x-ui，专用于托管应用（非代码托管型）。**

这样或许可以降低搭建中继服务器的成本，毕竟容器的话跟虚拟机还是有一定的区别的

## 如何使用

对于容器托管应用，镜像为ghcr.io/modimobeikete/tailscale-3x-ui:main
环境变量要添加的如下：
TAILSCALE_AUTHKEY
MACHINE_ID
EASYTIERWEB_USERNAME
数值为你在Tailscale获取的认证密钥
MACHINE_ID必须填写，已经测试出在部分地方会因为变换id导致刷设备数量。

## 安装在服务器上。

如果需要使用的话，用这些代码

```
docker run -d \
  -e TAILSCALE_AUTHKEY=（你自己的认证密钥） \
  -p 2053:2053 \
  --cap-add=NET_ADMIN \
  --name 3docker \
  （任意名字记得改）
```

## 特殊容器

如果说容器是要指定存储空间的（如ClawRun 必须指明存储空间不然无限重启的），目前所用到的目录如下：


```
/var/lib/tailscale
/etc/x-ui/
/root/cert/
/usr/bin/x-ui
/etc/systemd/system/
/usr/local/
/opt/easytier
```

### 特点

得益于Easytier的KCP代理，现在在打开KCP的情况下，网络是正常的，也就是说，只要容器正常，那么用Easytier作为接入点来说，是可以正常穿透，VRchat也不会出现无限循环故障

