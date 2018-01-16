From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 6/7] overlay: test encode/decode overlay file handles
Date: Tue, 16 Jan 2018 12:53:38 +0200
Message-ID: <CAOQ4uxhTR70XdKm39r=TA_SktySHM=Y1qH4A0Eex37Own6k7Kw@mail.gmail.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
 <1515348445-1403-7-git-send-email-amir73il@gmail.com> <20180116073831.GH3102@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180116073831.GH3102@eguan.usersys.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jan 16, 2018 at 9:38 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Sun, Jan 07, 2018 at 08:07:24PM +0200, Amir Goldstein wrote:
>> - Check encode/write/decode/read content of lower/upper file handles
>> - Check encode/decode/write/read content of lower/upper file handles
>> - Check decode/read of unlinked lower/upper files and directories
>> - Check decode/read of lower file handles after copy up, link and unlink
>> - Check decode/read of lower file handles after rename of parent and self
>
> I'm wondering that if this should be split into multiple tests somehow,
> e.g. tests on regular files, tests on dirs and tests on hardlinks? It
> might be eaiser to review and debug when there're test failures. But I
> have no strong preference on this.
>

I prefer not splitting the test, this is a classic test with sub-test cases.
I may end up splitting the dir rename tests (open_by_handle -i/-o)
to conform with a similar split that you requested in the generic test.

>>
>> This test does not cover connectable file handles of non-directories,
>> because name_to_handle_at() syscall does not support requesting
>> connectable file handles.
>>
>> This test covers only encode/decode of file handles for overlayfs
>> configuration of lower and upper on the same fs.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  tests/overlay/050     | 291 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/overlay/050.out |  50 +++++++++
>>  tests/overlay/group   |   1 +
>>  3 files changed, 342 insertions(+)
>>  create mode 100755 tests/overlay/050
>>  create mode 100644 tests/overlay/050.out
>
> I ran the test on your ovl-nfs-export-v2 branch and saw failures like:
>
> --- tests/overlay/050.out       2018-01-16 14:51:11.350000000 +0800
> +++ /root/xfstests/results//xfs_4k_crc/overlay/050.out.bad      2018-01-16 15:08:43.487000000 +0800
> @@ -45,6 +45,9 @@
>  test_file_handles SCRATCH_MNT/lowertestdir/subdir -p -o lower_subdir_file_handles
>  test_file_handles SCRATCH_MNT -rp -i upper_file_handles
>  test_file_handles SCRATCH_MNT -rp -i lower_file_handles
> +open_by_handle() returned 116 incorrectly on a linked dir!
>  test_file_handles SCRATCH_MNT -rp -i upper_subdir_file_handles
>  test_file_handles SCRATCH_MNT -rp -i lower_subdir_file_handles
> +open_by_handle() returned 116 incorrectly on a linked dir!
>  test_file_handles SCRATCH_MNT/lowertestdir.new -rp -i lower_subdir_file_handles
> +open_by_handle() returned 116 incorrectly on a linked dir!
>
> Are these failures expected?
>

No. not expected. I wonder which base fs did you test with?
Did you have OVERLAY_FS_VERIFY=y in config or verify=on in MOUNT_OPTIONS?
(Not that I know any of the above should matter)

Do you see any overlayfs warnings in dmesg?

>>
>> diff --git a/tests/overlay/050 b/tests/overlay/050
>> new file mode 100755
>> index 0000000..4dcd66a
>> --- /dev/null
>> +++ b/tests/overlay/050
>> @@ -0,0 +1,291 @@
>> +#! /bin/bash
>> +# FS QA Test No. 050
>> +#
>> +# Test encode/decode overlay file handles
>> +#
>> +# - Check encode/write/decode/read content of lower/upper file handles
>> +# - Check encode/decode/write/read content of lower/upper file handles
>> +# - Check decode/read of unlinked lower/upper files and directories
>> +# - Check decode/read of lower file handles after copy up, link and unlink
>> +# - Check decode/read of lower file handles after rename of parent and self
>> +#
>> +# This test does not cover connectable file handles of non-directories,
>> +# because name_to_handle_at() syscall does not support requesting connectable
>> +# file handles.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
>                    ^^^^ 2018? :)

Yeh, just added that.
That's now officially a multi year development effort ;-)

