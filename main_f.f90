program main_librpa_f

   use librpa_f

   implicit none

   type(LibrpaHandler) :: h, h2

   call create_handler(h)
   call create_handler(h2)

   write(*,*) h%h_c%instance_id
   write(*,*) h2%h_c%instance_id

end program main_librpa_f

