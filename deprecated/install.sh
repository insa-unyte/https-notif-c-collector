#!/bin/bash

INSTALL_DIR=/usr/local
LIB_DIR=lib
H_DIR=include
PKG_DIR=/usr/lib/pkgconfig

if [ "$EUID" -ne 0 ]
then
  echo "Please run as root."
  exit 1
fi

echo "Adding current $PKG_DIR to PKG_CONFIG_PATH env"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

echo "Building and installing unyte shared lib in: $INSTALL_DIR/$LIB_DIR"

make build

echo "Moving build file to $INSTALL_DIR/$LIB_DIR"
install libunyte-https-notif.so $INSTALL_DIR/$LIB_DIR/libunyte-https-notif.so

if [ $? -ne 0 ]
then
  echo "Could not install shared lib to $INSTALL_DIR/$LIB_DIR" >&2
  echo "Try sudo"
  exit 1
fi

if [ ! -d "$INSTALL_DIR/$H_DIR/unyte-https-notif" ]
then
  echo "Creating $INSTALL_DIR/$H_DIR/unyte-https-notif directory"
  mkdir -p $INSTALL_DIR/$H_DIR/unyte-https-notif
fi

echo "Copying headers to $INSTALL_DIR/$H_DIR/unyte-https-notif"
cp src/*.h $INSTALL_DIR/$H_DIR/unyte-https-notif

if [ $? -ne 0 ]
then
  echo "Error copying headers" >&2
  echo "Try sudo"
  exit 1
fi

echo "Copying pkg-config file to $PKG_DIR"
sed -e "s/<<install>>/${INSTALL_DIR//\//\\/}/g" -e "s/<<include>>/$H_DIR/g" -e "s/<<lib>>/$LIB_DIR/g" unyte-pkg.pc > unyte-https-notif.pc
cp unyte-https-notif.pc $PKG_DIR/unyte-https-notif.pc

if [ $? -ne 0 ]
then
  echo "Error copying pkg-config file to $PKG_DIR" >&2
  echo "Try sudo"
  exit 1
fi

ldconfig
