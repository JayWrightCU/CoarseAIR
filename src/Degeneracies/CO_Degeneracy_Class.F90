! -*-F90-*-
!===============================================================================================================
! 
! Coarse-Grained QCT for Atmospheric Mixtures (CoarseAIR) 
! 
! Copyright (C) 2018 Simone Venturi and Bruno Lopez (University of Illinois at Urbana-Champaign). 
!
! Based on "VVTC" (Vectorized Variable stepsize Trajectory Code) by David Schwenke (NASA Ames Research Center). 
! 
! This program is free software; you can redistribute it and/or modify it under the terms of the 
! Version 2.1 GNU Lesser General Public License as published by the Free Software Foundation. 
! 
! This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
! without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
! See the GNU Lesser General Public License for more details. 
! 
! You should have received a copy of the GNU Lesser General Public License along with this library; 
! if not, write to the Free Software Foundation, Inc. 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA 
! 
!---------------------------------------------------------------------------------------------------------------
!===============================================================================================================

Module CO_Degeneracy_Class

#include "../qct.inc"

  use Parameters_Module     ,only:  rkp
  use Degeneracy_Class      ,only:  Degeneracy_Type
  use Logger_Class          ,only:  Logger
  use Error_Class           ,only:  Error

  implicit none

  private
  public    ::    CO_Degeneracy_Type


  Type    ,extends(Degeneracy_Type)          ::    CO_Degeneracy_Type
  contains
    procedure           ::  Initialize                  =>    Initialize_CO_Degeneracy
    procedure           ::  Output                      =>    Output_CO_Degeneracy
    procedure   ,nopass ::  Compute_Degeneracy_State    =>    Compute_CO_Degeneracy_State
  End Type

  logical                         ,parameter    ::    i_Debug_Global = .False.
  
  contains
  


! **************************************************************************************************************
! **************************************************************************************************************
!                                      DEFERRED PROCEDURES for CO Degeneracy
! **************************************************************************************************************
! **************************************************************************************************************

Subroutine Initialize_CO_Degeneracy( This, Input, i_Debug )

  use Input_Class                  ,only:  Input_Type
  
  class(CO_Degeneracy_Type)                 ,intent(out)    ::    This
  type(Input_Type)                          ,intent(in)     ::    Input
  logical                         ,optional ,intent(in)     ::    i_Debug
  
  logical                                                   ::    i_Debug_Loc
  integer                                                   ::    iP
  character(*)                    ,parameter                ::    Name_Degeneracy = 'CO'
    
  This%Name         =   Name_Degeneracy
  This%Initialized  =   .True.
  
End Subroutine


Subroutine Output_CO_Degeneracy( This, Unit )

  class(CO_Degeneracy_Type)               ,intent(in)     ::    This
  integer                                 ,intent(in)     ::    Unit
  
  write(Unit,"('Degeneracy Name: ',g0)") This%Name
  
End Subroutine


Pure Elemental Function Compute_CO_Degeneracy_State( jqn ) result(g)

  use Parameters_Module       ,only:  rkp, Zero, One, Two, Three, Six

  integer                                 ,intent(in)     ::    jqn
  
  real(rkp)                                               ::    g
 
  g = (Two * jqn + One)
  
End Function


End Module
