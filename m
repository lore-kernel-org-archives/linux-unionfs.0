From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 6/7] overlay: test encode/decode overlay file handles
Date: Tue, 16 Jan 2018 17:09:24 +0200
Message-ID: <CAOQ4uxhByAJsYiP=TStDd+-g70UrByRLu7_BXK_-GLN_M9PyHw@mail.gmail.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
 <1515348445-1403-7-git-send-email-amir73il@gmail.com> <20180116073831.GH3102@eguan.usersys.redhat.com>
 <CAOQ4uxhTR70XdKm39r=TA_SktySHM=Y1qH4A0Eex37Own6k7Kw@mail.gmail.com> <20180116110651.GK3102@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:44361 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbeAPPJ0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 Jan 2018 10:09:26 -0500
In-Reply-To: <20180116110651.GK3102@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 16, 2018 at 1:06 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Jan 16, 2018 at 12:53:38PM +0200, Amir Goldstein wrote:
>> On Tue, Jan 16, 2018 at 9:38 AM, Eryu Guan <eguan@redhat.com> wrote:
>> > On Sun, Jan 07, 2018 at 08:07:24PM +0200, Amir Goldstein wrote:
>> >> - Check encode/write/decode/read content of lower/upper file handles
>> >> - Check encode/decode/write/read content of lower/upper file handles
>> >> - Check decode/read of unlinked lower/upper files and directories
>> >> - Check decode/read of lower file handles after copy up, link and unlink
>> >> - Check decode/read of lower file handles after rename of parent and self
>> >
>> > I'm wondering that if this should be split into multiple tests somehow,
>> > e.g. tests on regular files, tests on dirs and tests on hardlinks? It
>> > might be eaiser to review and debug when there're test failures. But I
>> > have no strong preference on this.
>> >
>>
>> I prefer not splitting the test, this is a classic test with sub-test cases.
>> I may end up splitting the dir rename tests (open_by_handle -i/-o)
>> to conform with a similar split that you requested in the generic test.
>>
>> >>
>> >> This test does not cover connectable file handles of non-directories,
>> >> because name_to_handle_at() syscall does not support requesting
>> >> connectable file handles.
>> >>
>> >> This test covers only encode/decode of file handles for overlayfs
>> >> configuration of lower and upper on the same fs.
>> >>
>> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> >> ---
>> >>  tests/overlay/050     | 291 ++++++++++++++++++++++++++++++++++++++++++++++++++
>> >>  tests/overlay/050.out |  50 +++++++++
>> >>  tests/overlay/group   |   1 +
>> >>  3 files changed, 342 insertions(+)
>> >>  create mode 100755 tests/overlay/050
>> >>  create mode 100644 tests/overlay/050.out
>> >
>> > I ran the test on your ovl-nfs-export-v2 branch and saw failures like:
>> >
>> > --- tests/overlay/050.out       2018-01-16 14:51:11.350000000 +0800
>> > +++ /root/xfstests/results//xfs_4k_crc/overlay/050.out.bad      2018-01-16 15:08:43.487000000 +0800
>> > @@ -45,6 +45,9 @@
>> >  test_file_handles SCRATCH_MNT/lowertestdir/subdir -p -o lower_subdir_file_handles
>> >  test_file_handles SCRATCH_MNT -rp -i upper_file_handles
>> >  test_file_handles SCRATCH_MNT -rp -i lower_file_handles
>> > +open_by_handle() returned 116 incorrectly on a linked dir!
>> >  test_file_handles SCRATCH_MNT -rp -i upper_subdir_file_handles
>> >  test_file_handles SCRATCH_MNT -rp -i lower_subdir_file_handles
>> > +open_by_handle() returned 116 incorrectly on a linked dir!
>> >  test_file_handles SCRATCH_MNT/lowertestdir.new -rp -i lower_subdir_file_handles
>> > +open_by_handle() returned 116 incorrectly on a linked dir!
>> >
>> > Are these failures expected?
>> >
>>
>> No. not expected. I wonder which base fs did you test with?
>> Did you have OVERLAY_FS_VERIFY=y in config or verify=on in MOUNT_OPTIONS?
>> (Not that I know any of the above should matter)
>
> I didn't have OVERLAY_FS_VERIFY set in .config, but I did mount with "-o
> verify=on", and underlying fs is xfs. Here is the screenshot:
>
> [root@bootp-73-5-205 xfstests]# OVERLAY_MOUNT_OPTIONS="-o verify=on" ./check -s xfs_4k_crc -overlay overlay/050
> SECTION       -- xfs_4k_crc
> RECREATING    -- overlay on /mnt/testarea/test
> FSTYP         -- overlay
> PLATFORM      -- Linux/x86_64 bootp-73-5-205 4.15.0-rc2.ovl+
> MKFS_OPTIONS  -- -f -b size=4k -m crc=1 /mnt/testarea/scratch
> MOUNT_OPTIONS -- -o verify=on /mnt/testarea/scratch /mnt/testarea/scratch/ovl-mnt
>
> overlay/050      - output mismatch (see /root/xfstests/results//xfs_4k_crc/overlay/050.out.bad)
>     --- tests/overlay/050.out   2018-01-16 14:51:11.350000000 +0800
>     +++ /root/xfstests/results//xfs_4k_crc/overlay/050.out.bad  2018-01-16 19:01:54.984000000 +0800
>     @@ -45,6 +45,9 @@
>      test_file_handles SCRATCH_MNT/lowertestdir/subdir -p -o lower_subdir_file_handles
>      test_file_handles SCRATCH_MNT -rp -i upper_file_handles
>      test_file_handles SCRATCH_MNT -rp -i lower_file_handles
>     +open_by_handle() returned 116 incorrectly on a linked dir!
>      test_file_handles SCRATCH_MNT -rp -i upper_subdir_file_handles
>      test_file_handles SCRATCH_MNT -rp -i lower_subdir_file_handles
>     +open_by_handle() returned 116 incorrectly on a linked dir!
>     ...
>     (Run 'diff -u tests/overlay/050.out /root/xfstests/results//xfs_4k_crc/overlay/050.out.bad'  to see the entire diff)
> Ran: overlay/050
> Failures: overlay/050
> Failed 1 of 1 tests
>
> And I just tried with ext4 as underlying fs and got the same result.
>
>>
>> Do you see any overlayfs warnings in dmesg?
>
> No, there's no warnings nor other useful information in dmesg, just
> mount/umount xfs and drop caches messages.
>

What happened here is quite nice.
You do not have redirect_dir enabled by default and the test didn't
enable it as well.

Then this line in the test:
# Copy up lower dir, index and rename
mv $SCRATCH_MNT/lowertestdir $SCRATCH_MNT/lowertestdir.new/

...doesn't fail, because mv gets -EXDEV and falls back to "recursive move":
- Create new dir
- Move files from old dir to new dir
- Remove old file

When test later tries to decode the file handle encoded from old dir,
old dir has been removed, so the 116 (ESTALE) error is correct for
what happened here.

This error was detected thanks to the patch using the -i/-o options
from "open_by_handle: store and load file handles from file"
The earlier version of this directory rename test (like upstream generic/467)
would not have detected this error because dir file handle was encoded
after the mv command.

The take aways are:
1. Split the dir rename test cases to a separate test
2. Require and enable redirect_dir feature in the dir rename test

Thanks,
Amir.
