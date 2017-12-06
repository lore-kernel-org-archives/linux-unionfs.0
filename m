From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [ANNOUNCE] unionmount-testsuite: Amir's master branch updated
Date: Wed, 6 Dec 2017 21:14:11 +0200
Message-ID: <CAOQ4uxhTWV=ZwDK2DQS2KYux7fufoz0sc7Sv+9dz59gnM1u8+w@mail.gmail.com>
References: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
 <20171206181700.GA7967@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:36223 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbdLFTOM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 14:14:12 -0500
In-Reply-To: <20171206181700.GA7967@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, fstests <fstests@vger.kernel.org>, Chandan Rajendra <chandan@linux.vnet.ibm.com>

On Wed, Dec 6, 2017 at 8:17 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Dec 05, 2017 at 10:20:25PM +0200, Amir Goldstein wrote:
>> Hi All,
>>
>> The master branch on my unionmount-testsuite tree [1] has been updated.
>>
>> The head of the master branch is commit:
>> 6d04664 Add a test for rename over empty union dir
>>
>> This small update contains:
>> - A few new simple dir rename and dir remove tests
>> - A fix for running on kernel <= v4.9 with no redirect_dir support
>> - A new setup option --squashfs to setup lower as read-only squashfs
>>
>
> Hi Amir,
>
> It would be nice to also update README file and explain different options.

Yes, that would be nice... will get to it some day if someone doesn't
beat me to it.

>
> Also, how to test with different mount options enabled/disable (index,
> redirect etc).
>

A preview for README:
Basically, the testsuite tests for correctness, so if correctness requires
enabling a feature, then testsuite will fail without the feature, but there are
some historical exceptions:
- testsuite predates redirect_dir, so I let the testsuite auto detect
redirect_dir
  and kept the "expect EXDEV" logic for redirect_dir disabled
- until quite recently st_ino was not constant on copy up in most cases,
  so the verification of constant ino was added as an opt-in feature
with --verify


>> With index enabled, there are no known failures.
>> With index disabled this test fails on non-constant st_ino for lower hardlink
>> copy up:
>>   run --ov=1 --samefs --verify rename-mass-5

Thus, this test fails because with index disabled, hardlink is broken on copy up
and does not preserve st_ino.

>
> I ran "./run --ov" and that seems to fail with 4.15.0-rc2 kernel.
>
> # ./run --ov
> ***
> *** ./run --ov --ts=0 open-plain
> ***
> TEST open-plain.py:10: Open O_RDONLY
> /mnt/a/foo100: File on unexpected layer
>

Yes... sorry about that.
I had this patch that adapts layer checks to anonymous bdev for lower layer
for a while and was holding on to it until anonymous bdev was merged.
Finally, anonymous bdev was merged to 4.15.0-rc1, but forgot to
include the patch
in the update, so here goes:

The new head of the master branch is:

commit 15670582f2eca275f4ae0811f7b795e5b083de33
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Fri Jun 23 16:08:49 2017 +0300

    Update layer check for non samefs --verify case

    With samefs setup, files are on overlay st_dev if st_ino is constant
    on copy up and on real st_dev if st_ino is not constant.
    --verify verifies constant st_ino, so it implies overlay st_dev check.
    Without --verify, we allow for both options.

    With non samefs setup, files are on pseudo or upper st_dev if st_ino
    is constant on copy up and on lower or upper st_dev otherwise.
    --verify verifies constant st_ino, so it implies pseudo st_dev check.
    Without --verify we allow for both options.

    Signed-off-by: Amir Goldstein <amir73il@gmail.com>

As far as I tested, this works well on 4.15.0-rc1, v4.14, v4.13, v4.12
without --verify and with or without --samefs.
--verify [--samefs] passes on 4.15.0-rc1 and fails on older kernels
depending on the type of constant st_ino support in those kernels/features.

Please note that --verify checks for constant st_ino, but does NOT check for
constant st_dev, but it does have some convoluted sanity checks about st_dev,
which try to comply with a wide range of kernels, which is what this
last patch is
all about.

Thanks to Chandan for his help reviewing and testing this patch.

Amir.
