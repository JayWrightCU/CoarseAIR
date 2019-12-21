##==============================================================================================================
# 
# Coarse-Grained QCT for Atmospheric Mixtures (CoarseAIR) 
# 
# Copyright (C) 2018 Simone Venturi and Bruno Lopez (University of Illinois at Urbana-Champaign). 
#
# Based on "VVTC" (Vectorized Variable stepsize Trajectory Code) by David Schwenke (NASA Ames Research Center). 
# 
# This program is free software; you can redistribute it and/or modify it under the terms of the 
# Version 2.1 GNU Lesser General Public License as published by the Free Software Foundation. 
# 
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU Lesser General Public License for more details. 
# 
# You should have received a copy of the GNU Lesser General Public License along with this library; 
# if not, write to the Free Software Foundation, Inc. 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA 
# 
#---------------------------------------------------------------------------------------------------------------
##==============================================================================================================
import os
import sys
import numpy as np

## Paths from where to Import Python Modules
WORKSPACE_PATH = os.environ['WORKSPACE_PATH']
CoarseAIRFldr  = os.environ['COARSEAIR_SOURCE_DIR'] 
#SrcDir    = '/home/venturi/WORKSPACE//CoarseAIR/coarseair/' 
#SrcDir    = '/Users/sventuri/WORKSPACE//CoarseAIR/coarseair/' #os.environ['COARSEAIR_SOURCE_DIR'] 
sys.path.insert(0, CoarseAIRFldr + '/scripts/postprocessing/PyCoarseAIR/Objects/')
sys.path.insert(0, CoarseAIRFldr + '/scripts/postprocessing/PyCoarseAIR/ChemicalSystems/')
sys.path.insert(0, CoarseAIRFldr + '/scripts/postprocessing/PyCoarseAIR/Reading/')
sys.path.insert(0, CoarseAIRFldr + '/scripts/postprocessing/PyCoarseAIR/Writing/')
sys.path.insert(0, CoarseAIRFldr + '/scripts/postprocessing/PyCoarseAIR/Computing/')
sys.path.insert(0, CoarseAIRFldr + '/scripts/postprocessing/PyCoarseAIR/Initializing/')

if (len(sys.argv) > 1):
    InputFile = sys.argv[1]
    print("\n[PyCoarseAIR]: Calling PyCoarseAIR with Input File = ", InputFile)
    sys.path.insert(0, InputFile)
else:
    print("[PyCoarseAIR]: Calling PyCoarseAIR without Input File")
    sys.path.insert(0, CoarseAIRFldr + '/scripts/postprocessing/PyCoarseAIR/InputData/')

from Reading           import Read_Levels, Read_PartFuncsAndEnergies, Read_qnsEnBin, Read_Rates_CGQCT
from Writing           import Write_PartFuncsAndEnergies, Write_Kinetics_FromOverall
from Computing         import Compute_Rates_Thermal_FromOverall
from Initializing      import Initialize_Data
from InputData         import inputdata
##--------------------------------------------------------------------------------------------------------------



##==============================================================================================================
InputData                       = inputdata()
InputData.SystNameLong          = 'O3_UMN'

InputData.TranVec               = np.array([10000])
InputData.iTVec                 = np.arange(1) + 1

InputData.QCTOutFldr            = WORKSPACE_PATH + '/CG-QCT/run_O3_ALL/Test/'
InputData.FinalFldr             = WORKSPACE_PATH + '/Mars_Database/Results/'

InputData.Kin.Read_Flg          = True
InputData.Kin.Write_Flg         = True
InputData.Kin.ReadFldr          = WORKSPACE_PATH + '/Mars_Database/Run_0D/database/'
InputData.Kin.WriteFldr         = WORKSPACE_PATH + '/Mars_Database/Run_0D/database/'
InputData.Kin.WriteDiss_Flg     = False     
InputData.Kin.WriteInel_Flg     = False
InputData.Kin.WriteExch_Flg     = True

InputData.HDF5.ReadFldr         = CoarseAIRFldr + '/Mars_Database/HDF5_Database/'
InputData.HDF5.ForceReadDat_Flg = False
InputData.HDF5.Save_Flg         = True

InputData.PlotShow_Flg          = False

InputData.DelRateMat_Flg        = True
##--------------------------------------------------------------------------------------------------------------



print("\n[PyCoarseAIR]: Initializing Data")

[Syst, Temp] = Initialize_Data(InputData)


print("\n[PyCoarseAIR]: Uploading Data")

Syst = Read_Levels(Syst, InputData)
Syst = Read_qnsEnBin(Syst, InputData)
Syst = Read_PartFuncsAndEnergies(Syst, Temp, InputData)
Syst = Read_Rates_CGQCT(Syst, Temp, InputData)


if (InputData.Kin.Write_Flg):
	Write_PartFuncsAndEnergies(Syst, Temp, InputData)
	#Write_Kinetics_FromOverall(Syst, Temp, InputData)

#Syst = Compute_Rates_Thermal_FromOverall(Syst, Temp, InputData)