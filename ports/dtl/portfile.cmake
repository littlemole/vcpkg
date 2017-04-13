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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/dtl-1.19)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/cubicdaiya/dtl/archive/v1.19.tar.gz"
    FILENAME "dtl-1.19.0.tgz"
    SHA512 77c767451b1b78ce49085da6ff5bb8a23c96dec56a37d96ef357a6b69a1b2cd45e2c6c4e8f91ee34ca080ce03a26518c478ff207309326a4bc7e729eaa2824b2
)
vcpkg_extract_source_archive(${ARCHIVE})



file(COPY
${SOURCE_PATH}/dtl
DESTINATION ${CURRENT_PACKAGES_DIR}/include/)


# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/dtl)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/dtl/COPYING ${CURRENT_PACKAGES_DIR}/share/dtl/copyright)
