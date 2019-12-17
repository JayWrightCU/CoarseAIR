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
import numpy as np

from Atom     import atom
from Molecule import molecule
from Pair     import pair
from CFDComp  import cfdcomp


class system(object):

    def __init__(self, SystNames, NAtoms, NMolecules, NPairs, NCFDComp, NTTran):

        self.Name         = SystNames

        self.NAtoms       = NAtoms
        self.Atom         = [atom() for iA in range(NAtoms)]

        self.NMolecules   = NMolecules
        self.Molecule     = [molecule(NTTran) for iMol in range(NMolecules)]

        self.NPairs       = NPairs
        self.Pair         = [pair() for iP in range(NPairs)]

        self.NCFDComp     = NCFDComp
        self.CFDComp      = [cfdcomp() for iComp in range(NCFDComp)]
        self.MolToCFDComp = 0

        self.PathToFolder = ''