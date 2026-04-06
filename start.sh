#!/bin/sh
echo "Starting easytier"
/app/easytier-core -w "${EASYTIERWEB_USERNAME}" --machine-id "${MACHINE_ID}" ${EXTRA_ARGS} &
echo "Easytier started"

# 下载 x-ui 前清理旧文件，并强制命名，防止出现 .1, .2 尾缀
echo "Downloading x-ui..."
cd /root/
rm -f x-ui-linux-amd64.tar.gz
if ! wget -O x-ui-linux-amd64.tar.gz --no-check-certificate https://github.com/MHSanaei/3x-ui/releases/latest/download/x-ui-linux-amd64.tar.gz; then
    echo "Failed to download x-ui package"
    exit 1
fi

# 检查文件是否有效
if [ ! -s x-ui-linux-amd64.tar.gz ]; then
    echo "Downloaded file is empty or doesn't exist"
    exit 1
fi

# 解压和安装
echo "Installing x-ui..."
# 去掉了对 /usr/bin/x-ui 的 rm 操作，避免 Device busy 报错
rm -rf x-ui/ /usr/local/x-ui/
if ! tar zxvf x-ui-linux-amd64.tar.gz; then
    echo "Failed to extract x-ui package"
    exit 1
fi

if [ ! -d "x-ui" ]; then
    echo "Extracted x-ui directory not found"
    exit 1
fi

# 赋予权限并移动目录
chmod +x x-ui/x-ui x-ui/bin/xray-linux-*
mv x-ui/ /usr/local/

echo "x-ui installation completed successfully"

# 在 Docker 中直接启动 x-ui 主程序，这会自动保持容器一直运行（替代原来的 tail -f /dev/null）
echo "Starting x-ui..."
cd /usr/local/x-ui
./x-ui
