function(git_get_changeset_id VAR)
	find_package(Git QUIET)
	if (GIT_FOUND)
		execute_process(WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
			COMMAND "${GIT_EXECUTABLE}" "rev-parse" "HEAD"
			RESULT_VARIABLE GIT_RESULT
			OUTPUT_VARIABLE C4REVISION
			OUTPUT_STRIP_TRAILING_WHITESPACE
			ERROR_QUIET)

		if(GIT_RESULT EQUAL 0)
			string(SUBSTRING "${C4REVISION}" 0 12 C4REVISION)
			execute_process(WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
				COMMAND "${GIT_EXECUTABLE}" "status" "--porcelain"
				OUTPUT_VARIABLE GIT_STATUS
			)
			string(REGEX MATCH "^[MADRC ][MD ]" WORKDIR_DIRTY "${GIT_STATUS}")
		endif()
	endif()
	if (NOT C4REVISION)
		# Git not found or not a git workdir
		file(STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/.git_archival" C4REVISION
			LIMIT_COUNT 1
			REGEX "node: [0-9a-f]+"
		)
		string(SUBSTRING "${C4REVISION}" 6 12 C4REVISION)
	endif()
	if(WORKDIR_DIRTY)
		set(C4REVISION "${C4REVISION}+")
	endif()
	set(${VAR} "${C4REVISION}" PARENT_SCOPE)
endfunction()
