!****************************************************************************
!**
!**  MODULE model_EAM_periodic_aluminum_ercolessi_adams
!**
!**  EAM potential for aluminum due to Ercolessi and Adams
!**
!**  Ref: F. Ercolessi and J. B. Adams, Europhys. Lett. 26, 583 (1994).
!**       http://www.sissa.it/furio/potentials/Al/
!**
!**  Author: Ellad B. Tadmor
!**  Date  : 17 Mar 2011
!**
!**  Copyright 2011 Ellad B. Tadmor and Ronald E. Miller
!**  All rights reserved.
!**
!****************************************************************************

module model_EAM_periodic_aluminum_ercolessi_adams

use KIMservice
implicit none

save
private
public Compute_Energy_Forces, &
       model_cutoff

! Model parameters
double precision, parameter :: model_cutoff  = 5.55805441821810d0   ! cutoff distance

integer, parameter :: npt= 17
double precision :: x(npt),yv2(npt),Bv2(npt),Cv2(npt),Dv2(npt)
double precision ::        yrh(npt),Brh(npt),Crh(npt),Drh(npt)
integer, parameter :: nuu= 13
double precision, parameter :: edensmin = .000000000000000D+00
double precision :: xuu(nuu),yuu(nuu),Buu(nuu),Cuu(nuu),Duu(nuu)
integer :: ir = 1
integer :: ie = 1

! pair potential data
!
data x(  1) /   .202111069753385D+01 /
data x(  2) /   .227374953472558D+01 /
data x(  3) /   .252638837191732D+01 /
data x(  4) /   .277902720910905D+01 /
data x(  5) /   .303166604630078D+01 /
data x(  6) /   .328430488349251D+01 /
data x(  7) /   .353694372068424D+01 /
data x(  8) /   .378958255787597D+01 /
data x(  9) /   .404222139506771D+01 /
data x( 10) /   .429486023225944D+01 /
data x( 11) /   .454749906945117D+01 /
data x( 12) /   .480013790664290D+01 /
data x( 13) /   .505277674383463D+01 /
data x( 14) /   .530541558102636D+01 /
data x( 15) /   .555805441821810D+01 /
data x( 16) /   .555807968210182D+01 /
data x( 17) /   .555810494598553D+01 /
data yv2(  1) /   .196016472197158D+01 /
data yv2(  2) /   .682724240745344D+00 /
data yv2(  3) /   .147370824539188D+00 /
data yv2(  4) /  -.188188235860390D-01 /
data yv2(  5) /  -.576011902692490D-01 /
data yv2(  6) /  -.519846499644276D-01 /
data yv2(  7) /  -.376352484845919D-01 /
data yv2(  8) /  -.373737879689433D-01 /
data yv2(  9) /  -.531351030124350D-01 /
data yv2( 10) /  -.632864983555742D-01 /
data yv2( 11) /  -.548103623840369D-01 /
data yv2( 12) /  -.372889232343935D-01 /
data yv2( 13) /  -.188876517630154D-01 /
data yv2( 14) /  -.585239362533525D-02 /
data yv2( 15) /   .000000000000000D+00 /
data yv2( 16) /   .000000000000000D+00 /
data yv2( 17) /   .000000000000000D+00 /
data Bv2(  1) /  -.702739315585347D+01 /
data Bv2(  2) /  -.333140549270729D+01 /
data Bv2(  3) /  -.117329394261502D+01 /
data Bv2(  4) /  -.306003283486901D+00 /
data Bv2(  5) /  -.366656699104026D-01 /
data Bv2(  6) /   .588330899204400D-01 /
data Bv2(  7) /   .384220572312032D-01 /
data Bv2(  8) /  -.390223173707191D-01 /
data Bv2(  9) /  -.663882722510521D-01 /
data Bv2( 10) /  -.312918894386669D-02 /
data Bv2( 11) /   .590118945294245D-01 /
data Bv2( 12) /   .757939459148246D-01 /
data Bv2( 13) /   .643822548468606D-01 /
data Bv2( 14) /   .399750987463792D-01 /
data Bv2( 15) /   .177103852679117D-05 /
data Bv2( 16) /  -.590423369301474D-06 /
data Bv2( 17) /   .590654950414731D-06 /
data Cv2(  1) /   .877545959718548D+01 /
data Cv2(  2) /   .585407125495837D+01 /
data Cv2(  3) /   .268820820643116D+01 /
data Cv2(  4) /   .744718689404422D+00 /
data Cv2(  5) /   .321378734769888D+00 /
data Cv2(  6) /   .566263292669091D-01 /
data Cv2(  7) /  -.137417679148505D+00 /
data Cv2(  8) /  -.169124163201523D+00 /
data Cv2(  9) /   .608037039066423D-01 /
data Cv2( 10) /   .189589640245655D+00 /
data Cv2( 11) /   .563784150384640D-01 /
data Cv2( 12) /   .100486298765028D-01 /
data Cv2( 13) /  -.552186092621482D-01 /
data Cv2( 14) /  -.413902746758285D-01 /
data Cv2( 15) /  -.116832934994489D+00 /
data Cv2( 16) /   .233610871054729D-01 /
data Cv2( 17) /   .233885865725971D-01 /
data Dv2(  1) /  -.385449887634130D+01 /
data Dv2(  2) /  -.417706040200591D+01 /
data Dv2(  3) /  -.256425277368288D+01 /
data Dv2(  4) /  -.558557503589276D+00 /
data Dv2(  5) /  -.349316054551627D+00 /
data Dv2(  6) /  -.256022933201611D+00 /
data Dv2(  7) /  -.418337423301704D-01 /
data Dv2(  8) /   .303368330939646D+00 /
data Dv2(  9) /   .169921006301015D+00 /
data Dv2( 10) /  -.175759761362548D+00 /
data Dv2( 11) /  -.611278214082881D-01 /
data Dv2( 12) /  -.861140219824535D-01 /
data Dv2( 13) /   .182451950513387D-01 /
data Dv2( 14) /  -.995395392057973D-01 /
data Dv2( 15) /   .184972909229936D+04 /
data Dv2( 16) /   .362829766922787D+00 /
data Dv2( 17) /   .362829766922787D+00 /

