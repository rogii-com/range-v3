message(
    STATUS
    "ENV{ENV_INSTALL} = $ENV{ENV_INSTALL}"
)

if(NOT DEFINED ENV{ENV_INSTALL})
    message(
        FATAL_ERROR
        "You have to specify an install path via `ENV_INSTALL' variable."
    )
endif()

file(
    TO_CMAKE_PATH
    "$ENV{ENV_INSTALL}"
    ROOT
)

include(
    "${CMAKE_CURRENT_LIST_DIR}/build_common.cmake"
)