From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V2] overlay: Test constant d_ino feature
Date: Thu, 31 Aug 2017 18:37:34 +0300
Message-ID: <CAOQ4uxgBRt3x2fWQhkGR9GNoetc4V-x9TOSq_X6OgRgz9UVaCQ@mail.gmail.com>
References: <20170831063532.7505-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxj_y4DaHYBDQYh4q_q8FZtfrPCSC5t_h1dv76D8UaSfbQ@mail.gmail.com> <2232737.iLHkCjWW4g@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:34828 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdHaPhg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Aug 2017 11:37:36 -0400
In-Reply-To: <2232737.iLHkCjWW4g@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Aug 31, 2017 at 6:12 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Thursday, August 31, 2017 12:39:13 PM IST Amir Goldstein wrote:
>> On Thu, Aug 31, 2017 at 9:35 AM, Chandan Rajendra
>> <chandan@linux.vnet.ibm.com> wrote:
>> > This commit adds a test to verify constant d_ino feature. The following
>> > scenarios are checked,
>> > - Parent's (i.e. "..") d_ino must always be calculated because a pure
>> >   dir can be residing inside a merged dir.
>> > - d_ino for "." must always be calculated because the present directory
>> >   can have a copy-up origin.
>> > - Verify d_ino values corresponding to "." and ".." entries of a pure
>> >   lower dir.
>> > - Verify d_ino of ".." entry of a merged dir.
>> > - Verify pure lower residing in dir which has another lower layer pure
>> >   lower residing in dir which has another lower layer.
>> >
>> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> > ---
>> > Changelog:
>> > v1->v2:
>> > 1. Removed tests copied over from overlay/017.
>> > 2. Removed src/t_dir_ino.c.
>> > 3. Add code for testing,
>> >    - d_ino of . and .. entries of pure_lower_dir.
>> >    - d_ino of .. entry of merged_dir.
>> >    - Verify pure lower residing in dir which has another lower layer.
>> >    Thanks to Amir for suggesting these tests.
>>
>> Nice work!
>> See more comments below.
>>
>> >
>> >  tests/overlay/037     | 144 ++++++++++++++++++++++++++++++++++++++++++++++++++
>> >  tests/overlay/037.out |   2 +
>> >  tests/overlay/group   |   1 +
>> >  3 files changed, 147 insertions(+)
>> >  create mode 100755 tests/overlay/037
>> >  create mode 100644 tests/overlay/037.out
>> >
>> > diff --git a/tests/overlay/037 b/tests/overlay/037
>> > new file mode 100755
>> > index 0000000..225d2b9
>> > --- /dev/null
>> > +++ b/tests/overlay/037
>> > @@ -0,0 +1,144 @@
>> > +#! /bin/bash
>> > +# FSQA Test No. 037
>> > +#
>> > +# Test constant d_ino numbers
>> > +#
>> > +#-----------------------------------------------------------------------
>> > +#
>> > +# Copyright (C) 2017 IBM Corporation. All Rights Reserved.
>> > +# Author: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> > +#
>> > +# This program is free software; you can redistribute it and/or
>> > +# modify it under the terms of the GNU General Public License as
>> > +# published by the Free Software Foundation.
>> > +#
>> > +# This program is distributed in the hope that it would be useful,
>> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> > +# GNU General Public License for more details.
>> > +#
>> > +# You should have received a copy of the GNU General Public License
>> > +# along with this program; if not, write the Free Software Foundation,
>> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> > +#-----------------------------------------------------------------------
>> > +#
>> > +
>> > +seq=`basename $0`
>> > +seqres=$RESULT_DIR/$seq
>> > +echo "QA output created by $seq"
>> > +
>> > +here=`pwd`
>> > +tmp=/tmp/$$
>> > +status=1       # failure is the default!
>> > +trap "_cleanup; exit \$status" 0 1 2 3 15
>> > +
>> > +_cleanup()
>> > +{
>> > +       cd /
>> > +       rm -f $tmp.*
>> > +}
>> > +
>> > +# get standard environment, filters and checks
>> > +. ./common/rc
>> > +. ./common/filter
>> > +
>> > +# real QA test starts here
>> > +_supported_fs overlay
>> > +_supported_os Linux
>> > +_require_scratch
>> > +_require_test_program "af_unix"
>> > +_require_test_program "t_dir_type"
>> > +
>> > +rm -f $seqres.full
>> > +
>> > +_scratch_mkfs >>$seqres.full 2>&1
>> > +
>> > +# Create our test files.
>> > +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
>> > +mkdir -p $lowerdir
>> > +
>> > +pure_lower_dir=$lowerdir/pure_lower_dir
>> > +impure_dir=$lowerdir/impure_dir
>>
>> You name this dir "impure", but I don't see anything impure about it
>> in the test.
>> Maybe it is a good idea to repeat the d_ino tests on impure_dir before and after
>> dir becomes impure.
>> The readdir code logic is really different depending on dir impure xattr.
>> although it should not affect results of d_ino for . and .. its a good
>> idea to verify that.
>> Besides, its good to verify that readdir cache is correctly
>> invalidated when pure
>> dir becomes impure and it would be also good to verify that cache is invalidated
>> when impure dir becomes pure again (bonus for checking that impure
>> xattr is removed)
>
> Amir, Since overlayfs does not maintain a readdir cache for pure directories,
> I guess you wanted the test to check for cache invalidation in the case of
> an impure dir becoming a pure dir.
>

Yes, you are right. I meant the new ovl_iterate_real() code handles both
impure dirs and pure dirs with merge parent, so its good to check both cases
and the transition between them.
