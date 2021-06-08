#include "mpi_types.h"

module advect1d_assimilate_interfaces
  use per_member_model_interfaces, ONLY: per_member_model_interface
  use system_mpi
  use iso_c_binding
  use exceptions, ONLY: throw, new_exception, error_container
  use hdf5
  use hdf5_exceptions, ONLY: new_hdf5_exception
  use util, ONLY: str
  use distributed_array, ONLY: darray, darray_segment, new_darray

  implicit none

  type, extends(per_member_model_interface)::advect1d_interface
     !! I/O interface for the advect1d model

    private
    real(kind=8)::cutoff, cutoff_u_a
    logical::observations_read = .false., predictions_computed = .false.
    integer::istep
  contains
    procedure::store_member_state
    procedure::load_member_state
  end type advect1d_interface

contains

  function new_advect1d_interface( &
    istep, n_ensemble, state_size, comm, status) result(this)
    !! Create a new advect1d_interface instance

    integer(c_int), intent(in)::istep, n_ensemble, state_size
    MPI_COMM_TYPE, intent(in)::comm
    type(error_container), intent(out), optional::status
        !! Error status

    type(advect1d_interface)::this
    integer::ierr, rank, comm_size

    call this%initialize_per_member_model_interface( &
      n_ensemble, state_size, comm)

    this%istep = istep

    this%cutoff = 0.1
    this%cutoff_u_a = 0.2

    this%observations_read = .false.
    this%predictions_computed = .false.

    call h5open_f(ierr)

#ifdef OVERRIDABLE_FINALIZERS
    call h5eset_auto_f(0, ierr)
