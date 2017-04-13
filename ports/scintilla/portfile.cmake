# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/scintilla)

message(STATUS "+++ ${SOURCE_PATH}")

vcpkg_download_distfile(ARCHIVE
    URLS "http://www.scintilla.org/scintilla374.tgz"
    FILENAME "scintilla-3.7.4.tgz"
    SHA512 856750ce7e4252d00ca1a1d76754afae27cbe24a2a32ecca67e87eb90f2c4d88f5f485f5331e6294fdd43310966af2420f8d3cd6529fe9665892105e034d3e81
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY
${CURRENT_BUILDTREES_DIR}/src/scintilla/
DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)

file(COPY
${CMAKE_CURRENT_LIST_DIR}/scintilla.mak
DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/win32)

file(COPY
${CURRENT_BUILDTREES_DIR}/src/scintilla/
DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)

file(COPY
${CMAKE_CURRENT_LIST_DIR}/scintilla.mak
DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/win32)

message(STATUS "+++ Build ${TARGET_TRIPLET}")

if(TARGET_TRIPLET MATCHES "x86-windows-static")
    set(ARCH "x86")
    set(STATIC_BUILD "1")
elseif(TARGET_TRIPLET MATCHES "x64-windows-static")
    set(ARCH "x64")
    set(STATIC_BUILD "1")
elseif(TARGET_TRIPLET MATCHES "x86-windows")
    set(ARCH "x86")
    set(TARGET "dll")
elseif(TARGET_TRIPLET MATCHES "x64-windows")
    set(ARCH "x64")
    set(TARGET "dll")
else()
    message(FATAL_ERROR "Unsupported target triplet: ${TARGET_TRIPLET}")
endif()


message(STATUS "+++ Build ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET} ${SCINTILLA_MAKE} RELEASE")

vcpkg_execute_required_process(
    COMMAND nmake ARCH=${ARCH} TARGET=${TARGET} MODE=release /E /P /F scintilla.mak  
    WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Win32
    LOGNAME build-${TARGET_TRIPLET}-rel
)

file(COPY
${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/bin/SciLexer.lib
DESTINATION ${CURRENT_PACKAGES_DIR}/lib)

file(COPY
${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/bin/Scintilla.lib
DESTINATION ${CURRENT_PACKAGES_DIR}/lib)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)

file(COPY
${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/bin/SciLexer.dll
DESTINATION ${CURRENT_PACKAGES_DIR}/bin)

file(COPY
${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/bin/Scintilla.dll
DESTINATION ${CURRENT_PACKAGES_DIR}/bin)

endif()



message(STATUS "+++ Build ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET} ${SCINTILLA_MAKE} DEBUG")

vcpkg_execute_required_process(
    COMMAND nmake ARCH=${ARCH} TARGET=${TARGET} MODE=debug DEBUG=1 /E /P /F scintilla.mak  
    WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Win32
    LOGNAME build-${TARGET_TRIPLET}-dbg
)

message(STATUS "+++ DONE ${TARGET_TRIPLET}-rel")

file(COPY
${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/bin/SciLexer.lib
DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

file(COPY
${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/bin/Scintilla.lib
DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)

file(COPY
${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/bin/SciLexer.dll
DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)

file(COPY
${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/bin/Scintilla.dll
DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)

endif()

file(COPY
${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/include
DESTINATION ${CURRENT_PACKAGES_DIR}/include)

file(RENAME ${CURRENT_PACKAGES_DIR}/include/include ${CURRENT_PACKAGES_DIR}/include/scintilla)


# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE.TXT DESTINATION ${CURRENT_PACKAGES_DIR}/share/scintilla/)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/scintilla/LICENSE.TXT ${CURRENT_PACKAGES_DIR}/share/scintilla/copyright)
