module mod_mpi

   implicit none

   integer, parameter :: MPI_COMM_WORLD = 0

! Stub module for MPI
contains

   subroutine MPI_Init(ierr)
      integer, intent(out) :: ierr
      ierr = 0   ! no-op in serial
   end subroutine MPI_Init

   subroutine MPI_Finalize(ierr)
      integer, intent(out) :: ierr
      ierr = 0   ! no-op in serial
   end subroutine MPI_Finalize

end module mod_mpi
