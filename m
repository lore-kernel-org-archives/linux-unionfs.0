From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 7/7] overlay: test dropping nlink below zero
Date: Wed, 5 Jul 2017 14:17:41 +0300
Message-ID: <CAOQ4uxgG4x-ZJiewnAwJQiSg9kGYFKz+zfT4seSfy_eMf3RovA@mail.gmail.com>
References: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
 <1499168434-23859-8-git-send-email-amir73il@gmail.com> <20170705100936.GS23360@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34129 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdGELRn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2017 07:17:43 -0400
In-Reply-To: <20170705100936.GS23360@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Jul 5, 2017 at 1:09 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Jul 04, 2017 at 02:40:34PM +0300, Amir Goldstein wrote:
>> nlink of overlay inode could be dropped indefinety by adding
>> un-accounted lower hardlinks underneath a mounted overlay and
>> trying to remove them.
>
> Sorry, I didn't quite follow the hardlink patches, could you please
> describe what is "accounted/un-accounted" hardlinks and the expected
> behavior in commit log? And what does "indefinety" mean? I couldn't find
> it in dictionary.
>

Try the typos dictionary ;) I meant indefinitely

I will try to explain better in change log, but here is the full story:

The simplest way to understand this test is this:
Imagine that you have a tool (e.g. xfs_db) with which
you can add hardlinks, without changing the value of nlink
stored on-disk for the inode. This is exactly what this test does when
it adds lower hardlinks underneath a mounted overlay.

Overlayfs assumes that the lower layer files are not modified
underneath it and if they do, the documentation says:
"Changes to the underlying filesystems while part of a mounted overlay
filesystem are not allowed.  If the underlying filesystem is changed,
the behavior of the overlay is undefined, though it will not result in
a crash or deadlock."

As far as I know, this test cannot crash the kernel, but it does trigger
the WARN_ON in drop_link() when nlink drops below zero, so it's not
nice behavior and could possibly results in worse outcomes.



>> +
>> +# Create lower hardlink
>> +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
>> +mkdir -p $lowerdir
>> +touch $lowerdir/0
>> +ln $lowerdir/0 $lowerdir/1
>> +
>> +_scratch_mount
>> +
>> +# Copy up lower hardlink - nlink should be 2

At this time overlay records the initial lower nlink
and assumes it is not going to change.

>> +touch $SCRATCH_MNT/0
>> +
>> +# Add lower hardlinks while overlay is mounted
>
> Why "while overlay is mounted" is needed?

Now overlay *knows* about 2 hardlinks, but we
actually have 4 hardlinks.

>
>> +ln $lowerdir/0 $lowerdir/2
>> +ln $lowerdir/0 $lowerdir/3
>> +
>> +# Unlink un-accounted lowers to drive nlink to 0
>> +rm $SCRATCH_MNT/2
>> +rm $SCRATCH_MNT/3
>
> drive nlink of which file to 0? Sorry, I'm a bit lost on overlay
> hardlink behaviors..

This is new and confusing.
The nlink of the union overlay file is driven to zero, because
it started with nlink 2 (which was copied up from lower) and
then 2 (unaccounted) hardlinks where unlinked dropping nlink
by 2 without ever adding 2.

>
>> +
>> +# Check for getting ENOENT for trying to link !I_LINKABLE with nlink 0
>> +ln $SCRATCH_MNT/0 $SCRATCH_MNT/4
>
> Shouldn't we expect an error message from this ln, if "check for getting
> ENOEND"?

The error is expected if overlay is fooled by this maneuver, but we
detect this use case and fix nlink to > 0 when it is about to drop to zero
because of wrong accounting.

> BTW, this test passed on 4.12-rc7 kernel, I'm not sure if
> that's expected result.
>

Yes, it is expected because in 4.12 hardilnks are always broken on copy up
so they are each of the new lower hardlinks is copied up to a new file
with nlink 1,
so there is no "union nlink accounting" in v4.12 at all and there is
nothing to fool.
