# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/dtl-master)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/littlemole/dtl/archive/master.zip"
    FILENAME "dtl-1.19.0.zip"
    SHA512 882f1ba6a83578d837999a77eac247fa13216c1317d1aabcca39212c66af0db450bc3b2c1693cda38563cd3e58dbbe68ce4adbebb2a2089800199babf76e932c
)
vcpkg_extract_source_archive(${ARCHIVE})



file(COPY
${SOURCE_PATH}/dtl
DESTINATION ${CURRENT_PACKAGES_DIR}/include/)


# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/dtl)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/dtl/COPYING ${CURRENT_PACKAGES_DIR}/share/dtl/copyright)
