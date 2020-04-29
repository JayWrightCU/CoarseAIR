%% Compute Initial and Final Instants of Quasi-Steady State
%
%  Input Global Var: - Temp.TNowChar
%                    - Syst.HDF5_File
%
function Compute_QSS()

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
    
    global Input Rates Syst Temp Param Kin
    
  
    KQSS_Eps = 1.e-9;
    EpsT     = 5.e-4;%5.e-8;
    EpsTT    = 1.e-3;
    InpPerc  = 0.1;

    
    yy       = Rates.T(Temp.iT).DissGlobal;


    iQSS = 1;
    while (yy(iQSS) <= yy(1) + 0.1*(yy(end) - yy(1)))
        iQSS = iQSS + 1;
    end
    while ( abs(log10(yy(iQSS)) - log10(yy(iQSS+1))) / abs(log10(yy(iQSS))) > EpsT ) && ( iQSS < length(yy)-3)
        iQSS = iQSS + 1;
    end
    iQSS_Start = iQSS - 1;
    while ( abs(log10(yy(iQSS)) - log10(yy(iQSS+1))) / abs(log10(yy(iQSS))) <= EpsTT ) && ( iQSS < length(yy)-3)
        iQSS = iQSS + 1;
    end
    iQSS_End = iQSS - 1;
    
    iQSS                 = floor( (iQSS_Start + iQSS_End) / 2.0 );
    Kin.T(Temp.iT).QSS.i = iQSS;
    
    
    iStart = 1;
    while (yy(iStart) < yy(iQSS)/6)
        iStart = iStart + 1;
    end
    iEnd = size(yy,1);%iQSS;
    %   while (abs(yy(iEnd) - yy(iQSS))/yy(iQSS) < (1.0+InpPerc+0.05))
    %     iEnd = iEnd + 1;
    %   end

    
    clear fitresult yyy
    yyy(iStart:iEnd)  = yy(iStart:iEnd) - yy(iQSS)*(1.0-InpPerc);
    [xData, yData] = prepareCurveData( Kin.T(Temp.iT).t(iStart:iEnd), yyy(iStart:iEnd) );
    ft = 'splineinterp';
    [fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );
    Kin.T(Temp.iT).QSS.tStart = fzero(fitresult, Kin.T(Temp.iT).t(iQSS)/3.0);

    clear fitresult yyy xData yData
    yyy(iStart:iEnd)  = yy(iStart:iEnd) - yy(iQSS)*(1.0+InpPerc);
    [xData, yData] = prepareCurveData( Kin.T(Temp.iT).t(iStart:iEnd), yyy(iStart:iEnd) );
    ft = 'splineinterp';
    [fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );
    Kin.T(Temp.iT).QSS.tEnd   = fzero(fitresult, Kin.T(Temp.iT).t(iQSS)*5);


    it = 1;
    while Kin.T(Temp.iT).t(it) < Kin.T(Temp.iT).QSS.tStart
        it = it + 1;
    end
    Kin.T(Temp.iT).QSS.iStart = it - 1;

    it = 1;
    while Kin.T(Temp.iT).t(it) < Kin.T(Temp.iT).QSS.tEnd
        it = it + 1;
    end       
    Kin.T(Temp.iT).QSS.iEnd   = it;
    
    
    KDissEq   = Rates.T(Temp.iT).DissGlobal(end);
    KDissQSS  = Rates.T(Temp.iT).DissGlobal(iQSS);
    Kin.T(Temp.iT).QSS.Diss      = KDissQSS;
    
    KExch1Eq  = Rates.T(Temp.iT).ExchGlobal(end,1);
    KExch1QSS = Rates.T(Temp.iT).ExchGlobal(iQSS,1);
    Kin.T(Temp.iT).QSS.Exch1     = KExch1QSS;
    
    if Syst.NProc == 4
        KExch2Eq  = Rates.T(Temp.iT).ExchGlobal(end,2);
        KExch2QSS = Rates.T(Temp.iT).ExchGlobal(iQSS,2);
        Kin.T(Temp.iT).QSS.Exch2 = KExch2QSS;
    end
    
    
    [status,msg,msgID] = mkdir(Input.Paths.SaveDataFldr);
    FileName           = strcat(Input.Paths.SaveDataFldr, '/KGlobal_', Input.Kin.Proc.OverallFlg, '.csv');
    if exist(FileName, 'file')
        fileID1  = fopen(FileName,'a');
    else
        fileID1  = fopen(FileName,'w');
        if Syst.NProc == 3
            HeaderStr = strcat('# T [K], K^D Eq, K_{', Syst.Molecule(Syst.ExchToMol(1)).Name, '}^E Eq, K^D QSS, K_{', Syst.Molecule(Syst.ExchToMol(1)).Name,'}^E QSS \n');
        else
            HeaderStr = strcat('# T [K], K^D Eq, K_{', Syst.Molecule(Syst.ExchToMol(1)).Name, '}^E Eq, K_{', Syst.Molecule(Syst.ExchToMol(2)).Name, '}^E Eq, K^D QSS, K_{', Syst.Molecule(Syst.ExchToMol(1)).Name,'}^E QSS, K_{', Syst.Molecule(Syst.ExchToMol(2)).Name, '}^E QSS \n');
        end
        fprintf(fileID1,HeaderStr);
    end
    if Syst.NProc == 3
        fprintf(fileID1,'%e,%e,%e,%e,%e\n',       Temp.TNow, KDissEq, KExch1Eq, KDissQSS, KExch1QSS );
    else
        fprintf(fileID1,'%e,%e,%e,%e,%e,%e,%e\n', Temp.TNow, KDissEq, KExch1Eq, KExch2Eq, KDissQSS, KExch1QSS, KExch2QSS );
    end
    fclose(fileID1);

  
end