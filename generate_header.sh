# Usage:
# ./generate-header.sh > <output-dir>


echo "// a low-level library that provides config/cache/data paths, following the respective
// conventions on Linux, macOS and Windows
// 
// Bindings written by: Jomy10 (Jonas Everart)
// Original library: https://github.com/dirs-dev/dirs-rs"
echo ""

echo "// This header was generated"
echo ""
echo "#include <stdlib.h>"

echo ""
echo "#ifndef _DIRS_H"
echo "#define _DIRS_H"

echo "
// Result type for all dir calls
//
// - When bytes_total != bytes_written, this means the output string was not
// sufficiently large enough to hold all the data.
// - When both variables are 0, this means the path could not be retrieved
typedef struct {
  // The amount of bytes that have been written to the output variable. This
  // includes the null-terminator
  size_t bytes_written;
  // The amount of bytes the path required to be written to the output variable.
  // This incudes the null-terminator
  size_t bytes_total;
} DirResult;"
echo ""

echo "#ifdef __cplusplus"
echo 'extern "C" {'
echo "#endif"
echo ""

dirs=(
  audio
  cache
  config
  config_local
  data
  data_local
  desktop
  document
  download
  executable
  font
  home
  picture
  preference
  public
  runtime
  state
  template
  video
)

for dir in "${dirs[@]}"
do
  echo "DirResult ${dir}_dir(char* output, size_t output_len);"
done

echo ""
echo "#ifdef __cplusplus"
echo '} // extern "C"'
echo "#endif"

echo ""
echo "#endif // include guard"
echo ""

echo "// MIT License
// 
// Copyright (c) 2023 Jonas Everaert
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
"


