if(
    NOT DEFINED ROOT
)
    message(
        FATAL_ERROR
        "Assert: ROOT = ${ROOT}"
    )
endif()

set(
    PROJECT_ROOT_PATH
    "${CMAKE_CURRENT_LIST_DIR}/.."
)

set(
    ROGII_FOLDER_PATH
    "${CMAKE_CURRENT_LIST_DIR}"
)

include(${ROGII_FOLDER_PATH}/version.cmake)

set(
    BUILD
    0
)

if(DEFINED ENV{BUILD_NUMBER})
    set(
        BUILD
        $ENV{BUILD_NUMBER}
    )
endif()

set(
    TAG
    ""
)

if(DEFINED ENV{TAG})
    set(
        TAG
        "$ENV{TAG}"
    )
else()
    find_package(
        Git
    )

    if(Git_FOUND)
        execute_process(
            COMMAND
                ${GIT_EXECUTABLE} rev-parse --short HEAD
            OUTPUT_VARIABLE
                TAG
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        set(
            TAG
            "_${TAG}"
        )
    endif()
endif()

set(
    ARCH
    "anycpu"
)

set(
    PACKAGE_NAME
    "range_v3-${ROGII_PKG_VERSION}-${ARCH}-${BUILD}${TAG}"
)

set(
    BUILD_PATH
    "${PROJECT_ROOT_PATH}/build"
)

file(
    MAKE_DIRECTORY
    "${BUILD_PATH}"
)

set(
    CMAKE_INSTALL_PREFIX
    "${ROOT}/${PACKAGE_NAME}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -G Ninja -DCMAKE_BUILD_TYPE=Release -DRANGE_V3_DOCS=OFF -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} ${PROJECT_ROOT_PATH}
    WORKING_DIRECTORY
        "${BUILD_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build . --target install
    WORKING_DIRECTORY
        "${BUILD_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build . --target test
    WORKING_DIRECTORY
        "${BUILD_PATH}"
)

configure_file(
    "${ROGII_FOLDER_PATH}/template__package.cmake"
    "${CMAKE_INSTALL_PREFIX}/package.cmake"
    @ONLY
)

file(
    REMOVE_RECURSE
    "${BUILD_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
        "${ROOT}"
)
