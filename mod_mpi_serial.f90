module mod_mpi

   implicit none

   integer, parameter :: MPI_COMM_WORLD = 0
   integer, parameter :: MPI_THREAD_MULTIPLE = 1

! Stub module for MPI
contains

   subroutine MPI_Init_thread(req, prov, ierr)
      integer, intent(in) :: req
      integer, intent(out) :: prov
      integer, intent(out) :: ierr

      prov = req
      ierr = 0   ! no-op in serial
   end subroutine MPI_Init_thread

   subroutine MPI_Init(ierr)
      integer, intent(out) :: ierr
      ierr = 0   ! no-op in serial
   end subroutine MPI_Init

   subroutine MPI_Finalize(ierr)
      integer, intent(out) :: ierr
      ierr = 0   ! no-op in serial
   end subroutine MPI_Finalize

end module mod_mpi