! electron density  data
!
data yrh(  1) /   .865674623712589D-01 /
data yrh(  2) /   .925214702944478D-01 /
data yrh(  3) /   .862003123832002D-01 /
data yrh(  4) /   .762736292751052D-01 /
data yrh(  5) /   .606481841271735D-01 /
data yrh(  6) /   .466030959588197D-01 /
data yrh(  7) /   .338740138848363D-01 /
data yrh(  8) /   .232572661705343D-01 /
data yrh(  9) /   .109046405489829D-01 /
data yrh( 10) /   .524910605677597D-02 /
data yrh( 11) /   .391702419142291D-02 /
data yrh( 12) /   .308277776293383D-02 /
data yrh( 13) /   .250214745349505D-02 /
data yrh( 14) /   .147220513798186D-02 /
data yrh( 15) /   .000000000000000D+00 /
data yrh( 16) /   .000000000000000D+00 /
data yrh( 17) /   .000000000000000D+00 /
data Brh(  1) /   .608555214104682D-01 /
data Brh(  2) /  -.800158928716306D-02 /
data Brh(  3) /  -.332089451111092D-01 /
data Brh(  4) /  -.521001991705069D-01 /
data Brh(  5) /  -.618130637429111D-01 /
data Brh(  6) /  -.529750064268036D-01 /
data Brh(  7) /  -.442210477548108D-01 /
data Brh(  8) /  -.473645664984640D-01 /
data Brh(  9) /  -.390741582571631D-01 /
data Brh( 10) /  -.101795580610560D-01 /
data Brh( 11) /  -.318316981110289D-02 /
data Brh( 12) /  -.281217210746153D-02 /
data Brh( 13) /  -.236932031483360D-02 /
data Brh( 14) /  -.683554708271547D-02 /
data Brh( 15) /  -.638718204858808D-06 /
data Brh( 16) /   .212925486831149D-06 /
data Brh( 17) /  -.212983742465787D-06 /
data Crh(  1) /  -.170233687052940D+00 /
data Crh(  2) /  -.102317878901959D+00 /
data Crh(  3) /   .254162872544396D-02 /
data Crh(  4) /  -.773173610292656D-01 /
data Crh(  5) /   .388717099948882D-01 /
data Crh(  6) /  -.388873819867093D-02 /
data Crh(  7) /   .385388290924526D-01 /
data Crh(  8) /  -.509815666327127D-01 /
data Crh(  9) /   .837968231208082D-01 /
data Crh( 10) /   .305743500420042D-01 /
data Crh( 11) /  -.288110886134041D-02 /
data Crh( 12) /   .434959924771674D-02 /
data Crh( 13) /  -.259669459714693D-02 /
data Crh( 14) /  -.150816117849093D-01 /
data Crh( 15) /   .421356801161513D-01 /
data Crh( 16) /  -.842575249165724D-02 /
data Crh( 17) /  -.843267014952237D-02 /
data Drh(  1) /   .896085612514625D-01 /
data Drh(  2) /   .138352319847830D+00 /
data Drh(  3) /  -.105366473134009D+00 /
data Drh(  4) /   .153300619856764D+00 /
data Drh(  5) /  -.564184148788224D-01 /
data Drh(  6) /   .559792096400504D-01 /
data Drh(  7) /  -.118113795329664D+00 /
data Drh(  8) /   .177827488509794D+00 /
data Drh(  9) /  -.702220789044304D-01 /
data Drh( 10) /  -.441413511810337D-01 /
data Drh( 11) /   .954024354744484D-02 /
data Drh( 12) /  -.916498550800407D-02 /
data Drh( 13) /  -.164726813535368D-01 /
data Drh( 14) /   .754928689733184D-01 /
data Drh( 15) /  -.667110847110954D+03 /
data Drh( 16) /  -.912720300911022D-01 /
data Drh( 17) /  -.912720300911022D-01 /

