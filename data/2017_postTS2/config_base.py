import FWCore.ParameterSet.Config as cms

ppsStripEfficiencyEstimator = cms.EDAnalyzer("PPSStripEfficiencyEstimator",
    tagStripHits = cms.InputTag("totemRPRecHitProducer"),
    tagStripPatterns = cms.InputTag("totemRPUVPatternFinder"),
    tagStripTracks = cms.InputTag("totemRPLocalTrackFitter"),

    timestamp_min = cms.uint32(1451602800 + 24*3600*640),
    timestamp_max = cms.uint32(1451602800 + 24*3600*680),
    timestamp_bs = cms.uint32(5*60),

    rpId_45_F = cms.uint32(23),
    rpId_45_N = cms.uint32(3),
    rpId_56_N = cms.uint32(103),
    rpId_56_F = cms.uint32(123),

    outputFile = cms.string("output.root"),
)
