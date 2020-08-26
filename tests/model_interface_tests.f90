module model_interface_tests
  use assimilation_model_interface, ONLY: base_model_interface
  use system_mpi
  use random_integer, ONLY: randint
  use distributed_array, ONLY: darray, darray_segment, new_darray
  implicit none
contains

  subroutine test_darray_coverage(iface)
    class(base_model_interface)::iface
    type(darray),target::state_darray   ! Model state darray from the model interface
    type(darray_segment), pointer::state_segment

    integer,parameter::istep=1

    integer::isegment

    ! Get the model state darray from the model interface
    state_darray = iface%get_state_darray(istep, 1)

    do isegment = 1, size(state_darray%segments)

       state_segment => state_darray%segments(isegment)

       if(isegment>1 .and. &
            state_segment%offset /= &
            state_darray%segments(isegment+1)%offset + &
            state_darray%segments(isegment+1)%length) then

          print *,'Segment offset does not align with preceding segment'
          error stop

       end if

       if(isegment==size(state_darray%segments) .and. &
            state_segment%offset + state_segment%length /= &
            iface%get_state_size(istep)) then
          print *,'State array segments coverage does not correspond to length &
               &returned by iface%get_state_size()'
          error stop
       end if

    end do

  end subroutine test_darray_coverage

  subroutine test_localization(iface)

    class(base_model_interface)::iface
    integer::istep, subset_offset, subset_size, imodel, &
              iobs1, iobs2, state_size, n_obs, i
    real::weight

    istep = 1

    state_size = iface%get_state_size(istep)
    n_obs = iface%get_subset_obs_count(istep, 0, state_size)

    do i = 1, 100
      imodel = randint(state_size)
      iobs1 = randint(n_obs)
      iobs2 = randint(n_obs)

      weight = iface%get_weight_obs_obs(istep, iobs1, iobs2)

      if (weight > 1 .or. weight < 0) then
        print *, 'Weight', weight, 'out of range.'
        error stop
      end if

      weight = iface%get_weight_obs_obs(istep, iobs1, iobs1)

      if (weight /= 1) then
        print *, 'Weight should equal one for identical observations'
        error stop
      end if

      weight = iface%get_weight_model_obs(istep, imodel, iobs1)

      if (weight > 1 .or. weight < 0) then
        print *, 'Weight', weight, 'out of range.'
        error stop
      end if

    end do

  end subroutine test_localization

  subroutine test_buffer_readwrite(iface)
    class(base_model_interface)::iface
    real(kind=8), allocatable::buf(:)
    integer::length, ierr, i, isegment
    integer, parameter::shift = 1
    integer::rank, istep
    type(darray),target::state_darray   ! Model state darray from the model interface
    type(darray_segment), pointer::state_segment

    istep = 1

    call mpi_comm_rank(mpi_comm_world, rank, ierr)

    ! Get the model state darray from the model interface
    state_darray = iface%get_state_darray(istep, 1)

    do isegment = 1, size(state_darray%segments)

      state_segment => state_darray%segments(isegment)

      if ( state_segment%rank /= rank) cycle

      ! Get state values
      buf = state_segment%data

      ! Write to buffer
      do i = 1, size(buf)
         buf(i) = i
      end do

      ! Write model state subset
      call iface%set_state_subset(istep, 1, state_segment%offset, &
           state_segment%length, buf)

     end do

     ! Get the model state darray again
     state_darray = iface%get_state_darray(istep, 1)

     do isegment = 1, size(state_darray%segments)


      state_segment => state_darray%segments(isegment)

      if ( state_segment%rank /= rank) cycle

      ! Get state values
      buf = state_segment%data

      ! Check values in state
      do i = 1, size(buf)
         if (buf(i) /= i) then
            print *, 'Wrote value of', i, &
                 'read back value of', buf(i)
            error stop
         end if
      end do

    end do

  end subroutine test_buffer_readwrite

  subroutine run_all(iface)
    class(base_model_interface)::iface

    call test_darray_coverage(iface)
    call test_buffer_readwrite(iface)
    call test_localization(iface)

  end subroutine run_all

end module model_interface_tests