! Embedding function data
!
data xuu(  1) /   .000000000000000D+00 /
data xuu(  2) /   .100000000000000D+00 /
data xuu(  3) /   .200000000000000D+00 /
data xuu(  4) /   .300000000000000D+00 /
data xuu(  5) /   .400000000000000D+00 /
data xuu(  6) /   .500000000000000D+00 /
data xuu(  7) /   .600000000000000D+00 /
data xuu(  8) /   .700000000000000D+00 /
data xuu(  9) /   .800000000000000D+00 /
data xuu( 10) /   .900000000000000D+00 /
data xuu( 11) /   .100000000000000D+01 /
data xuu( 12) /   .110000000000000D+01 /
data xuu( 13) /   .120000000000000D+01 /
data yuu(  1) /   .000000000000000D+00 /
data yuu(  2) /  -.113953324143752D+01 /
data yuu(  3) /  -.145709859805864D+01 /
data yuu(  4) /  -.174913308002738D+01 /
data yuu(  5) /  -.202960322136630D+01 /
data yuu(  6) /  -.225202324967546D+01 /
data yuu(  7) /  -.242723053979436D+01 /
data yuu(  8) /  -.255171976467357D+01 /
data yuu(  9) /  -.260521638832322D+01 /
data yuu( 10) /  -.264397894381693D+01 /
data yuu( 11) /  -.265707884842034D+01 /
data yuu( 12) /  -.264564149400021D+01 /
data yuu( 13) /  -.260870604452106D+01 /
data Buu(  1) /  -.183757286015853D+02 /
data Buu(  2) /  -.574233124410516D+01 /
data Buu(  3) /  -.236790436375322D+01 /
data Buu(  4) /  -.307404645857774D+01 /
data Buu(  5) /  -.251104850116555D+01 /
data Buu(  6) /  -.196846462620234D+01 /
data Buu(  7) /  -.154391254686695D+01 /
data Buu(  8) /  -.846780636273251D+00 /
data Buu(  9) /  -.408540363905760D+00 /
data Buu( 10) /  -.286833282404628D+00 /
data Buu( 11) /  -.309389414590161D-06 /
data Buu( 12) /   .236958014464143D+00 /
data Buu( 13) /   .503352368511243D+00 /
data Cuu(  1) /   .830779120415016D+02 /
data Cuu(  2) /   .432560615333001D+02 /
data Cuu(  3) /  -.951179272978074D+01 /
data Cuu(  4) /   .245037178153561D+01 /
data Cuu(  5) /   .317960779258630D+01 /
data Cuu(  6) /   .224623095704576D+01 /
data Cuu(  7) /   .199928983630817D+01 /
data Cuu(  8) /   .497202926962879D+01 /
data Cuu(  9) /  -.589626545953876D+00 /
data Cuu( 10) /   .180669736096520D+01 /
data Cuu( 11) /   .106163236918694D+01 /
data Cuu( 12) /   .130795086934864D+01 /
data Cuu( 13) /   .135599267112235D+01 /
data Duu(  1) /  -.132739501694005D+03 /
data Duu(  2) /  -.175892847543603D+03 /
data Duu(  3) /   .398738817043878D+02 /
data Duu(  4) /   .243078670350231D+01 /
data Duu(  5) /  -.311125611846847D+01 /
data Duu(  6) /  -.823137069125319D+00 /
data Duu(  7) /   .990913144440207D+01 /
data Duu(  8) /  -.185388527186089D+02 /
data Duu(  9) /   .798774635639692D+01 /
data Duu( 10) /  -.248354997259420D+01 /
data Duu( 11) /   .821061667205675D+00 /
data Duu( 12) /   .160139339245701D+00 /
data Duu( 13) /   .160139339245701D+00 /

