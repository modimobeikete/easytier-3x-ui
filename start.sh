#!/bin/sh
echo "Starting easytier"
/app/easytier-core -w ${EASYTIERWEB_USERNAME} --machine-id ${MACHINE_ID} ${EXTRA_ARGS} &
echo Easytier started

# Download x-ui with error checking
echo "Downloading x-ui..."
cd /root/
if ! wget --no-check-certificate https://github.com/MHSanaei/3x-ui/releases/latest/download/x-ui-linux-amd64.tar.gz; then
    echo "Failed to download x-ui package"
    exit 1
fi

# Verify the downloaded file exists and is not empty
if [ ! -s x-ui-linux-amd64.tar.gz ]; then
    echo "Downloaded file is empty or doesn't exist"
    exit 1
fi

# Extract and install
echo "Installing x-ui..."
rm -rf x-ui/ /usr/local/x-ui/ /usr/bin/x-ui
if ! tar zxvf x-ui-linux-amd64.tar.gz; then
    echo "Failed to extract x-ui package"
    exit 1
fi

if [ ! -d "x-ui" ]; then
    echo "Extracted x-ui directory not found"
    exit 1
fi

chmod +x x-ui/x-ui x-ui/bin/xray-linux-* x-ui/x-ui.sh
cp x-ui/x-ui.sh /usr/bin/x-ui
cp -f x-ui/x-ui.service /etc/systemd/system/
mv x-ui/ /usr/local/

systemctl daemon-reload
systemctl enable x-ui
if ! systemctl restart x-ui; then
    echo "Failed to start x-ui service"
    journalctl -u x-ui.service -b --no-pager
    exit 1
fi

echo "x-ui installation completed successfully"
# 保持容器运行
echo "Container is running. Press Ctrl+C to stop."
tail -f /dev/null
