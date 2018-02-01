From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] overlay: test overlay file handles of lower dir with
 non-indexed ancestor
Date: Thu, 1 Feb 2018 09:34:19 +0200
Message-ID: <CAOQ4uxhqOQBGkmZOW03NY8ZU6u-LZc_QFBsP6c7FtLd-sL+eXg@mail.gmail.com>
References: <1517399095-28512-1-git-send-email-amir73il@gmail.com>
 <1517399095-28512-2-git-send-email-amir73il@gmail.com> <20180201072719.GI18267@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:35391 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbeBAHeV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Feb 2018 02:34:21 -0500
In-Reply-To: <20180201072719.GI18267@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Thu, Feb 1, 2018 at 9:27 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Jan 31, 2018 at 01:44:54PM +0200, Amir Goldstein wrote:
>> Overlayfs with nfs_export enabled, indexes all directories on copy up.
>> Directory index is requires for decoding lower directory file handles
>> in case ancestors have been renamed.
>>
>> When enabling nfs_export on an overlay that already has non-indexed
>> merge dirs, the possibility of non-indexed ancestor rename requires
>> special handling when encoding lower directory file handles.
>>
>> - Check encode/decode/read file handles of non-indexed merge dir
>> - Check encode/decode/read file handles of dir with non-indexed parent
>> - Check encode/decode/read file handles of dir with non-indexed grandparent
>> - Check decode/read of file handles after rename of non-indexed merge dir
>> - Check decode/read of file handles after rename of non-indexed parent
>> - Check decode/read of file handles after rename of non-indexed grandparent
>>
>> This test requires and enables overlayfs NFS export support and merge
>> dir rename support (redirect_dir).
>> NFS export support depends on and requires overlayfs index feature.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  tests/overlay/054     | 162 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/overlay/054.out |  11 ++++
>>  tests/overlay/group   |   1 +
>>  3 files changed, 174 insertions(+)
>>  create mode 100755 tests/overlay/054
>>  create mode 100644 tests/overlay/054.out
>>
>> diff --git a/tests/overlay/054 b/tests/overlay/054
>> new file mode 100755
>> index 0000000..c788460
>> --- /dev/null
>> +++ b/tests/overlay/054
>> @@ -0,0 +1,162 @@
>> +#! /bin/bash
>> +# FS QA Test No. 054
>> +#
>> +# Test encode/decode overlay file handle of dir with non-indexed ancestor
>> +#
>> +# Overlayfs with nfs_export enabled, indexes all directories on copy up.
>> +# Directory index is requires for decoding lower directory file handles
>> +# in case ancestors have been renamed.
>> +#
>> +# When enabling nfs_export on an overlay that already has non-indexed
>> +# merge dirs, the possibility of non-indexed ancestor rename requires
>> +# special handling when encoding lower directory file handles.
>> +#
>> +# - Check encode/decode/read file handles of non-indexed merge dir
>> +# - Check encode/decode/read file handles of dir with non-indexed parent
>> +# - Check encode/decode/read file handles of dir with non-indexed grandparent
>> +# - Check decode/read of file handles after rename of non-indexed merge dir
>> +# - Check decode/read of file handles after rename of non-indexed parent
>> +# - Check decode/read of file handles after rename of non-indexed grandparent
>> +#
>> +# This test requires and enables overlayfs NFS export support and merge
>> +# dir rename support (redirect_dir).
>> +# NFS export support depends on and requires overlayfs index feature.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (C) 2018 CTERA Networks. All Rights Reserved.
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
>> +_require_test_program "open_by_handle"
>> +# We need to require all features together, because nfs_export cannot
>> +# be enabled when index is disabled
>> +_require_scratch_overlay_features index nfs_export redirect_dir
>> +
>> +# All overlay dirs are on scratch partition
>> +lower=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
>> +middle=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER.2
>
> The middle dir doesn't seem to be used in this test. Can I just remove
> it on commit?
>

Ah yes. leftover from copying 052.
Please do.

Thanks,
Amir.
