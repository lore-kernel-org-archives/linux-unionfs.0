From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] overlay: Test constant d_ino feature
Date: Mon, 28 Aug 2017 20:43:26 +0530
Message-ID: <4635087.O3gf5rlFrC@localhost.localdomain>
References: <20170828080032.16399-1-chandan@linux.vnet.ibm.com> <CAOQ4uxj1d1m7abXEP_5Aj_=kFheGYiK4hfppHpJUQnL39h3Tpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751232AbdH1PMw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Aug 2017 11:12:52 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7SFAd3K038568
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Aug 2017 11:12:51 -0400
Received: from e23smtp06.au.ibm.com (e23smtp06.au.ibm.com [202.81.31.148])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cmfx37w98-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Aug 2017 11:12:51 -0400
Received: from localhost
        by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 29 Aug 2017 01:12:46 +1000
In-Reply-To: <CAOQ4uxj1d1m7abXEP_5Aj_=kFheGYiK4hfppHpJUQnL39h3Tpw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Monday, August 28, 2017 3:59:32 PM IST Amir Goldstein wrote:
> On Mon, Aug 28, 2017 at 11:00 AM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > This commit adds a test to verify constant d_ino feature. To be precise,
> > the following scenarios are checked,
> > - Files on lowerdir will have ino from lowerdir reported (even after
> >   copy-up).
> > - For entries in impure directories, we need to recalculate d_ino all
> >   the time.
> > - Parent's (i.e. "..") d_ino must always be calculated i.e. Pure upper
> >   directory residing in a merged directory.
> > - For "." directory entry, we need to recalculate d_ino all the time.
> >
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> >  src/Makefile          |   2 +-
> >  src/t_dir_ino.c       |  78 ++++++++++++++++++++++
> >  tests/overlay/037     | 174 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/037.out |   2 +
> >  tests/overlay/group   |   1 +
> >  5 files changed, 256 insertions(+), 1 deletion(-)
> >  create mode 100644 src/t_dir_ino.c
> >  create mode 100755 tests/overlay/037
> >  create mode 100644 tests/overlay/037.out
> >
> > diff --git a/src/Makefile b/src/Makefile
> > index b8aff49..f509870 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -23,7 +23,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> >         seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
> >         renameat2 t_getcwd e4compact test-nextquota punch-alternating \
> >         attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
> > -       dio-invalidate-cache stat_test t_encrypted_d_revalidate
> > +       dio-invalidate-cache stat_test t_encrypted_d_revalidate t_dir_ino
> >
> >  SUBDIRS =
> >
> > diff --git a/src/t_dir_ino.c b/src/t_dir_ino.c
> > new file mode 100644
> > index 0000000..0c41d41
> > --- /dev/null
> > +++ b/src/t_dir_ino.c
> > @@ -0,0 +1,78 @@
> > +/*
> > + * Copyright (C) 2017 IBM Corporation. All Rights Reserved.
> > + * Author: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > + */
> > +
> > +/*
> > + * t_dir_ino
> > + *
> > + * print directory entries and their d_ino numbers
> > + *
> > + * ./t_dir_ino <path>
> > + */
> > +
> > +#include <fcntl.h>
> > +#include <stdio.h>
> > +#include <unistd.h>
> > +#include <stdint.h>
> > +#include <stdlib.h>
> > +#include <dirent.h>
> > +#include <sys/stat.h>
> > +#include <sys/syscall.h>
> > +
> > +struct linux_dirent64 {
> > +       uint64_t        d_ino;
> > +       int64_t         d_off;
> > +       unsigned short  d_reclen;
> > +       unsigned char   d_type;
> > +       char            d_name[0];
> > +};
> > +
> > +#define BUF_SIZE 4096
> > +
> > +int
> > +main(int argc, char *argv[])
> > +{
> > +       int fd, nread;
> > +       char buf[BUF_SIZE];
> > +       struct linux_dirent64 *d;
> > +       int bpos;
> > +
> > +       fd = open(argv[1], O_RDONLY | O_DIRECTORY);
> > +       if (fd < 0) {
> > +               perror("open");
> > +               exit(EXIT_FAILURE);
> > +       }
> > +
> > +       for ( ; ; ) {
> > +               nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);
> > +               if (nread == -1) {
> > +                       perror("getdents");
> > +                       exit(EXIT_FAILURE);
> > +               }
> > +
> > +               if (nread == 0)
> > +                       break;
> > +
> > +               for (bpos = 0; bpos < nread;) {
> > +                       d = (struct linux_dirent64 *) (buf + bpos);
> > +                       printf("%lu %s\n", d->d_ino, d->d_name);
> > +                       bpos += d->d_reclen;
> > +               }
> > +       }
> > +
> > +       exit(EXIT_SUCCESS);
> > +}
> 
> Sorry, but I don't see any value that t_d_ino brings that's
> not already provided by t_dir_type <dir> <ino> used by test overlay/017
> 
> > diff --git a/tests/overlay/037 b/tests/overlay/037
> > new file mode 100755
> > index 0000000..25c345f
> > --- /dev/null
> > +++ b/tests/overlay/037
> > @@ -0,0 +1,174 @@
> > +#! /bin/bash
> > +# FSQA Test No. 037
> > +#
> > +# Test constant d_ino numbers
> > +#
> > +#-----------------------------------------------------------------------
> > +#
> > +# Copyright (C) 2017 IBM Corporation. All Rights Reserved.
> > +# Author: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1       # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +       cd /
> > +       rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs overlay
> > +_supported_os Linux
> > +_require_scratch
> > +_require_test_program "af_unix"
> > +_require_test_program "t_dir_ino"
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +
> > +# Create our test files.
> > +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> > +mkdir -p $lowerdir
> > +mkdir $lowerdir/dir
> > +touch $lowerdir/file
> > +ln -s $lowerdir/file $lowerdir/symlink
> > +mknod $lowerdir/chrdev c 1 1
> > +mknod $lowerdir/blkdev b 1 1
> > +mknod $lowerdir/fifo p
> > +$here/src/af_unix $lowerdir/socket
> > +touch $lowerdir/hardlink1
> > +ln $lowerdir/hardlink1 $lowerdir/hardlink2
> > +
> > +FILES="dir file symlink chrdev blkdev fifo socket hardlink1 hardlink2"
> > +
> > +# Record inode numbers in format <ino> <basename>
> > +function record_inode_numbers()
> > +{
> > +       dir=$1
> > +       outfile=$2
> > +
> > +       for f in $FILES; do
> > +               ls -id $dir/$f
> > +       done | \
> > +       while read ino file; do
> > +               echo $ino `basename $file` >> $outfile
> > +       done
> > +}
> > +
> > +# Verify that d_ino matches st_ino
> > +function check_d_ino()
> > +{
> > +       dir=$1
> > +       st_list=$2
> > +
> > +       d_ino_list=$($here/src/t_dir_ino $dir)
> > +
> > +       for f in $FILES; do
> > +               d_ino=$(echo "$d_ino_list" | grep $f | cut -d ' ' -f 1)
> > +               st_ino=$(cat $st_list | grep $f | cut -d ' ' -f 1)
> > +               [[ $st_ino != $d_ino ]] && \
> > +                       echo "$f has mismatching st_ino ($st_ino) and d_ino ($d_ino)"
> > +       done
> > +}
> 
> Sorry, I don't see what this test adds. check_inode_numbers()
> in test overlay/017 already checks match of d_ino to recorded st_ino
> using $here/src/t_dir_type $dir $ino | grep -q $f
> 
> > +
> > +_scratch_mount
> > +
> > +rm -f $tmp.*
> > +testdir=$SCRATCH_MNT/test
> > +mkdir -p $testdir
> > +
> > +# Record inode numbers before copy up
> > +record_inode_numbers $SCRATCH_MNT $tmp.st_ino
> > +
> > +# Verify that d_ino matches st_ino
> > +check_d_ino $SCRATCH_MNT $tmp.st_ino
> > +
> > +for f in $FILES; do
> > +       # chown -h modifies all those file types
> > +       chown -h 100 $SCRATCH_MNT/$f
> > +done
> > +
> > +# Compare inode numbers before/after copy up.
> > +# For entries in impure directories, we need to recalculate
> > +# d_ino all the time.
> > +check_d_ino $SCRATCH_MNT $tmp.st_ino
> > +
> > +for f in $FILES; do
> > +       # move to another dir
> > +       mv $SCRATCH_MNT/$f $testdir/
> > +done
> > +
> > +echo 3 > /proc/sys/vm/drop_caches
> > +
> > +# Compare inode numbers before/after rename and drop caches
> > +check_d_ino $testdir $tmp.st_ino
> > +
> > +# Verify that the inode numbers survive a mount cycle
> > +_scratch_cycle_mount
> > +
> > +# Compare inode numbers before/after mount cycle
> > +check_d_ino $testdir $tmp.st_ino
> > +
> > +_scratch_unmount
> 
> So all the test up to here seems completely redundant to overlay/017
> unless I am missing something?

