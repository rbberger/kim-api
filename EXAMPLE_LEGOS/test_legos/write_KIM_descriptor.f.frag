!-------------------------------------------------------------------------------
!
!  Write KIM descriptor file for MiniMol
!  (Also returns the number and identities of the species supported by
!  the Model.)
!
!-------------------------------------------------------------------------------
subroutine Write_KIM_descriptor(modelname, kim_descriptor, &
                                max_specs, model_specs, num_specs, ier)
use KIMservice
implicit none

!-- Transferred variables
character(len=80),    intent(in)   :: modelname
character(len=10000), intent(out)  :: kim_descriptor
integer,              intent(in)   :: max_specs
character(len=3),     intent(out)  :: model_specs(max_specs)
integer,              intent(out)  :: num_specs
integer,              intent(out)  :: ier

!-- Local variables
integer :: i, lastend, firstcap, secondcap
character(len=103) :: divider
character(len=1)   :: cr
character(len=52)  :: type_line
character(len=24)  :: spec24

! Initialize error flag
ier = KIM_STATUS_OK

! Figure out which specs are supported by the model from its name
! (This is not a safe approach since the model name format is not
! enforced. Should be changed to a call to KIM service routines to
! query the model about the species it supports.)
! find first underscore (element string should start right after this)
lastend = scan(modelname,"_")
if (lastend.eq.0) then
   ier = KIM_STATUS_ATOM_INVALID_TYPE
   return
endif
num_specs = 0
do
   ! find first capital or (underscore following element string) since last end
   firstcap = scan(modelname(lastend+1:),"ABCDEFGHIJKLMNOPQRSTUVWXYZ_")
   if (firstcap.ne.1) then
      ier = KIM_STATUS_ATOM_INVALID_TYPE
      return
   endif
   firstcap = lastend + firstcap
   ! find second capital or (underscore following element string) since last end
   secondcap = scan(modelname(firstcap+1:),"ABCDEFGHIJKLMNOPQRSTUVWXYZ_")
   if (secondcap.eq.0) then
      ier = KIM_STATUS_ATOM_INVALID_TYPE
      return
   endif
   secondcap = firstcap + secondcap
   ! pull out element and store in model_specs()
   num_specs = num_specs + 1
   if (num_specs.gt.max_specs) then
      ier = KIM_STATUS_FAIL
      return
   endif
   model_specs(num_specs) = modelname(firstcap:secondcap-1)
   if (modelname(secondcap:secondcap).eq."_") exit
   lastend = secondcap-1
enddo

! Define frequently used variables
!
cr = char(10)
divider = '#######################################################################################################'

! Write Minimol descriptor file into string kim_descriptor
!
kim_descriptor = &
   divider                                                                      // cr // &
   '#'                                                                          // cr // &
   '# Copyright 2011 Ellad B. Tadmor, Ryan S. Elliott, and James P. Sethna'     // cr // &
   '# All rights reserved.'                                                     // cr // &
   '#'                                                                          // cr // &
   '# Author: Automatically generated by calling Test'                          // cr // &
   '#'                                                                          // cr // &
   '#'                                                                          // cr // &
   '# See KIM_API/standard.kim for documentation about this file'               // cr // &
   '#'                                                                          // cr // &
   divider                                                                      // cr // &
                                                                                   cr // &
                                                                                   cr // &
   'TEST_NAME := TEST_NAME_STR'                                                 // cr // &
   'SystemOfUnitsFix := fixed'                                                  // cr // &
                                                                                   cr // &
                                                                                   cr // &
   divider                                                                      // cr // &
   'SUPPORTED_ATOM/PARTICLES_TYPES:'                                            // cr // &
   '# Symbol/name           Type                    code'                       // cr

do i = 1,num_specs
   spec24 = model_specs(i)
   write(type_line,'(a24,''spec'',20x,i4)') spec24,0
   kim_descriptor = trim(kim_descriptor) // type_line // cr
enddo

kim_descriptor = trim(kim_descriptor) // & 
                                                                                   cr // &
                                                                                   cr // &
   divider                                                                      // cr // &
   'CONVENTIONS:'                                                               // cr // &
   '# Name                  Type'                                               // cr // &
                                                                                   cr // &
   'OneBasedLists           dummy'                                              // cr // &
                                                                                   cr // &
   'Neigh_BothAccess        dummy'                                              // cr // &
                                                                                   cr // &
   'NEIGH-RVEC-F            dummy'                                              // cr // &
                                                                                   cr // &
   'NEIGH-PURE-H            dummy'                                              // cr // &
                                                                                   cr // &
   'NEIGH-PURE-F            dummy'                                              // cr // &
                                                                                   cr // &
   'MI-OPBC-H               dummy'                                              // cr // &
                                                                                   cr // &
   'MI-OPBC-F               dummy'                                              // cr // &
                                                                                   cr // &
                                                                                   cr // &
   divider                                                                      // cr // &
   'MODEL_INPUT:'                                                               // cr // &
   '# Name                  Type         Unit       SystemU/Scale           Shape              requirements' // cr // &
   'numberOfAtoms           integer      none       none                    []' // cr // &
                                                                                   cr // &
   'numberAtomTypes         integer      none       none                    []' // cr // &
                                                                                   cr // &
   'atomTypes               integer      none       none                    [numberOfAtoms]' // cr // &
                                                                                   cr // &
   'coordinates             real*8       length     standard                [numberOfAtoms,3]' // cr // &
                                                                                   cr // &
   'get_half_neigh          method       none       none                    []' // cr // &
                                                                                   cr // &
   'get_full_neigh          method       none       none                    []' // cr // &
                                                                                   cr // &
   'neighObject             pointer      none       none                    []' // cr // &
                                                                                   cr // &
   'numberContributingAtoms integer      none       none                    []' // cr // &
                                                                                   cr // &
   'boxlength               real*8       length     standard                [3]'// cr // &
                                                                                   cr // &
                                                                                   cr // &
   divider                                                                      // cr // &
   'MODEL_OUTPUT:'                                                              // cr // &
   '# Name                  Type         Unit       SystemU/Scale           Shape              requirements' // cr // &
                                                                                   cr // &
   'destroy                 method       none       none                    []' // cr // &
                                                                                   cr // &
   'compute                 method       none       none                    []' // cr // &
                                                                                   cr // &
   'reinit                  method       none       none                    []' // cr // &
                                                                                   cr // &
   'cutoff                  real*8       length     standard                []' // cr // &
                                                                                   cr // &
   'energy                  real*8       energy     standard                []' // cr // &
                                                                                   cr // &
   'forces                  real*8       force      standard                [numberOfAtoms,3]' // cr // &
                                                                                   cr // &
   divider                                                                      // cr

return

end subroutine Write_KIM_descriptor