#endif

    if (ierr < 0) then
      call throw(status, new_hdf5_exception(ierr, &
                                            'Error initializing HDF5', &
                                            procedure='new_advect1d_interface'))
      return
    end if

  end function new_advect1d_interface

  subroutine load_member_state( &
    this, imember, member_state, state_size, status)

    !! Read the model state from disk for a given ensemble member

    ! Arguments
    class(advect1d_interface)::this
        !! Model interface
    integer, intent(in)::imember
        !! Ensemble member index
    integer, intent(in)::state_size
        !! Size of the model state
    real(kind=8), intent(inout)::member_state(state_size)
        !! On exit, array holding the model state values
    type(error_container), intent(out), optional::status
        !! Error status

    character(len=50)::preassim_filename
    integer(HID_T)::h5file_h, dset_h, dataspace, memspace
    integer(HSIZE_T)::offset(2), count(2), stride(2), blocksize(2)
    integer::ierr

    character(:), allocatable::errstr_suffix

    errstr_suffix = ' for member '//str(imember)

    stride = (/1, 1/)
    offset = (/imember - 1, 0/)
    count = (/1, 1/)
    blocksize = (/1, state_size/)

    ! Set the HDF5 filename
    write (preassim_filename, "(A,I0,A)") &
      'ensembles/', this%istep, '/preassim.h5'

    ! Open the file
    call h5fopen_f(preassim_filename, h5F_ACC_RDONLY_F, h5file_h, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception( &
                 ierr, &
                 'HDF5 error opening ensemble state file'//errstr_suffix, &
                 filename=preassim_filename, &
                 procedure='load_member_state'))
      return
    end if

    ! Open the dataset
    call h5dopen_f(h5file_h, 'ensemble_state', dset_h, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception( &
                 ierr, &
                 'HDF5 error opening dataset'//errstr_suffix, &
                 filename=preassim_filename, &
                 procedure='load_member_state'))
      return
    end if

    ! Define a dataspace within the dataset so we only read the
    ! specified ensemble member
    call h5dget_space_f(dset_h, dataspace, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception( &
                 ierr, &
                 'HDF5 error configuring dataspace'//errstr_suffix, &
                 filename=preassim_filename, &
                 procedure='load_member_state'))
      return
    end if

    call h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, &
                               offset, count, ierr, stride, blocksize)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception( &
                 ierr, &
                 'HDF5 error configuring hyperslab'//errstr_suffix, &
                 filename=preassim_filename, &
                 procedure='load_member_state'))
      return
    end if

    ! Memory dataspace (needed since the local array shape differs
    ! from the dataspace in the file)
    call h5screate_simple_f(2, blocksize, memspace, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception( &
                 ierr, &
                 'HDF5 error creating memory dataspace'//errstr_suffix, &
                 filename=preassim_filename, &
                 procedure='load_member_state'))
      return
    end if

    ! Read the data
    call h5dread_f(dset_h, H5T_IEEE_F64LE, member_state, blocksize, ierr, &
                   file_space_id=dataspace, mem_space_id=memspace)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception( &
                 ierr, &
                 'HDF5 error reading member state data'//errstr_suffix, &
                 filename=preassim_filename, &
                 procedure='load_member_state'))
      return
    end if

    ! Close the dataspaces
    call h5sclose_f(dataspace, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception( &
                 ierr, &
                 'HDF5 error closing dataspace'//errstr_suffix, &
                 filename=preassim_filename, &
                 procedure='load_member_state'))
      return
    end if

    call h5sclose_f(memspace, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception( &
                 ierr, &
                 'HDF5 error closing memory dataspace'//errstr_suffix, &
                 filename=preassim_filename, &
                 procedure='load_member_state'))
      return
    end if

    ! Close the dataset
    call h5dclose_f(dset_h, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception( &
                 ierr, &
                 'HDF5 error closing dataset'//errstr_suffix, &
                 filename=preassim_filename, &
                 procedure='load_member_state'))
      return
    end if

    ! Close the file
    call h5fclose_f(h5file_h, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception( &
                 ierr, &
                 'HDF5 error closing file'//errstr_suffix, &
                 filename=preassim_filename, &
                 procedure='load_member_state'))
      return
    end if

  end subroutine load_member_state

  subroutine store_member_state( &
    this, imember, n_ensemble, member_state, state_size, status)

    !! Write the new state to disk for one ensemble member

    ! Arguments
    class(advect1d_interface)::this
        !! Model interface
    integer, intent(in)::imember
        !! Ensemble member index
    integer, intent(in)::n_ensemble
        !! Number of ensemble members
    integer, intent(in)::state_size
        !! Size of model state
    real(kind=8), intent(in)::member_state(state_size)
        !! Model state values to write
    type(error_container), intent(out), optional::status
        !! Error status

    character(len=80)::postassim_filename
    integer(HID_T)::h5file_h, dset_h, dataspace, memspace
    integer(HSIZE_T)::offset(2), count(2), stride(2), data_block(2)
    logical::exists
    integer::ierr

    stride = (/2, 1/)
    offset = (/imember - 1, 0/)
    count = (/1, 1/)
    data_block = (/1, state_size/)

    ! Set the HDF5 filename
    write (postassim_filename, "(A,I0,A,I0,A)") &
      'ensembles/', this%istep, '/postassim_', imember - 1, '.h5'

    ! Create the file
    call h5fcreate_f(postassim_filename, H5F_ACC_TRUNC_F, h5file_h, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception(ierr, &
                                            'HDF5 error creating output file', &
                                            filename=postassim_filename, &
                                            procedure='store_member_state'))
      return
    end if

    ! Define a dataspace
    call h5screate_simple_f(1, (/int(state_size, 8)/), dataspace, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception(ierr, &
                                            'HDF5 error creating dataspace', &
                                            filename=postassim_filename, &
                                            procedure='store_member_state'))
      return
    end if

    ! Create the dataset
    call h5dcreate_f(h5file_h, 'ensemble_state', H5T_IEEE_F64LE, &
                     dataspace, dset_h, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception(ierr, &
                                            'HDF5 error creating dataset', &
                                            filename=postassim_filename, &
                                            procedure='store_member_state'))
      return
    end if

    ! Write the data
    call h5dwrite_f( &
      dset_h, H5T_IEEE_F64LE, member_state, data_block, ierr, &
      file_space_id=dataspace)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception(ierr, &
                                            'HDF5 error writing data', &
                                            filename=postassim_filename, &
                                            procedure='store_member_state'))
      return
    end if

    ! Close the dataspace
    call h5sclose_f(dataspace, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception(ierr, &
                                            'HDF5 error closing dataspace', &
                                            filename=postassim_filename, &
                                            procedure='store_member_state'))
      return
    end if

    ! Close the dataset
    call h5dclose_f(dset_h, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception(ierr, &
                                            'HDF5 error closing dataset', &
                                            filename=postassim_filename, &
                                            procedure='store_member_state'))
      return
    end if

    ! Close the file
    call h5fclose_f(h5file_h, ierr)

    if (ierr < 0) then
      call throw(status, new_hdf5_exception(ierr, &
                                            'HDF5 error closing file', &
                                            filename=postassim_filename, &
                                            procedure='store_member_state'))
      return
    end if

  end subroutine store_member_state

end module advect1d_assimilate_interfaces
