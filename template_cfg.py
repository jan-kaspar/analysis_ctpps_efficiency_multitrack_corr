import sys 
import os
import FWCore.ParameterSet.Config as cms

sys.path.append(os.path.relpath("./"))
sys.path.append(os.path.relpath("../../../../"))

process = cms.Process("PPSStripEfficiencyEstimation")

# minimum of logs
process.MessageLogger = cms.Service("MessageLogger",
  statistics = cms.untracked.vstring(),
  destinations = cms.untracked.vstring("cout"),
  cout = cms.untracked.PSet(
    threshold = cms.untracked.string("WARNING")
  )
)

# input data 
from input_files import input_files
process.source = cms.Source("PoolSource",
  fileNames = input_files
)

# number of events to process
process.maxEvents = cms.untracked.PSet(
  input = cms.untracked.int32(-1)
)

# efficiency-estimator config
process.load("config_base")

# processing sequence
process.path = cms.Path(
    process.ppsStripEfficiencyEstimator
)
