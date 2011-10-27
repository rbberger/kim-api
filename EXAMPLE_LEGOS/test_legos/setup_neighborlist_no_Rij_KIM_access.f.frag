!-------------------------------------------------------------------------------
!
! setup_neighborlist_no_Rij_KIM_access :
!
!    Store necessary pointers in KIM API object to access the neighbor list
!    data and methods.
!
!-------------------------------------------------------------------------------
subroutine setup_neighborlist_no_Rij_KIM_access(pkim, N, neighborList)
  use KIMservice
  implicit none

  !-- Transferred variables
  integer(kind=kim_intptr), intent(in) :: pkim
  integer,                  intent(in) :: N
  integer,                  intent(in) :: neighborList(N+1,N)

  !-- Local variables
  integer(kind=kim_intptr), parameter :: SizeOne = 1
  integer,                  external  :: get_neigh_no_Rij
  integer ier

  ! store pointers to neighbor list object and access function
  !
  ier = kim_api_set_data_f(pkim, "neighObject", SizeOne, loc(neighborList))
  if (ier.lt.KIM_STATUS_OK) then
     call kim_api_report_error_f(__LINE__, __FILE__, "kim_api_set_data_f", ier)
     stop
  endif

  ier = kim_api_set_data_f(pkim, "get_half_neigh", SizeOne, loc(get_neigh_no_Rij))
  if (ier.lt.KIM_STATUS_OK) then
     call kim_api_report_error_f(__LINE__, __FILE__, "kim_api_set_data_f", ier)
     stop
  endif

  ier = kim_api_set_data_f(pkim, "get_full_neigh", SizeOne, loc(get_neigh_no_Rij))
  if (ier.lt.KIM_STATUS_OK) then
     call kim_api_report_error_f(__LINE__, __FILE__, "kim_api_set_data_f", ier)
     stop
  endif

  ! Call reinit to ensure that the model fully registers the new pointer values
  !
  ier = kim_api_model_reinit_f(pkim);

  return

end subroutine setup_neighborlist_no_Rij_KIM_access
