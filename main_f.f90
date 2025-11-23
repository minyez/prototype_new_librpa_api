program main

   use mod_mpi
   use librpa_f03

   implicit none

   type(LibrpaHandler) :: h, h2
   type(LibrpaOptions) :: opts
   integer :: comm_test = 0
   integer :: ierr
   integer :: provided

   call MPI_Init_thread(MPI_THREAD_MULTIPLE, provided, ierr);
   if (MPI_THREAD_MULTIPLE .ne. provided) then
      write(*,*) "Warning: MPI_Init_thread provide ", provided, " != required", MPI_THREAD_MULTIPLE
   endif

   call librpa_create_handler(h, MPI_COMM_WORLD)
   call librpa_create_handler(h2, MPI_COMM_WORLD)

   ! Create twice without destroying first will lead to memory leak
   ! call destroy_handler(h2)
   ! call create_handler(h2)

   write(*,*) h%ptr_c_handle%instance_id
   write(*,*) h2%ptr_c_handle%instance_id

   call librpa_destroy_handler(h2)
   call librpa_destroy_handler(h)

   ! Not initialized, undefined behavior
   write(*,*) opts%nfreq
   write(*,*) opts%debug
   call librpa_init_options(opts)
   ! Now the value should be consistent as in the C/C++ case
   write(*,*) opts%nfreq
   write(*,*) opts%debug

   call MPI_Finalize(ierr)

end program main
