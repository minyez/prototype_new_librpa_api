module librpa_f

   use iso_c_binding, only: c_ptr, c_char, c_int, c_double, c_f_pointer
   implicit none

   private
   public :: LibrpaOptions
   public :: LibrpaHandler
   public :: create_handler

   type, bind(c) :: LibrpaOptions_c
      integer(c_int) :: nfreq
      integer(c_int) :: debug
   end type LibrpaOptions_c

   type :: LibrpaOptions
      integer :: nfreq
      logical :: debug
   end type LibrpaOptions

   type, bind(c) :: LibrpaHandler_c
      integer(c_int) :: instance_id
   end type LibrpaHandler_c

   type :: LibrpaHandler
      type(LibrpaHandler_c) :: h_c
   end type LibrpaHandler

   interface
      function create_handler_c() bind(c, name="create_handler")
         import :: c_ptr
         type(c_ptr) :: create_handler_c    ! corresponds to LibrpaHandler*
      end function create_handler_c
   end interface

   contains

      subroutine create_handler(h)
         type(LibrpaHandler), intent(out) :: h
         type(LibrpaHandler_c), pointer :: h_c
         type(c_ptr) :: ptr

         ptr = create_handler_c()
         call c_f_pointer(ptr, h_c)
         h%h_c = h_c
      end subroutine create_handler

end module