! Optimization paramaters
double precision, parameter :: model_cutsq   = model_cutoff**2

contains

!-------------------------------------------------------------------------------
!
! Compute energy and forces on atoms from the positions.
!
!-------------------------------------------------------------------------------
subroutine Compute_Energy_Forces(pkim,ier)
implicit none

!-- Transferred variables
integer(kind=kim_intptr), intent(in)  :: pkim
integer,                  intent(out) :: ier

!-- Local variables
integer, parameter :: DIM=3
double precision, dimension(DIM) :: Sij,Rij
double precision :: r,Rsqij,v,dv,d2v,rho,drho,d2rho,u,du,d2u,dveff
integer :: i,j,jj,numnei,atom,atom_ret
double precision, allocatable :: edens(:),deru(:)

!-- KIM variables
integer(kind=8) N; pointer(pN,N)
real*8 energy; pointer(penergy,energy)
real*8 coordum(DIM,1); pointer(pcoor,coordum)
real*8 forcedum(DIM,1); pointer(pforce,forcedum)
real*8 enepotdum(1); pointer(penepot,enepotdum)
real*8 boxlength(3); pointer(pboxlength,boxlength)
real*8, pointer :: coor(:,:),force(:,:),ene_pot(:)
real*8 virial; pointer(pvirial,virial)
real*8 Rij_dummy(3,1); pointer(pRij_dummy,Rij_dummy)
integer:: nei1atom(1); pointer (pnei1atom,nei1atom)
integer N4     !@@@@@@@@@ NEEDS TO BE FIXED

! Unpack data from KIM object
!
pN         = kim_api_get_data_f(pkim,"numberOfAtoms",ier); if (ier.le.0) return
penergy    = kim_api_get_data_f(pkim,"energy",ier);        if (ier.le.0) return
pcoor      = kim_api_get_data_f(pkim,"coordinates",ier);   if (ier.le.0) return
pforce     = kim_api_get_data_f(pkim,"forces",ier);        if (ier.le.0) return
penepot    = kim_api_get_data_f(pkim,"energyPerAtom",ier); if (ier.le.0) return
pvirial    = kim_api_get_data_f(pkim,"virial",ier);        if (ier.le.0) return
pboxlength = kim_api_get_data_f(pkim,"boxlength",ier);     if (ier.le.0) return
N4=N
call toRealArrayWithDescriptor2d(coordum,coor,DIM,N4)
call toRealArrayWithDescriptor2d(forcedum,force,DIM,N4)
call toRealArrayWithDescriptor1d(enepotdum,ene_pot,N4)

! Initialize potential energies, forces, virial term, electron density
!
ene_pot(1:N) = 0.d0
force(1:3,1:N) = 0.d0
virial = 0.d0
allocate( edens(N), deru(N) )  ! EAM electron density and embedded energy deriv
edens(1:N) = 0.d0

!  Compute energy and forces
!

!  Loop over particles in the neighbor list a first time,
!  to compute electron density (=coordination)
!
do i = 1,N-1

   ! Get neighbors for atom i
   !
   atom = i ! request neighbors for atom i
   ier = kim_api_get_half_neigh(pkim,1,atom,atom_ret,numnei,pnei1atom,pRij_dummy)
   if (ier.le.0) return

   ! Loop over the neighbors of atom i
   !
   do jj = 1, numnei
      j = nei1atom(jj)
      Rij = coor(:,i) - coor(:,j)                 ! distance vector between i j
      where ( abs(Rij) > 0.5d0*boxlength )        ! periodic boundary conditions
         Rij = Rij - sign(boxlength,Rij)          ! applied where needed.
      end where                                   ! 
      Rsqij = dot_product(Rij,Rij)                ! compute square distance
      if ( Rsqij < model_cutsq ) then             ! particles are interacting?
         r = sqrt(Rsqij)                          ! compute distance
         call calc_rho(r,rho)                     ! compute electron density
         edens(i) = edens(i) + rho                ! accumulate electron density
         edens(j) = edens(j) + rho                ! (i and j share it)
      endif
   enddo

