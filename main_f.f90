program main_librpa_f

   use librpa_f

   implicit none

   type(LibrpaHandler) :: h, h2
   type(LibrpaOptions) :: opts

   call create_librpa_handler(h)
   call create_librpa_handler(h2)

   ! Create twice without destroying first will lead to memory leak
   ! call destroy_handler(h2)
   ! call create_handler(h2)

   write(*,*) h%ptr_c_handle%instance_id
   write(*,*) h2%ptr_c_handle%instance_id

   call destroy_librpa_handler(h2)
   call destroy_librpa_handler(h)

   ! Not initialized, undefined behavior
   write(*,*) opts%nfreq
   write(*,*) opts%debug
   call initialize_librpa_options(opts)
   ! Now the value should be consistent as in the C/C++ case
   write(*,*) opts%nfreq
   write(*,*) opts%debug

end program main_librpa_f

