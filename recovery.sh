#!/bin/bash
#
#=======================================================#
# https://wiki.archlinux.org/title/GRUB#Installation
# https://www.blogopcaolinux.com.br/2016/09/recuperar-grub-ubuntu-com-live-dvd-ou-pen-drive.html
# https://www.youtube.com/watch?v=tDz-E4kk3Bc
# https://over.wiki/ask/usr-sbin-grub-probe-error-failed-to-get-canonical-path-of-overlay/
# https://www.youtube.com/watch?v=TJa9kSNGzlM
#
#==========================================================#
# COMANDOS:
# grub-install --root-directory=/mnt /dev/sda
#
# grub-install --target=x86_64-efi /dev/sda
#
#
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --boot-directory=/boot --bootloader-id=debian
#

# Dispositivos
readonly PART_SYSTEM='/dev/sda2' # ponto de montagem /
readonly PART_EFI='/dev/sda4'    # partição efi
readonly PART_BOOT='/dev/sda1'   # partição boot.

# Diretórios de montagem
readonly DIR_ROOT='/mnt'
readonly DIR_BOOT="${DIR_ROOT}/boot"
readonly DIR_EFI="${DIR_BOOT}/efi"
readonly GRUB_ID='debian'


function MountDevices(){
	# Monta os dispositivos em DIR_ROOT
	echo 
	echo -e "Montando $PART_SYSTEM => $DIR_ROOT"
	mount "$PART_SYSTEM" "$DIR_ROOT" || return 1
	
	[[ ! -z $PART_BOOT ]] && {
		echo -e "Montando $PART_BOOT => $DIR_BOOT"
		mount "$PART_BOOT" "$DIR_BOOT" || return 1
	}
	
	echo -e "Montando $PART_EFI => $DIR_EFI"
	mount "$PART_EFI" "$DIR_EFI" || return 1
}


function _InstallDebianReq(){
	apt update
	apt install -y grub-common grub-efi
}

function InstallReq(){
	_InstallDebianReq || return 1
}


function InstallGrubEfiDebian(){
	# grub-install --target=x86_64-efi --efi-directory="$DIR_EIF" --boot-directory="$DIR_BOOT" --bootloader-id="$GRUB_ID"
	# grub-install --root-directory="$DIR_ROOT" /dev/sda
	
	grub-install --target=x86_64-efi --efi-directory="$DIR_EFI" --boot-directory="$DIR_BOOT" --bootloader-id="$GRUB_ID"
}

function InstallGrubEfi(){
	# Instalar o grub-efi
	
	InstallGrubEfiDebian
}

function main(){
	clear
	InstallReq || return 1
	MountDevices || return 1

	echo
	InstallGrubEfi
}

main $@



