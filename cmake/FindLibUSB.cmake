# FindLibUSB.cmake  –  works for libusb-1.x
# Creates:  LibUSB_FOUND
#           LibUSB_INCLUDE_DIRS
#           LibUSB_LIBRARIES
#           LibUSB::LibUSB  (imported target)

# 1. Allow caller-supplied hints
if(DEFINED LibUSB_ROOT_DIR)
    list(APPEND CMAKE_PREFIX_PATH "${LibUSB_ROOT_DIR}")
endif()

# 2. Normal search
find_path(LibUSB_INCLUDE_DIR
          NAMES libusb.h
          PATH_SUFFIXES libusb-1.0
          HINTS ${LibUSB_ROOT_DIR}/include)

find_library(LibUSB_LIBRARY
             NAMES usb-1.0 usb libusb-1.0
             HINTS ${LibUSB_ROOT_DIR}/lib ${LibUSB_ROOT_DIR}/lib64)

# 3. If caller gave both paths explicitly, trust them
if(LibUSB_LIBRARY AND LibUSB_INCLUDE_DIR AND NOT LibUSB_FOUND)
    set(LibUSB_FOUND TRUE)
    set(LibUSB_LIBRARIES "${LibUSB_LIBRARY}")
    set(LibUSB_INCLUDE_DIRS "${LibUSB_INCLUDE_DIR}")
endif()

# 4. Standard handling (makes missing paths fatal)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibUSB
                                  DEFAULT_MSG
                                  LibUSB_LIBRARY
                                  LibUSB_INCLUDE_DIR)

# 5. Create imported target
if(LibUSB_FOUND AND NOT TARGET LibUSB::LibUSB)
    add_library(LibUSB::LibUSB STATIC IMPORTED GLOBAL)
    set_target_properties(LibUSB::LibUSB
        PROPERTIES
        IMPORTED_LOCATION "${LibUSB_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${LibUSB_INCLUDE_DIR}")
endif()

mark_as_advanced(LibUSB_INCLUDE_DIR LibUSB_LIBRARY)
