From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [fsck.overlay RFC PATCH] overlay: add fsck utility
Date: Mon, 20 Nov 2017 09:29:39 +0200
Message-ID: <CAOQ4uxgja0e6qzuzG4gpaFr-Y0-9_GvtS_5NmUKG9XaKyicawQ@mail.gmail.com>
References: <20171117054919.712-1-yi.zhang@huawei.com> <CAOQ4uxgCN-ZdLsZQmYYW-PyJLB4WWsr9A8gqOtcSC6S9Uj8qZA@mail.gmail.com>
 <0932944e-bbb7-22c6-9b75-19c42f8c7e41@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:42697 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdKTH3k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Nov 2017 02:29:40 -0500
In-Reply-To: <0932944e-bbb7-22c6-9b75-19c42f8c7e41@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Mon, Nov 20, 2017 at 8:56 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/11/18 1:13, Amir Goldstein Wrote:
[...]
>
>>>
>>> This patch can am to an empty git repository. I have already do basic
>>> test list in 'test' directory. Please do a review give some suggestions.
>>> Thanks a lot.
>>
>> Please consider, instead of writing overlay tests in new repo,
>> to write the tests for xfstests and hook overlay.fsck to _check_test_fs/
>> _check_scratch_fs.
>> See for example very basic index sanity checks I implemented here:
>> https://github.com/amir73il/xfstests/commit/dac4da479e3e85be8f7beec54f384c0a832f74bd
>>
>
> I found that e2fsprogs put tests in the e2fsprogs repository, so I write it
> and put in the same place. Now I notice that all xfs test cases put together
> in xfstests, so It's also a good choice, not sure which one is better. How
> about Eryu's opinion ?
>

Looks. It's not a terrible idea to have some amount of duplication with tests
and it's fine you with to keep some independent test within the progs repositiry
as a "self test". But you will benefit a lot more testers on more machines and
configurations if you merge all the interesting overlay tests to "fstests" repo,
which a lot more people are running.
And yes, there are quite a lot of tests in xfstest to verify correctness of
xfs_repair. Self testing the main fs sanity check program is a good idea.


>> It may be useful, if Eryu agrees, to merge the "incubator" version of
>> fsck.overlayfs
>> into xfstests as a helper program until it starts getting packaged and
>> distributed.
>> Please consider this option.
>>
>
> Can we applay for a repository in git.kernel.org like xfsprogs-dev and e2fsprogs ?

"Kernel.org accounts are not given away very often, usually you need
to be making some
reasonable amount of contributions to the Linux kernel and have a good
reason for wanting
/ needing an account"

It doesn't hurt to ask, but I suspect an incubation period for
fsck.overlay in another location
before it gets enough traction might be a good idea.
You may ask Miklos to maintain overlayfs-progs on kernel.org getting
patches from you,
but I guess this was not your intention.

[...]

>>> +Redirect directories
>>> +--------------------
>>> +
>>> +An redirect directory is a directory with "trusted.overlay.redirect" xattr
>>> +valued to the path of the original location from the root of the overlay. It
>>> +is only used when renaming a directory and "redirect dir" feature is enabled.
>>> +If an redirect directory is found, the following must be met:
>>> +
>>> +1) The directory store in redirect xattr should exist in one of lower layers.
>>> +2) The origin directory should be redirected only once in one layer, which mean
>>> +   there is only one redirect xattr point to this origin directory in the
>>> +   specified layer.
>>> +3) A whiteout or an opaque directory with the same name to origin should exist
>>> +   in the same directory as the redirect directory.
>> another redirected upper dir can also be covering the redirect lower target
>>
> Do you mean the following case: upper's dir_rd cover lower1's redirect dir_rd ?
>
> Upper:                    dir_rd(redurected,opaque)   dir2(whiteout)
> Lower1:   dir(whiteout)   dir_rd(redurected)          dir2
> Lower0:   dir
>

That's not what I meant. What I meant is:

Upper: A (whiteout), B (redirect=A), C (redirect=B)
Lower: A (dir),          B (dir)

The redirect target of upper C (B) is not a whiteout in upper, nor an
opaque dir.
It is a redirected dir (whose own target is covered by a whitetout A).
The description in 3) doesn't cover that case. Didn't check how the program
handles this case.

Amir.