Hi Amir,

The idea was to move all the "constant d_ino" tests into one script. I will
remove the above tests in the next version of the patch.

> 
> > +
> > +# Parent's (i.e. "..") d_ino must always be calculated because a pure
> > +# dir can be residing inside a merged dir.
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +
> > +mkdir -p $lowerdir
> > +mkdir $lowerdir/merged_dir
> > +
> > +merged_dir_st_ino=$(stat -c '%i' $lowerdir/merged_dir)
> > +
> > +_scratch_mount
> > +
> > +parent_st_ino=$(stat -c '%i' $SCRATCH_MNT/merged_dir)
> 
> This is supposed to be equal to $merged_dir_st_ino, but you never
> really verify that explicitly.
> 

merged_dir_st_ino was created to verify the next test case i.e. d_ino of "."
of a directory must always be calculated because the present directory
can have a copy-up origin. But as you have suggested below merged_dir_st_ino
will be useful for looking up d_ino by using st_ino.

> > +
> > +pure_upper_dir=$SCRATCH_MNT/merged_dir/pure_upper_dir
> > +mkdir -p $pure_upper_dir
> > +
> > +d_ino_list=$($here/src/t_dir_ino $pure_upper_dir)
> > +parent_d_ino=$(echo "$d_ino_list" | grep -F '..' | cut -d ' ' -f 1)
> > +
> > +[[ $parent_d_ino != $parent_st_ino ]] && \
> > +       echo "Invalid d_ino reported for pure upper directory's merged parent"
> 
> Suggesting to lookup parent dir by $merged_dir_st_ino instead:
> 
> parent_d=$($here/src/t_dir_type $pure_upper_dir $merged_dir_st_ino)
> [[ "$parent_d" != ".. d" ]] && \
>        echo "Invalid d_ino ...

