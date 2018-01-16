From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 6/7] overlay: test encode/decode overlay file handles
Date: Tue, 16 Jan 2018 19:06:51 +0800
Message-ID: <20180116110651.GK3102@eguan.usersys.redhat.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
 <1515348445-1403-7-git-send-email-amir73il@gmail.com>
 <20180116073831.GH3102@eguan.usersys.redhat.com>
 <CAOQ4uxhTR70XdKm39r=TA_SktySHM=Y1qH4A0Eex37Own6k7Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbeAPLGy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 Jan 2018 06:06:54 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhTR70XdKm39r=TA_SktySHM=Y1qH4A0Eex37Own6k7Kw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 16, 2018 at 12:53:38PM +0200, Amir Goldstein wrote:
> On Tue, Jan 16, 2018 at 9:38 AM, Eryu Guan <eguan@redhat.com> wrote:
> > On Sun, Jan 07, 2018 at 08:07:24PM +0200, Amir Goldstein wrote:
> >> - Check encode/write/decode/read content of lower/upper file handles
> >> - Check encode/decode/write/read content of lower/upper file handles
> >> - Check decode/read of unlinked lower/upper files and directories
> >> - Check decode/read of lower file handles after copy up, link and unlink
> >> - Check decode/read of lower file handles after rename of parent and self
> >
> > I'm wondering that if this should be split into multiple tests somehow,
> > e.g. tests on regular files, tests on dirs and tests on hardlinks? It
> > might be eaiser to review and debug when there're test failures. But I
> > have no strong preference on this.
> >
> 
> I prefer not splitting the test, this is a classic test with sub-test cases.
> I may end up splitting the dir rename tests (open_by_handle -i/-o)
> to conform with a similar split that you requested in the generic test.
> 
> >>
> >> This test does not cover connectable file handles of non-directories,
> >> because name_to_handle_at() syscall does not support requesting
> >> connectable file handles.
> >>
> >> This test covers only encode/decode of file handles for overlayfs
> >> configuration of lower and upper on the same fs.
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> >>  tests/overlay/050     | 291 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  tests/overlay/050.out |  50 +++++++++
> >>  tests/overlay/group   |   1 +
> >>  3 files changed, 342 insertions(+)
> >>  create mode 100755 tests/overlay/050
> >>  create mode 100644 tests/overlay/050.out
> >
> > I ran the test on your ovl-nfs-export-v2 branch and saw failures like:
> >
> > --- tests/overlay/050.out       2018-01-16 14:51:11.350000000 +0800
> > +++ /root/xfstests/results//xfs_4k_crc/overlay/050.out.bad      2018-01-16 15:08:43.487000000 +0800
> > @@ -45,6 +45,9 @@
> >  test_file_handles SCRATCH_MNT/lowertestdir/subdir -p -o lower_subdir_file_handles
> >  test_file_handles SCRATCH_MNT -rp -i upper_file_handles
> >  test_file_handles SCRATCH_MNT -rp -i lower_file_handles
> > +open_by_handle() returned 116 incorrectly on a linked dir!
> >  test_file_handles SCRATCH_MNT -rp -i upper_subdir_file_handles
> >  test_file_handles SCRATCH_MNT -rp -i lower_subdir_file_handles
> > +open_by_handle() returned 116 incorrectly on a linked dir!
> >  test_file_handles SCRATCH_MNT/lowertestdir.new -rp -i lower_subdir_file_handles
> > +open_by_handle() returned 116 incorrectly on a linked dir!
> >
> > Are these failures expected?
> >
> 
> No. not expected. I wonder which base fs did you test with?
> Did you have OVERLAY_FS_VERIFY=y in config or verify=on in MOUNT_OPTIONS?
> (Not that I know any of the above should matter)

I didn't have OVERLAY_FS_VERIFY set in .config, but I did mount with "-o
verify=on", and underlying fs is xfs. Here is the screenshot:

[root@bootp-73-5-205 xfstests]# OVERLAY_MOUNT_OPTIONS="-o verify=on" ./check -s xfs_4k_crc -overlay overlay/050
SECTION       -- xfs_4k_crc
RECREATING    -- overlay on /mnt/testarea/test
FSTYP         -- overlay
PLATFORM      -- Linux/x86_64 bootp-73-5-205 4.15.0-rc2.ovl+
MKFS_OPTIONS  -- -f -b size=4k -m crc=1 /mnt/testarea/scratch
MOUNT_OPTIONS -- -o verify=on /mnt/testarea/scratch /mnt/testarea/scratch/ovl-mnt

overlay/050      - output mismatch (see /root/xfstests/results//xfs_4k_crc/overlay/050.out.bad)
    --- tests/overlay/050.out   2018-01-16 14:51:11.350000000 +0800
    +++ /root/xfstests/results//xfs_4k_crc/overlay/050.out.bad  2018-01-16 19:01:54.984000000 +0800
    @@ -45,6 +45,9 @@
     test_file_handles SCRATCH_MNT/lowertestdir/subdir -p -o lower_subdir_file_handles
     test_file_handles SCRATCH_MNT -rp -i upper_file_handles
     test_file_handles SCRATCH_MNT -rp -i lower_file_handles
    +open_by_handle() returned 116 incorrectly on a linked dir!
     test_file_handles SCRATCH_MNT -rp -i upper_subdir_file_handles
     test_file_handles SCRATCH_MNT -rp -i lower_subdir_file_handles
    +open_by_handle() returned 116 incorrectly on a linked dir!
    ...
    (Run 'diff -u tests/overlay/050.out /root/xfstests/results//xfs_4k_crc/overlay/050.out.bad'  to see the entire diff)
Ran: overlay/050
Failures: overlay/050
Failed 1 of 1 tests

And I just tried with ext4 as underlying fs and got the same result.

> 
> Do you see any overlayfs warnings in dmesg?

No, there's no warnings nor other useful information in dmesg, just
mount/umount xfs and drop caches messages.

Thanks,
Eryu
