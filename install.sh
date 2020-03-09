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
    source lang_zh_CN.sh
elif [ $LANG_ == 'zh_HK' ]; then
    source lang_zh_HK.sh
else
    source lang_en_US.sh
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
