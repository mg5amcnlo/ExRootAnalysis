
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

ExRootHEPEVTConverter$(ExeSuf): \
	tmp/test/ExRootHEPEVTConverter.$(ObjSuf)
tmp/test/ExRootHEPEVTConverter.$(ObjSuf): \
	test/ExRootHEPEVTConverter.cpp \
	ExRootAnalysis/ExRootClasses.h \
	ExRootAnalysis/ExRootTreeReader.h \
	ExRootAnalysis/ExRootTreeWriter.h \
	ExRootAnalysis/ExRootTreeBranch.h \
	ExRootAnalysis/ExRootUtilities.h
ExRootLHCOlympicsConverter$(ExeSuf): \
	tmp/test/ExRootLHCOlympicsConverter.$(ObjSuf)
tmp/test/ExRootLHCOlympicsConverter.$(ObjSuf): \
	test/ExRootLHCOlympicsConverter.cpp \
	ExRootAnalysis/ExRootStream.h \
	ExRootAnalysis/ExRootClasses.h \
	ExRootAnalysis/ExRootTreeWriter.h \
	ExRootAnalysis/ExRootTreeBranch.h \
	ExRootAnalysis/ExRootProgressBar.h
ExRootLHEFConverter$(ExeSuf): \
	tmp/test/ExRootLHEFConverter.$(ObjSuf)
tmp/test/ExRootLHEFConverter.$(ObjSuf): \
	test/ExRootLHEFConverter.cpp \
	ExRootAnalysis/ExRootClasses.h \
	ExRootAnalysis/ExRootLHEFReader.h \
	ExRootAnalysis/ExRootTreeWriter.h \
	ExRootAnalysis/ExRootTreeBranch.h \
	ExRootAnalysis/ExRootProgressBar.h
ExRootSTDHEPConverter$(ExeSuf): \
	tmp/test/ExRootSTDHEPConverter.$(ObjSuf)
tmp/test/ExRootSTDHEPConverter.$(ObjSuf): \
	test/ExRootSTDHEPConverter.cpp \
	ExRootAnalysis/ExRootClasses.h \
	ExRootAnalysis/ExRootSTDHEPReader.h \
	ExRootAnalysis/ExRootTreeWriter.h \
	ExRootAnalysis/ExRootTreeBranch.h \
	ExRootAnalysis/ExRootProgressBar.h
Example$(ExeSuf): \
	tmp/test/Example.$(ObjSuf)
tmp/test/Example.$(ObjSuf): \
	test/Example.cpp \
	ExRootAnalysis/ExRootClasses.h \
	ExRootAnalysis/ExRootTreeReader.h \
	ExRootAnalysis/ExRootTreeWriter.h \
	ExRootAnalysis/ExRootTreeBranch.h \
	ExRootAnalysis/ExRootResult.h \
	ExRootAnalysis/ExRootUtilities.h
EXECUTABLE +=  \
	ExRootHEPEVTConverter$(ExeSuf) \
	ExRootLHCOlympicsConverter$(ExeSuf) \
	ExRootLHEFConverter$(ExeSuf) \
	ExRootSTDHEPConverter$(ExeSuf) \
	Example$(ExeSuf)
EXECUTABLE_OBJ +=  \
	tmp/test/ExRootHEPEVTConverter.$(ObjSuf) \
	tmp/test/ExRootLHCOlympicsConverter.$(ObjSuf) \
	tmp/test/ExRootLHEFConverter.$(ObjSuf) \
	tmp/test/ExRootSTDHEPConverter.$(ObjSuf) \
	tmp/test/Example.$(ObjSuf)
tmp/src/ExRootAnalysisDict.$(SrcSuf): \
	src/ExRootAnalysisLinkDef.h \
	ExRootAnalysis/ExRootClasses.h \
	ExRootAnalysis/ExRootTreeReader.h \
	ExRootAnalysis/ExRootTreeWriter.h \
	ExRootAnalysis/ExRootTreeBranch.h \
	ExRootAnalysis/ExRootResult.h \
	ExRootAnalysis/ExRootUtilities.h \
	ExRootAnalysis/ExRootClassifier.h \
	ExRootAnalysis/ExRootFilter.h \
	ExRootAnalysis/ExRootFactory.h
