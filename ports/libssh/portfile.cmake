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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libssh-0.7.3)
vcpkg_download_distfile(ARCHIVE
    URLS "https://red.libssh.org/attachments/download/195/libssh-0.7.3.tar.xz"
    FILENAME "libssh-0.7.3.tar.gz"
    SHA512 6797ea9492c9d07e0169163e6559a7880dd368ee763eff297b3cbddda5e892703cf32506f9513e7d9b5135984e1e888c4893b342df07da1b7ee30968c9185869
)
vcpkg_extract_source_archive(${ARCHIVE})

# switch between static and dll build
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
	OPTIONS -DWITH_STATIC_LIB=1
)
else()
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
)
endif()


vcpkg_install_cmake()

# for static build, remove any orphaned dlls
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
	file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

# cleanup
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/cmake)

# move cmake stuff to be compliant with vcpkg rules
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/libssh)
file(RENAME ${CURRENT_PACKAGES_DIR}/cmake ${CURRENT_PACKAGES_DIR}/share/libssh/cmake)

# move the static libs from the /static subfolders up
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/ssh.lib)
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/static/ssh.lib ${CURRENT_PACKAGES_DIR}/lib/ssh.lib)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/static)

file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/ssh.lib)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/static/ssh.lib ${CURRENT_PACKAGES_DIR}/debug/lib/ssh.lib)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/static)
endif()

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libssh)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libssh/COPYING ${CURRENT_PACKAGES_DIR}/share/libssh/copyright)
