From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 5/7] overlay: test concurrent copy up of lower hardlinks
Date: Tue, 11 Jul 2017 23:23:50 +0300
Message-ID: <CAOQ4uxjYVevw=bTsONHT=FHMkoapqOcmwL+nj4R6Y3T6Dhmneg@mail.gmail.com>
References: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
 <1499168434-23859-6-git-send-email-amir73il@gmail.com> <20170705095902.GR23360@eguan.usersys.redhat.com>
 <CAOQ4uxjLCGZ3hHfkZzgZiHctC1x6s_EF7J1g0-zjXYCOzqoHwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:36653 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932671AbdGKUXv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 16:23:51 -0400
In-Reply-To: <CAOQ4uxjLCGZ3hHfkZzgZiHctC1x6s_EF7J1g0-zjXYCOzqoHwQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Jul 5, 2017 at 1:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jul 5, 2017 at 12:59 PM, Eryu Guan <eguan@redhat.com> wrote:
>> On Tue, Jul 04, 2017 at 02:40:32PM +0300, Amir Goldstein wrote:
>>> Two tasks make a modification concurrently on two hardlinks of a large
>>> lower inode.  The copy up should be triggered by one of the tasks and the
>>> other should be waiting for copy up to complete.  Both copy up targets
>>> should end up being upper hardlinks and both metadata changes should be
>>> visible in both hardlinks.
>>>
>>> With kernel <= v4.12, hardlinks are broken on copy up, meaning that copy up
>>
>> So this will be fixed in 4.13-rc1 kernel?
>
> It is fixed on current overlayfs-next branch. Yes.
>

Eryu,

I realize that my answer was not accurate.
These tests do pass with current overlayfs-next branch, but
only with non default kernel config CONFIG_OVERLAY_FS_INDEX=y.

This may be the right way to test, meaning that default kernel
config reports failed tests related to hardlinks which are really broken
on copy up with default kernel config.

Another way to go at it is having these tests
"_require_fs_module_param index" (CONFIG_OVERLAY_FS_INDEX
sets the default of this parameter) and then opt-in to indexing in the test
using the index=on mount option.

This way, those test will notrun on old kernels and pass
on new kernels regardless of the kernel config option.
Then they will be testing that "hardlinks are not broken IF
admin opts-in for indexing".

I wonder which of the test methodologies you prefer.
If you like the second one better I can send a patch to make those
tests depend on and opt-in for indexing.

Thanks,
Amir.
