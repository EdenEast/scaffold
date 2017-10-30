
# message with [Scafold]: prefix
macro(sf_message x)
    message("-- [Scafold]: ${x}")
endmacro()

macro(sf_warning_message x)
    message(WARNING "-- [Scaffold]: ${x}")
endmacro()

macro(sf_error_message x)
    message(SEND_ERROR "-- [Scaffold]: ${x}")
endmacro()

macro(sf_fatal_error_message x)
    message(FATAL_ERROR "-- [Scaffold]: ${x}")
endmacro()