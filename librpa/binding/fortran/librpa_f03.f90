module librpa_f03

   use iso_c_binding, only: c_ptr, c_int, c_double, c_f_pointer
   implicit none

   private
   public :: LibrpaOptions
   public :: librpa_init_options
   public :: LibrpaHandler
   public :: librpa_create_handler
   public :: librpa_destroy_handler

   !===== C-side options type =====
   type, bind(c) :: LibrpaOptions_c
      integer(c_int) :: nfreq
      integer(c_int) :: debug
   end type LibrpaOptions_c

   ! High-level Fortran wrapper
   type :: LibrpaOptions
      type(LibrpaOptions_c), private :: opts_c
      integer :: nfreq
      logical :: debug
   end type LibrpaOptions

   integer, parameter :: SYNC_OPTS_C2F = 1
   integer, parameter :: SYNC_OPTS_F2C = -1

   interface
      subroutine librpa_init_options_c(opts_c) bind(c, name="librpa_init_options")
         import :: LibrpaOptions_c
         type(LibrpaOptions_c) :: opts_c
      end subroutine librpa_init_options_c
   end interface

   !===== C-side handler type =====
   type, bind(c) :: LibrpaHandler_c
      integer(c_int) :: instance_id   ! const int instance_id_;
   end type LibrpaHandler_c

   ! High-level Fortran wrapper
   type :: LibrpaHandler
      type(LibrpaHandler_c), pointer :: ptr_c_handle => null()
   end type LibrpaHandler

   interface
      function librpa_create_handler_c(comm_c) bind(c, name="librpa_create_handler")
         import :: c_ptr, c_int
         integer(c_int) :: comm_c
         type(c_ptr) :: librpa_create_handler_c      ! C: LibrpaHandler*
      end function librpa_create_handler_c
   end interface

   interface
      subroutine librpa_destroy_handler_c(h) bind(c, name="librpa_destroy_handler")
         import :: LibrpaHandler_c
         type(LibrpaHandler_c) :: h   ! C: LibrpaHandler*
      end subroutine librpa_destroy_handler_c
   end interface

contains

   ! Synchronize option values between the Fortran object and the containing C object
   ! Everytime opts_c used through any C interface, its value should be synchronized from opts
   !   call sync_opts(opts, .false.)
   subroutine sync_opts(opts, direction)
      type(LibrpaOptions), intent(inout) :: opts
      integer, intent(in) :: direction

      if (direction .eq. SYNC_OPTS_C2F) then
         ! From C object to Fortran
         opts%nfreq = opts%opts_c%nfreq
         opts%debug = (opts%opts_c%debug .ne. 0)
      else if (direction .eq. SYNC_OPTS_F2C) then
         ! From Fortran object to C
         opts%opts_c%nfreq = opts%nfreq
         opts%opts_c%debug = 0
         if (opts%debug) opts%opts_c%debug = 1
      else
         stop "internal error - illegal direction value"
      end if
   end subroutine

   subroutine librpa_init_options(opts)
      type(LibrpaOptions), intent(inout) :: opts
      call librpa_init_options_c(opts%opts_c)
      call sync_opts(opts, SYNC_OPTS_C2F)
   end subroutine librpa_init_options

   subroutine librpa_create_handler(h, comm)
      type(LibrpaHandler), intent(out) :: h
      integer, intent(in) :: comm

      type(c_ptr) :: ptr
      type(LibrpaHandler_c), pointer :: h_c
      integer(c_int) :: comm_c = 0

      comm_c = int(comm, kind=c_int)

      ptr = librpa_create_handler_c(comm_c)
      call c_f_pointer(ptr, h_c)
      h%ptr_c_handle => h_c
   end subroutine librpa_create_handler

   subroutine librpa_destroy_handler(h)
      type(LibrpaHandler), intent(inout) :: h

      if (associated(h%ptr_c_handle)) then
         call librpa_destroy_handler_c(h%ptr_c_handle)
         nullify(h%ptr_c_handle)
      end if
   end subroutine librpa_destroy_handler

end module librpa_f03
