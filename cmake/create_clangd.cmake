# Collect all currently added targets in all subdirectories
#
# Parameters: - _result the list containing all found targets - _dir root
# directory to start looking from
function(get_all_targets _result _dir)
    get_property(
            _subdirs
            DIRECTORY "${_dir}"
            PROPERTY SUBDIRECTORIES)
    foreach (_subdir IN LISTS _subdirs)
        get_all_targets(${_result} "${_subdir}")
    endforeach ()

    get_directory_property(_sub_targets DIRECTORY "${_dir}" BUILDSYSTEM_TARGETS)
    set(${_result}
            ${${_result}} ${_sub_targets}
            PARENT_SCOPE)
endfunction()

option(SUPPORT_CLANGD "Support clangd" ON)
if (SUPPORT_CLANGD)
    set(CLANGD_SRC ${CMAKE_CURRENT_SOURCE_DIR}/cmake/.clangd.in)
    set(CLANGD_DEST ${CMAKE_CURRENT_SOURCE_DIR}/.clangd)
    if (EMSCRIPTEN)
        set(CMAKE_EXPORT_COMPILE_COMMANDS OFF)
        set(CMAKE_EXPORT_COMPILE_COMMANDS
                OFF
                CACHE INTERNAL "")
        file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/compile_commands)
        get_all_targets(all_targets ${CMAKE_CURRENT_SOURCE_DIR})
        # set(all_targets ${PROJECT_NAME})
        foreach (t ${all_targets})
            get_target_property(t_sources ${t} SOURCES)
            get_target_property(t_source_dir ${t} SOURCE_DIR)
            foreach (s ${t_sources})
                file(REAL_PATH "${s}" s BASE_DIRECTORY "${t_source_dir}")
                message(STATUS "${s}: add_compile_command in ${t_source_dir}")
                string(MD5 s_name "${s}")
                set_source_files_properties(
                        ${s} TARGET_DIRECTORY ${t}
                        PROPERTIES
                        COMPILE_FLAGS
                        "-MJ ${CMAKE_CURRENT_BINARY_DIR}/compile_commands/compile_commands_${s_name}.json"
                )
                set_property(
                        TARGET ${PROJECT_NAME}
                        APPEND
                        PROPERTY
                        ADDITIONAL_CLEAN_FILES
                        "${CMAKE_CURRENT_BINARY_DIR}/compile_commands/compile_commands_${s_name}.json"
                )
            endforeach ()
        endforeach ()
        add_custom_command(
                TARGET ${PROJECT_NAME}
                POST_BUILD
                COMMAND
                ${CMAKE_COMMAND}
                -DSOURCES_ARG="${CMAKE_CURRENT_BINARY_DIR}/compile_commands/" -P
                ${CMAKE_CURRENT_SOURCE_DIR}/cmake/merge_compile_commands.cmake)
    else ()
        set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
        set(CMAKE_EXPORT_COMPILE_COMMANDS
                ON
                CACHE INTERNAL "")
        set(CLANGD_FLAGS_TO_ADD "")
    endif (EMSCRIPTEN)
    configure_file(${CLANGD_SRC} ${CLANGD_DEST} @ONLY)
    message(STATUS "exp: ${CMAKE_EXPORT_COMPILE_COMMANDS}")
endif ()