>
>> +# Author: Amir Goldstein <amir73il@gmail.com>
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#-----------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1     # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +     cd /
>> +     rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs overlay
>> +_supported_os Linux
>> +_require_scratch
>> +# _require_exportfs already requires open_by_handle, but let's not count on it
>> +_require_test_program "open_by_handle"
>> +_require_exportfs
>
> From the commits in your development branch, I know that overlay
> exportfs support depends on "verify" feature, I'm wondering if we should
> check "verify" feature explicitly? So we know we need to enable "verify"
> feature, otherwise we just got "[not run] overlay does not support NFS
> export", which seems not so informative.
>
> Perhaps we should mention it in commit log too.

For V3 the opt-in feature name is "nfs_export", so I changed the
test to:

-_require_exportfs
+_require_scratch_feature nfs_export

 mount_dirs()
 {
-       _scratch_mount
+       _scratch_mount -o nfs_export=on
 }

Now I think that is pretty much self explanatory,
but will add a note in commit message.

However, please note that the generic/exportfs tests check for
_require_exportfs (on test partition), so those tests will still
"[not run] overlay does not support NFS export" unless user
sets CONFIG_OVERLAY_FS_NFS_EXPORT=y or
MOUNT_OPTIONS="-o nfs_export=on"

I think that is fine and should stay like this.
If user sees that overlayfs does not support NFS  export, she can go
to overlayfs documentation and see how to enable NFS export support.

>
>> +
>> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER/lowertestdir
>> +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER/uppertestdir
>> +lowertestdir=$SCRATCH_MNT/lowertestdir
>> +uppertestdir=$SCRATCH_MNT/uppertestdir
>
> Hmm, the "lowerdir"/"upperdir" always make me think them as the
> lowerdir/upperdir used in overlay mount options.., and they actually
> should be lowertestdir/uppertestdir, i.e.
>
> losertestdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER/lowertestdir
> uppertestdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER/uppertestdir
>
> and rename the previous "$lowertestdir"/"$uppertestdir" to other names,
> maybe
>
> ovl_lowertestdir=$SCRATCH_MNT/lowertestdir
> ovl_uppertestdir=$SCRATCH_MNT/uppertestdir
>
> I'm not good at naming variables..
>

Totally agree with you.
Instead of using goofy long variable names, I will use more explicit
expressions, e.g.:

create_test_files $upper/uppertestdir
create_test_files $lower/lowertestdir
test_file_handles $SCRATCH_MNT/uppertestdir
test_file_handles $SCRATCH_MNT/lowertestdir

Which is more similar to how golden output looks.

>> +NUMFILES=1
>> +
>> +# Create test dir and empty test files
>> +create_test_files()
>> +{
>> +     local dir=$1
>> +     local opt=$2
>> +
>> +     mkdir -p $dir
>> +     src/open_by_handle -cp $opt $dir $NUMFILES
>
> $here/src/open_by_handle? Using "$here" for consistency.

OK.

>
>> +}
>> +
>> +# Test encode/decode file handles on overlay mount
>> +test_file_handles()
>> +{
>> +     local dir=$1
>> +     shift
>> +
>> +     echo test_file_handles $dir $* | _filter_scratch | _filter_ovl_dirs | \
>> +                             sed -e "s,$tmp\.,,g"
>> +     $here/src/open_by_handle $* $dir $NUMFILES
>> +}
>> +
>> +# Re-create lower/upper/work dirs
>> +create_dirs()
>> +{
>> +     _scratch_mkfs
>> +}
>> +
>> +# Mount an overlay on $SCRATCH_MNT with all layers on scratch partition
>> +mount_dirs()
>> +{
>> +     _scratch_mount
>> +}
>> +
>> +# Unmount & check the overlay layers
>> +unmount_dirs()
>> +{
>> +     _scratch_unmount
>> +     _check_scratch_fs
>> +}
>> +
>> +# Check non-stale file handles of lower/upper files and verify
>> +# that handle decoded before copy up is encoded to upper after
>                  ^^^^^^^ encoded?          ^^^^^^^ decoded?

Oops. Thanks.

