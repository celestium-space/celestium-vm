#!/bin/bash -exu

set -o pipefail

contains_element() {
    local e match="$1"
    shift
    for e; do
        if [[ "$e" == "$match" ]]
        then return 0
        fi
    done
    return 1
}

repo_d=$PWD
build_d=build
gadget_d=gadget
kernel_d=kernel
gadget_snap=pc
kernel_snap=pc-kernel
gadget_snap_f=$gadget_snap.snap
kernel_snap_f=$kernel_snap.snap
mod_gadget_snap_f=$gadget_snap-mod.snap
mod_kernel_snap_f=$kernel_snap-mod.snap

rm -rf "$build_d"
mkdir "$build_d"
cd "$build_d"
snap download --channel=20 --basename="$gadget_snap" "$gadget_snap"
snap download --channel=20 --basename="$kernel_snap" "$kernel_snap"

# Gadget modifications: create user with cloud-init, disable console-conf
unsquashfs -d "$gadget_d" "$gadget_snap_f"
cp "$repo_d"/cloud.conf "$gadget_d"
gadget_defaults='defaults:
  system:
    service:
      console-conf:
        disable: true
'
printf '%s' "$gadget_defaults" >> "$gadget_d"/meta/gadget.yaml
snap pack --filename="$mod_gadget_snap_f" "$gadget_d"

# Kernel modifications: remove firmware and unneeded kernel modules
unsquashfs -d "$kernel_d" "$kernel_snap_f"
rm -rf "$kernel_d"/firmware/*
used=(ppdev.ko joydev.ko bochs_drm.ko drm_vram_helper.ko
      ttm.ko drm_kms_helper.ko virtio_net.ko net_failover.ko
      failover.ko parport_pc.ko floppy.ko fb_sys_fops.ko
      syscopyarea.ko parport.ko i2c_piix4.ko pata_acpi.ko
      input_leds.ko sysfillrect.ko mac_hid.ko sysimgblt.ko
      psmouse.ko serio_raw.ko qemu_fw_cfg.ko sch_fq_codel.ko
      drm.ko virtio_rng.ko ip_tables.ko x_tables.ko
      genet.ko gpio_regulator.ko fixed.ko phy_generic.ko
      sha256_ssse3.ko echainiv.ko glue_helper.ko crypto_simd.ko
      cryptd.ko dm_crypt.ko algif_skcipher.ko af_alg.ko
      virtio_blk.ko mmc_block.ko sdhci_acpi.ko sdhci_pci.ko
      cqhci.ko sdhci.ko virtio_scsi.ko nls_iso8859_1.ko
      usb_storage.ko ahci.ko libahci.ko hid_generic.ko
      usbhid.ko hid.ko nvme.ko nvme_core.ko autofs4.ko
      # Hyper-V modules
      intel_rapl_msr.ko intel_rapl_common.ko crct10dif_pclmul.ko crc32_pclmul.ko
      ghash_clmulni_intel.ko hv_balloon.ko hv_netvsc.ko rapl.ko
      hid_hyperv.ko hyperv_keyboard.ko hyperv_fb.ko hv_utils.ko
      mptspi.ko scsi_transport_spi.ko mptscsih.ko mptbase.ko
      megaraid_sas.ko scsi_transport_sas.ko hv_storvsc.ko scsi_transport_fc.ko
      hv_vmbus.ko aesni_intel.ko hv_sock.ko
     )
set +x
while read -r module_p; do
    module=$(basename "$module_p")
    if ! contains_element "$module" "${used[@]}"; then
        rm "$module_p"
    fi
done < <(find "$kernel_d"/modules/ -name \*.ko)
set -x
snap pack --filename="$mod_kernel_snap_f" "$kernel_d"

ubuntu-image snap \
             --snap "$mod_gadget_snap_f" \
             --snap "$mod_kernel_snap_f" \
             "$repo_d"/uc20-model.assert \
             --snap bounce-blockchain \
             --snap cryptosat-iss-pos \
             --snap curl \
             --snap drand \
             --snap gothan-city

qemu-img convert -f raw -O vhdx -o subformat=dynamic pc.img ubuntu.vhdx
zip ubuntu.zip ubuntu.vhdx