enddo

!  Now that we know the electron densities, calculate embedding part of energy
!  U and its derivative U' (deru)
!
do i = 1,N
   call calc_u_du(edens(i),u,du)                  ! compute embedding energy
                                                  !   and its derivative
   ene_pot(i) = u                                 ! initialize pot energy
   deru(i) = du                                   ! store du for later use
enddo

!  Loop over particles in the neighbor list a second time, to compute
!  the forces and complete energy calculation
!
do i = 1,N-1

   ! Get neighbors for atom i
   !
   atom = i ! request neighbors for atom i
   ier = kim_api_get_half_neigh(pkim,1,atom,atom_ret,numnei,pnei1atom,pRij_dummy)
   if (ier.le.0) return

   ! Loop over the neighbors of atom i
   !
   do jj = 1, numnei
      j = nei1atom(jj)
      Rij = coor(:,i) - coor(:,j)                 ! distance vector between i j
      where ( abs(Rij) > 0.5d0*boxlength )        ! periodic boundary conditions
         Rij = Rij - sign(boxlength,Rij)          ! applied where needed.
      end where                                   ! 
      Rsqij = dot_product(Rij,Rij)                ! compute square distance
      if ( Rsqij < model_cutsq ) then             ! particles are interacting?
         r = sqrt(Rsqij)                          ! compute distance
         call calc_v_dv(r,v,dv)                   ! compute pair potential
                                                  !   and it derivative
         call calc_drho(r,drho)                   ! compute elect dens first deriv
         ene_pot(i) = ene_pot(i) + 0.5d0*v        ! accumulate energy
         ene_pot(j) = ene_pot(j) + 0.5d0*v        ! (i and j share it)
         dveff = dv + (deru(i)+deru(j))*drho      !
         virial = virial + r*dveff                ! accumul. virial=sum r(dV/dr)
         force(:,i) = force(:,i) - dv*Rij/r       ! accumulate forces
         force(:,j) = force(:,j) + dv*Rij/r       !    (Fji = -Fij)
      endif
   enddo

enddo
virial = - virial/DIM                             ! definition of virial term
energy = sum(ene_pot(1:N))                        ! compute total energy

! Free storage
!
deallocate( edens )

end subroutine Compute_Energy_Forces

!-------------------------------------------------------------------------------
!
!  Calculate electron density rho
!
!-------------------------------------------------------------------------------
subroutine calc_rho(r,rho)
implicit none
   
!-- Transferred variables
double precision, intent(in)  :: r
double precision, intent(out) :: rho

!-- Local variables
integer i
double precision dx 

if (r.ge.model_cutoff) then
   ! Argument exceeds cutoff radius
   rho = 0.d0
else 
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(npt,r,x,ir)
   dx = r - x(i)  
   rho = yrh(i) + dx*(Brh(i) + dx*(Crh(i) + dx*Drh(i)))
endif

end subroutine calc_rho

!-------------------------------------------------------------------------------
!
!  Calculate electron density derivative drho
!
!-------------------------------------------------------------------------------
subroutine calc_drho(r,drho)
implicit none
   
!-- Transferred variables
double precision, intent(in)  :: r
double precision, intent(out) :: drho

!-- Local variables
integer i
double precision dx 

if (r.ge.model_cutoff) then
   ! Argument exceeds cutoff radius
   drho = 0.d0
else 
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(npt,r,x,ir)
   dx = r - x(i)  
   drho = Brh(i) + dx*(2.d0*Crh(i) + 3.d0*dx*Drh(i))
endif

end subroutine calc_drho

!-------------------------------------------------------------------------------
!
!  Calculate electron density second derivative d2rho
!
!-------------------------------------------------------------------------------
subroutine calc_d2rho(r,d2rho)
implicit none
   