>> +# copy up. Verify reading data from file open by file handle
>> +# and verify access_at() with dirfd open by file handle.
>> +create_dirs
>> +create_test_files $upperdir
>> +create_test_files $lowerdir
>> +mount_dirs
>> +# Check encode/decode of upper regular file handles
>> +test_file_handles $uppertestdir
>> +# Check encode/decode of upper dir file handle
>> +test_file_handles $uppertestdir -p
>> +# Check encode/write/decode/read/write of upper file handles
>> +test_file_handles $uppertestdir -wrap
>> +# Check encode/decode of lower regular file handles before copy up
>> +test_file_handles $lowertestdir
>> +# Check encode/decode of lower dir file handles before copy up
>> +test_file_handles $lowertestdir -p
>> +# Check encode/write/decode/read/write of lower file handles across copy up
>> +test_file_handles $lowertestdir -wrap
>> +unmount_dirs
>> +
>> +# Check copy up after encode/decode of lower/upper files
>> +# (copy up of disconnected dentry to index dir)
>> +create_dirs
>> +create_test_files $upperdir
>> +create_test_files $lowerdir
>> +mount_dirs
>> +# Check encode/decode/write/read of upper regular file handles
>> +test_file_handles $uppertestdir -a
>> +test_file_handles $uppertestdir -r
>> +# Check encode/decode/write/read of lower regular file handles
>> +test_file_handles $lowertestdir -a
>> +test_file_handles $lowertestdir -r
>> +unmount_dirs
>> +
>> +# Check non-stale handles to unlinked but open lower/upper files
>> +create_dirs
>> +create_test_files $upperdir
>> +create_test_files $upperdir.rw
>> +create_test_files $lowerdir
>> +create_test_files $lowerdir.rw
>> +mount_dirs
>> +test_file_handles $uppertestdir -dk
>> +# Check encode/write/unlink/decode/read of upper regular file handles
>> +test_file_handles $uppertestdir.rw -rwdk
>> +test_file_handles $lowertestdir -dk
>> +# Check encode/write/unlink/decode/read of lower file handles across copy up
>> +test_file_handles $lowertestdir.rw -rwdk
>> +unmount_dirs
>> +
>> +# Check stale handles of unlinked lower/upper files (nlink = 1,0)
>
> Seems there's no nlink=1 case in this subtest.

nlink=1 on encode and nlink=0 on decode.
it's just not adding anything to test encode/decode with nlink=1
because that has already been tests by first subtest, as you corretly
noted in the cases below.

>
>> +create_dirs
>> +create_test_files $upperdir
>> +create_test_files $lowerdir
>> +mount_dirs
>> +# Check decode of upper file handles after unlink/rmdir (nlink == 0)
>> +test_file_handles $uppertestdir -dp
>> +# Check decode of lower file handles after unlink/rmdir (nlink == 0)
>> +test_file_handles $lowertestdir -dp
>> +unmount_dirs
>> +
>> +# Check non-stale file handles of linked lower/upper files (nlink = 1,2,1)
>> +create_dirs
>> +create_test_files $upperdir
>> +create_test_files $lowerdir
>> +mount_dirs
>> +# Check encode/decode of upper file handles (nlink == 1)
>> +test_file_handles $uppertestdir
>
> This nlink=1 case has been tested in the first subtest.

Correct. Removed.

>
>> +# Check decode/read of upper file handles after link (nlink == 2)
>> +test_file_handles $uppertestdir -wlr
>> +# Check decode/read of upper file handles after link + unlink (nlink == 1)
>> +test_file_handles $uppertestdir -ur
>> +# Check encode/decode of lower file handles before copy up (nlink == 1)
>> +test_file_handles $lowertestdir
>
> Same here.

Removed.

>
>> +# Check decode/read of lower file handles after copy up + link (nlink == 2)
>> +test_file_handles $lowertestdir -wlr
>> +# Check decode/read of lower file handles after copy up + link + unlink (nlink == 1)
>> +test_file_handles $lowertestdir -ur
>> +unmount_dirs
>> +
>> +# Check non-stale file handles of linked lower/upper hardlinks (nlink = 2,1)
>> +create_dirs
>> +create_test_files $upperdir
>> +create_test_files $lowerdir
>> +# Create lower/upper hardlinks
>> +test_file_handles $lowerdir -l >/dev/null
>> +test_file_handles $upperdir -l >/dev/null
>
> Add comments on why discard the stdout above?

I created a link_test_files helper instead of hacking around test_file_handles
output

>
>> +mount_dirs
>> +# Check encode/decode of upper hardlink file handles (nlink == 2)
>> +test_file_handles $uppertestdir
>> +# Check decode/read of upper hardlink file handles after unlink (nlink == 1)
>> +test_file_handles $uppertestdir -wur
>> +# Check encode/decode of lower hardlink file handles before copy up (nlink == 2)
>> +test_file_handles $lowertestdir
>> +# Check decode/read of lower hardlink file handles after copy up + unlink (nlink == 1)
>> +test_file_handles $lowertestdir -wur
>
> At first I suspected that this would fail if index feature was disabled,
> then I found that verify feature depends on index feature. I think this
> should be mentioned in commit log and in test as comment too.
>

OK. Will add that too.

Thanks a lot for review!

Amir.
