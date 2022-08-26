ifeq ($(filter iob_ram_sp_be, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_ram_sp_be

# Submodules
include hardware/ram/iob_ram_sp/hardware.mk

# Sources
SRC+=$(BUILD_VSRC_DIR)/iob_ram_sp_be.v

# Copy the sources to the build directory 
$(BUILD_VSRC_DIR)/iob_ram_sp_be.v: hardware/ram/iob_ram_sp_be/iob_ram_sp_be.v
	cp $< $(BUILD_VSRC_DIR)

endif
