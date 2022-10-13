#!/usr/bin/env tclsh

set prefix "tmp/"
set suffix " \\\n\t"

set srcSuf {.$(SrcSuf)}
set objSuf {.$(ObjSuf)}
set pcmSuf {$(PcmSuf)}
set exeSuf {$(ExeSuf)}

proc dependencies {fileName firstLine {force 1} {command {}}} {
  global suffix headerFiles sourceFiles

  if {[info exists sourceFiles($fileName)]} return

  set sourceFiles($fileName) 1

  set list {}
  set fid [open $fileName]
  while {! [eof $fid]} {
    set line [gets $fid]
    if [regexp -- {^\s*#include\s*"((\w+/)+\w+\.(h|hh))"} $line] {
      set elements [split $line {"}]
      set file [lindex $elements 1]
      if [file exists $file] {
        lappend list $file
        set headerFiles($file) 1
      }
    }
  }

  if {[llength $list] > 0} {
    puts -nonewline $firstLine
    foreach file $list {puts -nonewline $suffix$file}
    if {$command != {}} {
      puts {}
      puts -nonewline $command
    }
    puts {}
  } elseif {$force} {
    puts -nonewline $firstLine
    if {$command != {}} {
      puts {}
      puts -nonewline $command
    }
    puts {}
  }

  close $fid
}

proc dictDeps {dictPrefix args} {

  global prefix suffix srcSuf objSuf pcmSuf

  set dict [lsort [eval glob -nocomplain $args]]

  set dictSrcFiles {}
  set dictObjFiles {}

  foreach fileName $dict {
    regsub {LinkDef\.h} $fileName {Dict} dictName
    set dictName $prefix$dictName

    lappend dictSrcFiles $dictName$srcSuf
    lappend dictObjFiles $dictName$objSuf
    lappend dictPcmFiles [file tail $dictName$pcmSuf]

    dependencies $fileName "$dictName$srcSuf:$suffix$fileName"

    puts -nonewline $dictName$pcmSuf:$suffix
    puts $dictName$srcSuf

    puts -nonewline [file tail $dictName$pcmSuf]:$suffix
    puts $dictName$pcmSuf
  }

  puts -nonewline "${dictPrefix}_OBJ += $suffix"
  puts [join $dictObjFiles $suffix]

  puts -nonewline "${dictPrefix}_PCM += $suffix"
  puts [join $dictPcmFiles $suffix]
}

proc sourceDeps {srcPrefix args} {

  global prefix suffix srcSuf objSuf

  set source [lsort [eval glob -nocomplain $args]]

  set srcObjFiles {}

  foreach fileName $source {
    regsub {\.cc} $fileName {} srcName
    set srcObjName $prefix$srcName

    lappend srcObjFiles $srcObjName$objSuf

    dependencies $fileName "$srcObjName$objSuf:$suffix$srcName$srcSuf"
  }

  puts -nonewline "${srcPrefix}_OBJ += $suffix"
  puts [join $srcObjFiles $suffix]
}

proc executableDeps {args} {

  global prefix suffix objSuf exeSuf

  set executable [lsort [eval glob -nocomplain $args]]

  set exeFiles {}

  foreach fileName $executable {
    regsub {\.cpp} $fileName {} exeObjName
    set exeObjName $prefix$exeObjName
    set exeName [file tail $exeObjName]

    lappend exeFiles $exeName$exeSuf
    lappend exeObjFiles $exeObjName$objSuf

    puts "$exeName$exeSuf:$suffix$exeObjName$objSuf"

    dependencies $fileName "$exeObjName$objSuf:$suffix$fileName"
  }

  if [info exists exeFiles] {
    puts -nonewline "EXECUTABLE += $suffix"
    puts [join $exeFiles $suffix]
  }
  if [info exists exeObjFiles] {
    puts -nonewline "EXECUTABLE_OBJ += $suffix"
    puts [join $exeObjFiles $suffix]
  }
}

proc headerDeps {} {
  global suffix headerFiles

  foreach fileName [array names headerFiles] {
    dependencies $fileName "$fileName:" 0 "\t@touch \$@"
  }
}

puts {
#
# Makefile for ExRootAnalysis
#
# Author: P. Demin - UCL, Louvain-la-Neuve
#
# multi-platform configuration is taken from ROOT (root/test/Makefile.arch)
#

include doc/Makefile.arch

ROOT_MAJOR := $(shell $(RC) --version | cut -d'.' -f1)

SrcSuf = cc
PcmSuf = _rdict.pcm

CXXFLAGS += $(ROOTCFLAGS) -Wno-write-strings -D_FILE_OFFSET_BITS=64 -DDROP_CGAL -I.
LIBS = $(ROOTLIBS)

###

SHARED = libExRootAnalysis.$(DllSuf)
SHAREDLIB = libExRootAnalysis.lib

all:
}

executableDeps {test/*.cpp}

dictDeps {DICT} {src/*LinkDef.h}

sourceDeps {SHARED} {src/*.cc}

headerDeps

puts {
###

ifeq ($(ROOT_MAJOR),6)
all: $(SHARED) $(DICT_PCM) $(EXECUTABLE)
else
all: $(SHARED) $(EXECUTABLE)
endif

$(SHARED): $(DICT_OBJ) $(SHARED_OBJ)
	@mkdir -p $(@D)
	@echo ">> Building $@"
ifeq ($(PLATFORM),macosx)
	@$(LD) $(SOFLAGS)$@ $(LDFLAGS) $^ $(OutPutOpt) $@ $(LIBS)
else
ifeq ($(PLATFORM),win32)
	@bindexplib $* $^ > $*.def
	@lib -nologo -MACHINE:IX86 $^ -def:$*.def $(OutPutOpt)$(SHAREDLIB)
	@$(LD) $(SOFLAGS) $(LDFLAGS) $^ $*.exp $(LIBS) $(OutPutOpt)$@
	@$(MT_DLL)
else
	@$(LD) $(SOFLAGS) $(LDFLAGS) $^ $(OutPutOpt) $@ $(LIBS)
endif
endif

clean:
	@rm -f $(DICT_OBJ) $(SHARED_OBJ) core
	@rm -rf tmp

distclean: clean
	@rm -f $(SHARED) $(SHAREDLIB) $(DICT_PCM) $(EXECUTABLE)

###

.SUFFIXES: .$(SrcSuf) .$(ObjSuf) .$(DllSuf) $(PcmSuf)

%Dict.$(SrcSuf):
	@mkdir -p $(@D)
	@echo ">> Generating $@"
	@rootcint -f $@ -c -Iexternal $<
	@mv $@ $@.base
	@cat $< $@.base > $@
	@rm $@.base

$(DICT_PCM): %Dict$(PcmSuf):
	@echo ">> Copying $@"
	@cp $< $@

$(SHARED_OBJ): tmp/%.$(ObjSuf): %.$(SrcSuf)
	@mkdir -p $(@D)
	@echo ">> Compiling $<"
	@$(CXX) $(CXXFLAGS) -c $< $(OutPutOpt)$@

$(DICT_OBJ): %.$(ObjSuf): %.$(SrcSuf)
	@mkdir -p $(@D)
	@echo ">> Compiling $<"
	@$(CXX) $(CXXFLAGS) -c $< $(OutPutOpt)$@

$(EXECUTABLE_OBJ): tmp/%.$(ObjSuf): %.cpp
	@mkdir -p $(@D)
	@echo ">> Compiling $<"
	@$(CXX) $(CXXFLAGS) -c $< $(OutPutOpt)$@

$(EXECUTABLE): %$(ExeSuf): $(DICT_OBJ) $(SHARED_OBJ)
	@echo ">> Building $@"
	@$(LD) $(LDFLAGS) $^ $(LIBS) $(OutPutOpt)$@

###

}
