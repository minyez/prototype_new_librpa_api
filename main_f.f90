program main_librpa_f

   use librpa_f

   implicit none

   type(LibrpaHandler) :: h, h2

   call create_handler(h)
   call create_handler(h2)

   ! Create twice without destroying first will lead to memory leak
   ! call destroy_handler(h2)
   ! call create_handler(h2)

   write(*,*) h%h_c%instance_id
   write(*,*) h2%h_c%instance_id

   call destroy_handler(h2)
   call destroy_handler(h)

end program main_librpa_f

