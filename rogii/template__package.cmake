find_package(
    range-v3
    @ROGII_PKG_VERSION@
        EXACT
    REQUIRED
    CONFIG
    PATHS
        "${CMAKE_CURRENT_LIST_DIR}"
    NO_DEFAULT_PATH
)

unset(
    range-v3_DIR
    CACHE
)
