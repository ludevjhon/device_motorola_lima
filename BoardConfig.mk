DEVICE_PATH := device/motorola/lima
BOARD_VENDOR := motorola

# Security patch level
VENDOR_SECURITY_PATCH := 2019-09-05

# HIDL
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(DEVICE_PATH)/framework_compatibility_matrix.xml

-include vendor/motorola/lima/BoardConfigVendor.mk