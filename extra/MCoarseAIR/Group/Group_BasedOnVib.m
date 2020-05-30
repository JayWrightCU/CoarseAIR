%% Group the Levels Based on Centrifugal Barrier
%
function [LevelToGroup] = Group_BasedOnVib(iMol)    
    
    %%==============================================================================================================
    % 
    % Coarse-Grained method for Quasi-Classical Trajectories (CG-QCT) 
    % 
    % Copyright (C) 2018 Simone Venturi and Bruno Lopez (University of Illinois at Urbana-Champaign). 
    %
    % Based on "VVTC" (Vectorized Variable stepsize Trajectory Code) by David Schwenke (NASA Ames Research Center). 
    % 
    % This program is free software; you can redistribute it and/or modify it under the terms of the 
    % Version 2.1 GNU Lesser General Public License as published by the Free Software Foundation. 
    % 
    % This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
    % without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
    % See the GNU Lesser General Public License for more details. 
    % 
    % You should have received a copy of the GNU Lesser General Public License along with this library; 
    % if not, write to the Free Software Foundation, Inc. 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA 
    % 
    %---------------------------------------------------------------------------------------------------------------
    %%==============================================================================================================

    global Input Kin Param Syst Temp Rates

    fprintf('  = Group_BasedOnVib =================================\n')
    fprintf('  ====================================================\n')
    
    LevelToGroup = zeros(Syst.Molecule(iMol).NLevels,1);
    for iLevels = 1:Syst.Molecule(iMol).NLevels
      LevelToGroup(iLevels) = Syst.Molecule(iMol).Levelvqn(iLevels) + 1;
    end    
    
    fprintf('  Nb Bins = %i \n', max(LevelToGroup) );
    
    fprintf('  ====================================================\n\n')
    
end