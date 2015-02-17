#!/system/bin/sh

PATH=/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
ORIG_NVS_BIN=/system/etc/firmware/ti-connectivity/wl1271-nvs_127x.bin
NVS_BIN=/system/etc/firmware/ti-connectivity/wl1271-nvs.bin

if [ ! -f "$NVS_BIN" ]; then
    # be sure this wasn't run manually with the module loaded
    rmmod wl12xx_sdio
    mount -o remount,rw /system
    wait 1
    cp ${ORIG_NVS_BIN} ${NVS_BIN}
    MAC=`cat /rom/devconf/MACAddress | sed 's/\(..\)\(..\)\(..\)\(..\)\(..\)/\1:\2:\3:\4:\5:/'`
    calibrator set nvs_mac $NVS_BIN $MAC
    chmod 644 ${NVS_BIN}
    mount -o remount,ro /system
    wait 1
fi

insmod /system/lib/modules/wl12xx_sdio.ko

