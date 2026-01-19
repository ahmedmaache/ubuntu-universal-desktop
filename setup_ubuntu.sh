#!/bin/bash
set -e

echo "📦 Installing Dependencies..."
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y \
    xfce4 xfce4-goodies \
    xrdp \
    chromium-browser \
    dbus-x11 \
    libglu1-mesa \
    unzip xz-utils zip

echo "🐧 Configuring XRDP..."
# Use XFCE
echo "xfce4-session" > ~/.xsession
# Allow anyone to start X
if [ -f /etc/X11/Xwrapper.config ]; then
    sudo sed -i 's/allowed_users=console/allowed_users=anybody/g' /etc/X11/Xwrapper.config
else
    echo "allowed_users=anybody" | sudo tee /etc/X11/Xwrapper.config
fi

# Set User Password
echo "codespace:vscode" | sudo chpasswd
echo "root:vscode" | sudo chpasswd

# Restart service
sudo service xrdp restart

echo "📱 Installing Android Studio..."
STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.28/android-studio-2023.1.1.28-linux.tar.gz"
if [ ! -d "/usr/local/android-studio" ]; then
    curl -L $STUDIO_URL -o /tmp/studio.tar.gz
    sudo tar -xzf /tmp/studio.tar.gz -C /usr/local/
    rm /tmp/studio.tar.gz
fi
echo 'export PATH=$PATH:/usr/local/android-studio/bin' >> ~/.bashrc

echo "✅ Setup Complete!"