tmp/src/ExRootAnalysisDict$(PcmSuf): \
	tmp/src/ExRootAnalysisDict.$(SrcSuf)
ExRootAnalysisDict$(PcmSuf): \
	tmp/src/ExRootAnalysisDict$(PcmSuf)
DICT_OBJ +=  \
	tmp/src/ExRootAnalysisDict.$(ObjSuf)
DICT_PCM +=  \
	ExRootAnalysisDict$(PcmSuf)
tmp/src/ExRootClasses.$(ObjSuf): \
	src/ExRootClasses.$(SrcSuf) \
	ExRootAnalysis/ExRootClasses.h
tmp/src/ExRootFactory.$(ObjSuf): \
	src/ExRootFactory.$(SrcSuf) \
	ExRootAnalysis/ExRootTreeWriter.h \
	ExRootAnalysis/ExRootTreeBranch.h \
	ExRootAnalysis/ExRootFactory.h
tmp/src/ExRootFilter.$(ObjSuf): \
	src/ExRootFilter.$(SrcSuf) \
	ExRootAnalysis/ExRootFilter.h \
	ExRootAnalysis/ExRootClassifier.h
tmp/src/ExRootLHEFReader.$(ObjSuf): \
	src/ExRootLHEFReader.$(SrcSuf) \
	ExRootAnalysis/ExRootLHEFReader.h \
	ExRootAnalysis/ExRootClasses.h \
	ExRootAnalysis/ExRootFactory.h \
	ExRootAnalysis/ExRootStream.h \
	ExRootAnalysis/ExRootTreeBranch.h
tmp/src/ExRootProgressBar.$(ObjSuf): \
	src/ExRootProgressBar.$(SrcSuf) \
	ExRootAnalysis/ExRootProgressBar.h
tmp/src/ExRootResult.$(ObjSuf): \
	src/ExRootResult.$(SrcSuf) \
	ExRootAnalysis/ExRootResult.h \
	ExRootAnalysis/ExRootUtilities.h
tmp/src/ExRootSTDHEPReader.$(ObjSuf): \
	src/ExRootSTDHEPReader.$(SrcSuf) \
	ExRootAnalysis/ExRootSTDHEPReader.h \
	ExRootAnalysis/ExRootClasses.h \
	ExRootAnalysis/ExRootFactory.h \
	ExRootAnalysis/ExRootTreeBranch.h
tmp/src/ExRootStream.$(ObjSuf): \
	src/ExRootStream.$(SrcSuf) \
	ExRootAnalysis/ExRootStream.h
tmp/src/ExRootTreeBranch.$(ObjSuf): \
	src/ExRootTreeBranch.$(SrcSuf) \
	ExRootAnalysis/ExRootTreeBranch.h
tmp/src/ExRootTreeReader.$(ObjSuf): \
	src/ExRootTreeReader.$(SrcSuf) \
	ExRootAnalysis/ExRootTreeReader.h
tmp/src/ExRootTreeWriter.$(ObjSuf): \
	src/ExRootTreeWriter.$(SrcSuf) \
	ExRootAnalysis/ExRootTreeWriter.h \
	ExRootAnalysis/ExRootTreeBranch.h
tmp/src/ExRootUtilities.$(ObjSuf): \
	src/ExRootUtilities.$(SrcSuf) \
	ExRootAnalysis/ExRootUtilities.h
SHARED_OBJ +=  \
	tmp/src/ExRootClasses.$(ObjSuf) \
	tmp/src/ExRootFactory.$(ObjSuf) \
	tmp/src/ExRootFilter.$(ObjSuf) \
	tmp/src/ExRootLHEFReader.$(ObjSuf) \
	tmp/src/ExRootProgressBar.$(ObjSuf) \
	tmp/src/ExRootResult.$(ObjSuf) \
	tmp/src/ExRootSTDHEPReader.$(ObjSuf) \
	tmp/src/ExRootStream.$(ObjSuf) \
	tmp/src/ExRootTreeBranch.$(ObjSuf) \
	tmp/src/ExRootTreeReader.$(ObjSuf) \
	tmp/src/ExRootTreeWriter.$(ObjSuf) \
	tmp/src/ExRootUtilities.$(ObjSuf)

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


