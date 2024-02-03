use dirs;
use std::{ffi::*, path::PathBuf};

/// Result type for all dir calls
///
/// - When bytes_total != bytes_written, this means the output string was not
/// sufficiently large enough to hold all the data.
/// - When both variables are 0, this means the path could not be retrieved
#[repr(C)]
pub struct DirResut {
    /// The amount of bytes that have been written to the output variable. This
    /// includes the null-terminator
    bytes_written: libc::size_t,
    /// The amount of bytes the path required to be written to the output variable.
    /// This incudes the null-terminator
    bytes_total: libc::size_t,
}

macro_rules! dir_fn {
    ($name:ident) => {
        ::paste::paste! {
            #[no_mangle]
            pub unsafe extern "C" fn [<$name _dir>](output: *mut c_char, output_len: libc::size_t) -> DirResut {
                let mut result = DirResut{bytes_written: 0, bytes_total: 0};
                pathbuf_to_c_string(dirs::[<$name _dir>](), output, output_len, &mut result.bytes_written, &mut result.bytes_total);
                return result;
            }

        }
    }
}

dir_fn!(audio);
dir_fn!(cache);
dir_fn!(config);
dir_fn!(config_local);
dir_fn!(data);
dir_fn!(data_local);
dir_fn!(desktop);
dir_fn!(document);
dir_fn!(download);
dir_fn!(executable);
dir_fn!(font);
dir_fn!(home);
dir_fn!(picture);
dir_fn!(preference);
dir_fn!(public);
dir_fn!(runtime);
dir_fn!(state);
dir_fn!(template);
dir_fn!(video);

unsafe fn pathbuf_to_c_string(
    path: Option<PathBuf>,
    output: *mut c_char,
    output_len: libc::size_t,
    bytes_written: &mut libc::size_t,
    total_bytes: &mut libc::size_t,
) {
    match path {
        Some(path) => {
            let str_bytes: &[u8] = {
                #[cfg(unix)]
                {
                    use std::os::unix::ffi::OsStrExt;
                    path.as_os_str().as_bytes()
                }
                #[cfg(windows)]
                {
                    // NOTE: no support for URF-8 paths!!!
                    &path.to_string_lossy().to_string().into_bytes()
                }
            };
            let bytes_len = str_bytes.len();
            let str_len = std::cmp::min(bytes_len, output_len);
            libc::memcpy(output.cast(), str_bytes.as_ptr().cast(), str_len);
            #[cfg(unix)]
            {
                *output.offset((str_len) as isize) = 0;
                *bytes_written = str_len + 1;
                *total_bytes = bytes_len + 1;
            }
            #[cfg(windows)]
            {
                *bytes_written = str_len;
                *total_bytes = bytes_len;
            }
        },
        None => {
            *bytes_written = 0;
            *total_bytes = 0;
        }
    }
}

