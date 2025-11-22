module librpa_f

   use iso_c_binding, only: c_ptr, c_int, c_double, c_f_pointer
   implicit none

   private
   public :: LibrpaOptions
   public :: LibrpaHandler
   public :: create_handler
   public :: destroy_handler

   !===== C-side options type =====
   type, bind(c) :: LibrpaOptions_c
      integer(c_int) :: nfreq
      integer(c_int) :: debug
   end type LibrpaOptions_c

   ! High-level Fortran wrapper
   type :: LibrpaOptions
      type(LibrpaOptions_c) :: opts_c
      integer :: nfreq
      logical :: debug
   end type LibrpaOptions

   !===== C-side handler type =====
   type, bind(c) :: LibrpaHandler_c
      integer(c_int) :: instance_id   ! const int __instance_id;
   end type LibrpaHandler_c

   ! High-level Fortran wrapper
   type :: LibrpaHandler
      type(LibrpaHandler_c), pointer :: h_c => null()
   end type LibrpaHandler

   interface
      function create_handler_c() bind(c, name="create_handler")
         import :: c_ptr
         type(c_ptr) :: create_handler_c      ! C: LibrpaHandler*
      end function create_handler_c
   end interface

   interface
      subroutine destroy_handler_c(h) bind(c, name="destroy_handler")
         import :: LibrpaHandler_c
         type(LibrpaHandler_c) :: h   ! C: LibrpaHandler*
      end subroutine destroy_handler_c
   end interface

contains

   subroutine create_handler(h)
      type(LibrpaHandler), intent(out) :: h

      type(c_ptr) :: ptr
      type(LibrpaHandler_c), pointer :: h_c

      ptr = create_handler_c()
      call c_f_pointer(ptr, h_c)
      h%h_c => h_c
   end subroutine create_handler

   subroutine destroy_handler(h)
      type(LibrpaHandler), intent(inout) :: h

      if (associated(h%h_c)) then
         call destroy_handler_c(h%h_c)
         nullify(h%h_c)
      end if
   end subroutine destroy_handler

end module
