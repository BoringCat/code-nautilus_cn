#!/bin/bash

# Check source
command -v source > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Your SHELL don't support \`source\`. Please use anther one. (Recommand bash or sh>=5.0)"
fi

cd $(dirname `realpath $0`)

# Get $LANG
LANG_=$(echo $LANG | cut -d '.' -f1)
if [ $LANG_ == 'zh_CN' ]; then
    BEGIN_INSTALL="开始安装 python-nautilus 包..."
    ARCH_DEBIAN_ALREADY_INSTALL="python-nautilus 已安装"
    REDHAT_ALREADY_INSTALL="nautilus-python 已安装"
    PKGNOTFOUND="找不到包 python-nautilus, 请手动安装."
    REMOVE_OLD="删除旧版本（如果存在）..."
    DOWNLOAD_NEW="下载最新版..."
    RESTART_REQUIRE="完成安装需要关闭所有 nautilus 窗口, 确定?"
    RESTART="正在关闭所有 nautilus 窗口..."
    RESTART_NOCONFIRM="没有关闭所有 nautilus 窗口! 请手动关闭以确保已安装."
    COMPLETE="安装完成"
elif [ $LANG_ == 'zh_HK' ]; then
    BEGIN_INSTALL="開始裝 python-nautilus 包..."
    ARCH_DEBIAN_ALREADY_INSTALL="python-nautilus 裝佐了"
    REDHAT_ALREADY_INSTALL="nautilus-python 裝佐了"
    PKGNOTFOUND="揾唔到 python-nautilus 包, 你要自己裝."
    REMOVE_OLD="刪除舊版本（如果有嘅話）..."
    DOWNLOAD_NEW="下載最新版..."
    RESTART_REQUIRE="完成安裝需要關佐所有 nautilus 窗口, 確定?"
    RESTART="關梗所有 nautilus 窗口..."
    RESTART_NOCONFIRM="冇去關 nautilus 嘅窗口! 請手動關閉以確保安裝完成."
    COMPLETE="搞掂"
else
    BEGIN_INSTALL="Installing python-nautilus..."
    ARCH_DEBIAN_ALREADY_INSTALL="python-nautilus is already installed."
    REDHAT_ALREADY_INSTALL="nautilus-python is already installed."
    PKGNOTFOUND="Failed to find python-nautilus, please install it manually."
    REMOVE_OLD="Removing previous version (if found)..."
    DOWNLOAD_NEW="Downloading newest version..."
    RESTART_REQUIRE="We need restart all nautilus windows, confirm?"
    RESTART="Restarting nautilus..."
    RESTART_NOCONFIRM="No confirm! Please restart nautilus manually."
    COMPLETE="Installation Complete"
fi

# Install python-nautilus
echo $BEGIN_INSTALL
if type "pacman" > /dev/null 2>&1
then
    sudo pacman -S --noconfirm --needed python-nautilus
elif type "apt-get" > /dev/null 2>&1
then
    installed=`apt list --installed python-nautilus -qq 2> /dev/null`
    if [ -z "$installed" ]
    then
        sudo apt-get install -y python-nautilus
    else
        echo $ARCH_DEBIAN_ALREADY_INSTALL
    fi
elif type "dnf" > /dev/null 2>&1
then
    installed=`dnf list --installed nautilus-python 2> /dev/null`
    if [ -z "$installed" ]
    then
        sudo dnf install -y nautilus-python
    else
        echo $REDHAT_ALREADY_INSTALL
    fi
else
    echo $PKGNOTFOUND
fi

# Remove previous version and setup folder
echo $REMOVE_OLD
mkdir -p ~/.local/share/nautilus-python/extensions
rm -f ~/.local/share/nautilus-python/extensions/VSCodeExtension.py
rm -f ~/.local/share/nautilus-python/extensions/code-nautilus.py

# Download and install the extension
echo $DOWNLOAD_NEW
wget --show-progress -q -O ~/.local/share/nautilus-python/extensions/code-nautilus.py https://raw.githubusercontent.com/BoringCat/code-nautilus_cn/master/code-nautilus.py

echo -e ${RESTART_REQUIRE}" (Y/n): \c"
read confirm

if [[ "$confirm" == 'y' || "$confirm" == 'Y' ]]; then
# Restart nautilus
    echo $RESTART
    nautilus -q
else
    echo $RESTART_NOCONFIRM
fi

echo $COMPLETE
