cmake_minimum_required(VERSION 3.20)
project(LodMod C CXX RC)

set(SRC ${CMAKE_SOURCE_DIR}/Automata-LodMod)
set(CMAKE_CXX_STANDARD 20)

file(GLOB CPP_SOURCES ${SRC}/*.cpp)
list(REMOVE_ITEM CPP_SOURCES ${SRC}/pch.cpp)

set(MINHOOK_SOURCES
  ${SRC}/third_party/MinHook/buffer.c
  ${SRC}/third_party/MinHook/hook.c
  ${SRC}/third_party/MinHook/trampoline.c
  ${SRC}/third_party/MinHook/hde/hde32.c
  ${SRC}/third_party/MinHook/hde/hde64.c)

# Resource.rc is UTF-16 — MSVC's rc.exe handles it natively, no iconv hack needed.
add_library(lodmod SHARED
  ${CPP_SOURCES} ${MINHOOK_SOURCES}
  ${SRC}/Resource.rc
  ${SRC}/proxy.def)

# MSVC doesn't add a "lib" prefix, so just set the output name.
set_target_properties(lodmod PROPERTIES OUTPUT_NAME "xinput1_4")

set(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} /I${SRC}")

target_include_directories(lodmod PRIVATE ${SRC})

target_compile_definitions(lodmod PRIVATE
  LODMOD_EXPORTS _WINDOWS _USRDLL UNICODE _UNICODE
  _SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING)

# Force-include pch.h in every C++ source (MSVC equivalent of GCC's -include).
target_compile_options(lodmod PRIVATE
  "$<$<COMPILE_LANGUAGE:CXX>:/FIcmath>"
  "$<$<COMPILE_LANGUAGE:CXX>:/FIcstring>"
  "$<$<COMPILE_LANGUAGE:CXX>:/FIcstdlib>"
  "$<$<COMPILE_LANGUAGE:CXX>:/FI${SRC}/pch.h>")

# /FORCE:MULTIPLE replaces --allow-multiple-definition.
# /INCREMENTAL:NO and /OPT:* match the intent of the old -ffunction-sections -Wl,--gc-sections.
target_link_options(lodmod PRIVATE
  /INCREMENTAL:NO
  /OPT:REF
  /OPT:ICF
  /FORCE:MULTIPLE)

target_link_directories(lodmod PRIVATE ${SRC})
target_link_libraries(lodmod PRIVATE mfplat mfuuid shell32)
# If you want to build with H264 support, comment out the previous line, and uncomment the line below.
# Also uncomment the "#define CRI_H264_SUPPORT 1" line in the CriH264.cpp file in the Automata-LodMod folder.
#target_link_libraries(lodmod PRIVATE mfplat mfuuid shell32 cri_mana_pcx64)
