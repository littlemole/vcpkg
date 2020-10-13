# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/mustache-0.0.1)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kainjow/Mustache
    REF v4.1
    SHA512 609c876fc085d1331355ec1f0396e588edf1fb3ea6765abcd06043cc5f7288f015d6bb7fdeb560df78aab54ae8d97e934375de577b944a09c9ae93f9915e7aff
    HEAD_REF master
)




file(COPY ${SOURCE_PATH}/mustache.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include/)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/mustache RENAME copyright)


# file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