I agree. This makes t_dir_ino redundant.

> 
> > +
> > +
> > +# d_ino for "." must always be calculated because the present
> > +# directory can have a copy-up origin.
> > +d_ino_list=$($here/src/t_dir_ino $SCRATCH_MNT/merged_dir)
> > +d_ino=$(echo "$d_ino_list" | grep ' \.$' | cut -d ' ' -f 1)
> > +
> > +[[ $merged_dir_st_ino != $d_ino ]] && \
> > +       echo "Invalid d_ino reported for '.' entry"
> > +
> 
> Similarly:
> 
> current_d=$($here/src/t_dir_type $SCRATCH_MNT/merged_dir $merged_dir_st_ino)
> [[ "$current_d" != ". d" ]] && \
>        echo "Invalid d_ino ...
> 
> The test ends being quite short with just these 2 checks of "." and "..",
> so I suggest that you add the following cases:
> - d_ino of . and .. entries of pure_lower_dir (should pass on upstream kernel)
> - d_ino of .. entry of merged_dir (I think Miklos' patch handles this case)
> - and the case we discussed of multiple lower layers where pure_lower_dir
>   is in lowermost layer and merged_dir's origin is in mid layer

Sure, I will implement these tests and post the next version of the patch.

Thanks for your review comments.

-- 
chandan
