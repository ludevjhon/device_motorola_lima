#!/vendor/bin/sh
scriptname=${0##*/}
dbg_on=1
debug()
{
	[ $dbg_on ] && echo "Debug: $*"
}

notice()
{
	echo "$*"
	echo "$scriptname: $*" > /dev/kmsg
}

error_and_leave()
{
	local err_msg
	local err_code=$1
	case $err_code in
		1)  err_msg="Error: No response";;
		2)  err_msg="Error: in factory mode";;
		3)  err_msg="Error: calibration file not exist";;
		4)  err_msg="Error: the calibration sys file not show up";;
	esac
	notice "$err_msg"
	exit $err_code
}

bootmode=`getprop ro.bootmode`
if [ $bootmode == "mot-factory" ]
then
	error_and_leave 2
fi

laser_class_path=/sys/class/laser_stmvl53l0/
laser_product_string=$(ls $laser_class_path)
laser_product_path=$laser_class_path/$laser_product_string
debug "laser product path: $laser_product_path"

for laser_file in $laser_product_path/*; do
	if [ -f "$laser_file" ]; then
		chown root:system $laser_file
	fi
done

laser_offset_path=$laser_product_path/flight_offsetcalibration_info
laser_offset_string=$(ls $laser_offset_path)
debug "laser offset path: $laser_offset_path"
[ -z "$laser_offset_string" ] && error_and_leave 4

cal_offset_path=/mnt/vendor/persist/camera/focus/offset_cal
cal_offset_string=$(ls $cal_offset_path)
[ -z "$cal_offset_string" ] && error_and_leave 3

offset_cal=$(cat $cal_offset_path)
debug "offset cal value [$offset_cal]"

debug "set cal value to kernel"
echo $offset_cal > $laser_offset_path
notice "laser cal data update success1"

laser_xtalk_path=$laser_product_path/flight_xtalkcalibration_info
laser_xtalk_string=$(ls $laser_xtalk_path)
debug "laser xtalk path: $laser_xtalk_path"
[ -z "$laser_xtalk_string" ] && error_and_leave 4

cal_xtalk_path=/mnt/vendor/persist/camera/focus/xtalk_cal
cal_xtalk_string=$(ls $cal_xtalk_path)
[ -z "$cal_xtalk_string" ] && error_and_leave 3

xtalk_cal=$(cat $cal_xtalk_path)
debug "xtalk cal value [$xtalk_cal]"

debug "set cal value to kernel"
echo $xtalk_cal > $laser_xtalk_path
notice "laser cal data update success2"
