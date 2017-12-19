# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/redis-3.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/MSOpenTech/redis/archive/3.0.zip"
    FILENAME "hiredis-3.0.zip"
    SHA512 6710a0475705eef2fa3ac4f2a402e7abfb2b3b9625573367074b816f88e2aa6b4369fd2e2cd69227b8f3c65386cb409ba3e0195cd843a848c5c5faac4c0dc041
)
vcpkg_extract_source_archive(${ARCHIVE})


message(STATUS "+++ Build ${TARGET_TRIPLET}-rel")


file(COPY
${CURRENT_BUILDTREES_DIR}/src/redis-3.0/
DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)

file(COPY
${CURRENT_BUILDTREES_DIR}/src/redis-3.0/
DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)

file(COPY
${CMAKE_CURRENT_LIST_DIR}/hiredis.vcxproj
DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/msvs/hiredis/)

file(COPY
${CMAKE_CURRENT_LIST_DIR}/hiredis.vcxproj
DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/msvs/hiredis/)

file(COPY
${CMAKE_CURRENT_LIST_DIR}/Win32_Interop.vcxproj
DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/src/Win32_Interop/)

file(COPY
${CMAKE_CURRENT_LIST_DIR}/Win32_Interop.vcxproj
DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/src/Win32_Interop/)

message(STATUS "+++ Build ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel")

vcpkg_build_msbuild(
    PROJECT_PATH ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/msvs/hiredis/hiredis.vcxproj
    DEBUG_CONFIGURATION Debug
)

vcpkg_build_msbuild(
    PROJECT_PATH ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/src/Win32_Interop/Win32_Interop.vcxproj
    DEBUG_CONFIGURATION Debug
)

vcpkg_build_msbuild(
    PROJECT_PATH ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/msvs/hiredis/hiredis.vcxproj
    RELEASE_CONFIGURATION Release
)

vcpkg_build_msbuild(
    PROJECT_PATH ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/src/Win32_Interop/Win32_Interop.vcxproj
    RELEASE_CONFIGURATION Release
)


message(STATUS "+++ DONE ${TARGET_TRIPLET}-rel")

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/include/hiredis)


file(COPY
${CMAKE_CURRENT_LIST_DIR}/hiredis.h
DESTINATION ${CURRENT_PACKAGES_DIR}/include/hiredis
)

file(COPY
${CURRENT_BUILDTREES_DIR}/src/redis-3.0/src/Win32_Interop/win32_types_hiredis.h
DESTINATION ${CURRENT_PACKAGES_DIR}/include/hiredis
)

file(INSTALL
   ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/msvs/hiredis/Win32/Debug/hiredis.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib
)
file(INSTALL
    ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/msvs/hiredis/Win32/Release/hiredis.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/lib
)

file(INSTALL
    ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/src/Win32_Interop/Win32/Debug/Win32_Interop.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib
)
file(INSTALL
    ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/src/Win32_Interop/Win32/Release/Win32_Interop.lib
    DESTINATION ${CURRENT_PACKAGES_DIR}/lib
)

file(INSTALL ${CURRENT_BUILDTREES_DIR}/src/redis-3.0/license.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/hiredis RENAME copyright)