!-- Transferred variables
double precision, intent(in)  :: r
double precision, intent(out) :: d2rho

!-- Local variables
integer i
double precision dx 

if (r.ge.model_cutoff) then
   ! Argument exceeds cutoff radius
   d2rho = 0.d0
else 
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(npt,r,x,ir)
   dx = r - x(i)  
   d2rho = 2.d0*Crh(i) + 6.d0*dx*Drh(i)
endif

end subroutine calc_d2rho

!-------------------------------------------------------------------------------
!
!  Calculate pair potential v
!
!-------------------------------------------------------------------------------
subroutine calc_v(r,v)
implicit none
   
!-- Transferred variables
double precision, intent(in)  :: r
double precision, intent(out) :: v

!-- Local variables
integer i
double precision dx 

if (r.ge.model_cutoff) then
   ! Argument exceeds cutoff radius
   v = 0.d0
else 
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(npt,r,x,ir)
   dx = r - x(i)  
   v = yv2(i) + dx*(Bv2(i) + dx*(Cv2(i) + dx*Dv2(i)))
endif

end subroutine calc_v

!-------------------------------------------------------------------------------
!
!  Calculate pair potential derivative dv
!
!-------------------------------------------------------------------------------
subroutine calc_dv(r,dv)
implicit none
   
!-- Transferred variables
double precision, intent(in)  :: r
double precision, intent(out) :: dv

!-- Local variables
integer i
double precision dx 

if (r.ge.model_cutoff) then
   ! Argument exceeds cutoff radius
   dv = 0.d0
else 
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(npt,r,x,ir)
   dx = r - x(i)  
   dv = Bv2(i) + dx*(2.d0*Cv2(i) + 3.d0*dx*Dv2(i))
endif

end subroutine calc_dv

!-------------------------------------------------------------------------------
!
!  Calculate pair potential second derivative d2v
!
!-------------------------------------------------------------------------------
subroutine calc_d2v(r,d2v)
implicit none
   
!-- Transferred variables
double precision, intent(in)  :: r
double precision, intent(out) :: d2v

!-- Local variables
integer i
double precision dx 

if (r.ge.model_cutoff) then
   ! Argument exceeds cutoff radius
   d2v = 0.d0
else 
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(npt,r,x,ir)
   dx = r - x(i)  
   d2v = 2.d0*Cv2(i) + 6.d0*dx*Dv2(i)
endif

end subroutine calc_d2v

!-------------------------------------------------------------------------------
!
!  Calculate pair potential v and its derivative dv
!
!-------------------------------------------------------------------------------
subroutine calc_v_dv(r,v,dv)
implicit none
   
!-- Transferred variables
double precision, intent(in)  :: r
double precision, intent(out) :: v,dv

!-- Local variables
integer i
double precision dx 

if (r.ge.model_cutoff) then
   ! Argument exceeds cutoff radius
   v    = 0.d0
   dv   = 0.d0
else 
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(npt,r,x,ir)
   dx = r - x(i)  
   v    = yv2(i) + dx*(Bv2(i) + dx*(Cv2(i) + dx*Dv2(i)))
   dv   = Bv2(i) + dx*(2.d0*Cv2(i) + 3.d0*dx*Dv2(i))
endif

end subroutine calc_v_dv

!-------------------------------------------------------------------------------
!
!  Calculate embedding function u
!
!-------------------------------------------------------------------------------
subroutine calc_u(edens,u)
implicit none

!-- Transferred variables
double precision, intent(in)  :: edens
double precision, intent(out) :: u

!-- Local variables
integer i
double precision dx

if (edens.le.edensmin) then
   ! Argument less than the minimum stored value
   !
   u = 0.d0
else
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(nuu,edens,xuu,ie)
   dx = edens - xuu(i)
   u = yuu(i) + dx*(Buu(i) + dx*(Cuu(i) + dx*Duu(i)))
endif

end subroutine calc_u

!-------------------------------------------------------------------------------
!
!  Calculate embedding function derivative du
!
!-------------------------------------------------------------------------------
subroutine calc_du(edens,du)
implicit none

!-- Transferred variables
double precision, intent(in)  :: edens
double precision, intent(out) :: du

!-- Local variables
integer i
double precision dx

if (edens.le.edensmin) then
   ! Argument less than the minimum stored value
   !
   du = 0.d0
