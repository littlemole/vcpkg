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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/source)
vcpkg_download_distfile(ARCHIVE
    URLS "https://downloads.sourceforge.net/project/utfcpp/utf8cpp_2x/Release%202.3.4/utf8_v2_3_4.zip"
    FILENAME "utf8-2.3.4.zip"
    SHA512 0e85e443e7bd4ecbe85dedfb7bdf8b1767808108b3a4fc1c0c508bcf74787539ae0af95a31a70e715ca872689ac4d7233afc075ceb375375d26743f92051e222
)
vcpkg_extract_source_archive(${ARCHIVE})


file(COPY
${CURRENT_BUILDTREES_DIR}/src/source/
DESTINATION ${CURRENT_PACKAGES_DIR}/include/)


# Handle copyright
file(COPY ${SOURCE_PATH}/utf8.h DESTINATION ${CURRENT_PACKAGES_DIR}/share/utf8)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/utf8/utf8.h ${CURRENT_PACKAGES_DIR}/share/utf8/copyright)
