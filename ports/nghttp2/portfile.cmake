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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/nghttp2-1.27.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/nghttp2/nghttp2/releases/download/v1.27.0/nghttp2-1.27.0.tar.gz"
    FILENAME "nghttp2-1.27.0.tar.gz"
    SHA512 b6b3211860926e6ef560db11b773466bd49986e5860b5ad8b35dbb07dd3ed311b85a0d5a263a383cf1833b41d0a9367efe3fef3d787bd7a28973f27ec4918b38
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

# Handle copyright
#file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/nghttp2)
#file(RENAME ${CURRENT_PACKAGES_DIR}/share/nghttp2/LICENSE ${CURRENT_PACKAGES_DIR}/share/nghttp2/copyright)

file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/nghttp2)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/nghttp2/COPYING ${CURRENT_PACKAGES_DIR}/share/nghttp2/copyright)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/bin)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/bin)
file(COPY ${CURRENT_PACKAGES_DIR}/lib/nghttp2.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
file(COPY ${CURRENT_PACKAGES_DIR}/debug/lib/nghttp2.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)

file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/nghttp2.dll)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/nghttp2.dll)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

