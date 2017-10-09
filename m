From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] Consistent d_ino test for non-samefs setup
Date: Mon, 09 Oct 2017 11:01:28 +0530
Message-ID: <7895732.EJsSKPREHH@localhost.localdomain>
References: <20171008112558.19061-1-chandan@linux.vnet.ibm.com> <CAOQ4uxjGNwn89eK-MzgCNze6VcQAPo4o8efM-BVAJHb6YRCRnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751561AbdJIFao (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Oct 2017 01:30:44 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v995SlCE017042
        for <linux-unionfs@vger.kernel.org>; Mon, 9 Oct 2017 01:30:43 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2dfnbs01tp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Oct 2017 01:30:43 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 9 Oct 2017 06:30:41 +0100
In-Reply-To: <CAOQ4uxjGNwn89eK-MzgCNze6VcQAPo4o8efM-BVAJHb6YRCRnQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Monday, October 9, 2017 12:07:08 AM IST Amir Goldstein wrote:
> On Sun, Oct 8, 2017 at 2:25 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> > Changelog:
> > v1->v2:
> >  Address the following review comments from Amir.
> >  1. overlay/041 now uses _overlay_scratch_mount_dirs() introduced by the patch
> >     "overlay: create helper _overlay_scratch_mount_dirs()".
> 
> Just to mention explicitly to eryu this depends on a not yet merged
> patch on mine
> 
> >  2. Use _scratch_mkfs() instead of manually setting of the base filesystem.
> >  3. Use a directory in $OVL_BASE_TEST_DIR as the overlay instance's lowerdir.
> >  4. Remove redundant invocation of "chown" operation on a regular file to cause
> >     copy-up to occur.
> >
> >  tests/overlay/041     | 197 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/041.out |   2 +
> >  tests/overlay/group   |   1 +
> >  3 files changed, 200 insertions(+)
> >  create mode 100755 tests/overlay/041
> >  create mode 100644 tests/overlay/041.out
> >
> > diff --git a/tests/overlay/041 b/tests/overlay/041
> > new file mode 100755
> > index 0000000..5b3920a
> > --- /dev/null
> > +++ b/tests/overlay/041
> > @@ -0,0 +1,197 @@
> > +#! /bin/bash
> > +# FSQA Test No. 041
> > +#
> > +# Test consistent d_ino numbers on non-samefs setup
> > +# This is a variant of overlay/038 to test consistent d_ino numbers
> > +# for non-samefs setup.
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
> > +. ./common/attr
> > +
> > +# real QA test starts here
> > +_supported_fs overlay
> > +_supported_os Linux
> > +_require_scratch
> > +_require_test
> > +_require_attrs
> > +_require_test_program "t_dir_type"
> > +
> > +rm -f $seqres.full
> > +
> > +lowerdir=$OVL_BASE_TEST_DIR/$seq-ovl-lower
> > +rm -rf $lowerdir
> > +mkdir $lowerdir
> > +
> > +# Create our test files.
> > +mkdir $lowerdir/test_dir/
> > +mkdir $lowerdir/test_dir/pure_lower_dir
> > +mkdir $lowerdir/test_dir/merged_dir
> > +touch $lowerdir/test_file
> > +
> > +_scratch_mkfs
> > +
> > +upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> > +workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> > +
> > +_overlay_scratch_mount_dirs $lowerdir $upperdir $workdir
> > +
> > +# mount | grep -i overlay
> > +# echo "\$SCRATCH_MNT = $SCRATCH_MNT"
> 
> Leftover
> 

Sorry, I will post the next version of the patch with those statements removed.

Thanks once again for reviewing the patch.

-- 
chandan