else
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(nuu,edens,xuu,ie)
   dx = edens - xuu(i)
   du = Buu(i) + dx*(2.d0*Cuu(i) + 3.d0*dx*Duu(i))
endif

end subroutine calc_du

!-------------------------------------------------------------------------------
!
!  Calculate embedding function second derivative d2u
!
!-------------------------------------------------------------------------------
subroutine calc_d2u(edens,d2u)
implicit none

!-- Transferred variables
double precision, intent(in)  :: edens
double precision, intent(out) :: d2u

!-- Local variables
integer i
double precision dx

if (edens.le.edensmin) then
   ! Argument less than the minimum stored value
   !
   d2u = 0.d0
else
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(nuu,edens,xuu,ie)
   dx = edens - xuu(i)
   d2u = 2.d0*Cuu(i) + 6.d0*dx*Duu(i)
endif

end subroutine calc_d2u

!-------------------------------------------------------------------------------
!
!  Calculate embedding function u and first derivative du
!
!-------------------------------------------------------------------------------
subroutine calc_u_du(edens,u,du)
implicit none

!-- Transferred variables
double precision, intent(in)  :: edens
double precision, intent(out) :: u,du

!-- Local variables
integer i
double precision dx

if (edens.le.edensmin) then
   ! Argument less than the minimum stored value
   !
   u  = 0.d0
   du = 0.d0
else
   ! Evaluate spline (see header of function seval_i)
   ! 
   i = seval_i(nuu,edens,xuu,ie)
   dx = edens - xuu(i)
   u  = yuu(i) + dx*(Buu(i) + dx*(Cuu(i) + dx*Duu(i)))
   du = Buu(i) + dx*(2.d0*Cuu(i) + 3.d0*dx*Duu(i))
endif

end subroutine calc_u_du


!-------------------------------------------------------------------------------
!
!  This function performs a binary search to find the index i
!  for evaluating the cubic spline function
!
!    seval = y(i) + B(i)*(u-x(i)) + C(i)*(u-x(i))**2 + D(i)*(u-x(i))**3
!
!    where  x(i) .lt. u .lt. x(i+1), using horner's rule
!
!  if  u .lt. x(1) then  i = 1  is used.
!  if  u .ge. x(n) then  i = n  is used.
!
!  input..
!
!    n = the number of data points
!    u = the abscissa at which the spline is to be evaluated
!    x = the array of data abscissas
!    i = current value of i
!
!  if  u  is not in the same interval as the previous call, then a
!  binary search is performed to determine the proper interval.
!
!-------------------------------------------------------------------------------
integer function seval_i(n, u, x, i)
implicit none

!--Transferred variables
integer, intent(in)           ::  n
double precision, intent(in)  ::  u, x(n)
integer, intent(inout)        ::  i

!--Local variables
integer j, k

if ( i .ge. n ) i = 1
if ( u .lt. x(i) ) go to 10
if ( u .le. x(i+1) ) go to 30
 
!  binary search
!
10 i = 1
   j = n+1
20 k = (i+j)/2
   if ( u .lt. x(k) ) j = k
   if ( u .ge. x(k) ) i = k
   if ( j .gt. i+1 ) go to 20
 
!  got i, return
!
30 seval_i = i
   return

end function seval_i

end module model_EAM_periodic_aluminum_ercolessi_adams

!-------------------------------------------------------------------------------
!
! Model initialization routine (REQUIRED)
!
!-------------------------------------------------------------------------------
subroutine model_EAM_periodic_aluminum_ercolessi_adams_f90_init(pkim)
use model_EAM_periodic_aluminum_ercolessi_adams
use KIMservice
implicit none

!-- Transferred variables
integer(kind=kim_intptr), intent(in) :: pkim

!-- Local variables
integer(kind=kim_intptr), parameter :: sz=1
real*8 cutoff; pointer(pcutoff,cutoff)
integer ier

! store pointer to compute function in KIM object
if (kim_api_set_data_f(pkim,"compute",sz,loc(Compute_Energy_Forces)).ne.1) &
   stop '* ERROR: compute keyword not found in KIM object.'

! store model cutoff in KIM object
pcutoff =  kim_api_get_data_f(pkim,"cutoff",ier)
if (ier.le.0) stop '* ERROR: cutoff not found in KIM object.'
cutoff = model_cutoff

end subroutine model_EAM_periodic_aluminum_ercolessi_adams_f90_init
