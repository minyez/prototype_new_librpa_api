module mod_mpi

   implicit none

! Stub module for MPI
contains

   subroutine MPI_Init(ierr)
      integer, intent(out), optional :: ierr
      if (present(ierr)) ierr = 0   ! no-op in serial
   end subroutine MPI_Init

   subroutine MPI_Finalize(ierr)
      integer, intent(out), optional :: ierr
      if (present(ierr)) ierr = 0   ! no-op in serial
   end subroutine MPI_Finalize

end module mod_mpi
