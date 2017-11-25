From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay: add a test for multiple redirects to the same
 lower dir
Date: Sat, 25 Nov 2017 05:45:53 +0200
Message-ID: <CAOQ4uxh7iVbKyWd0QoV7MCxDex30qQTm+sRafNbvCxXMOUhQ_Q@mail.gmail.com>
References: <1511447224-2301-1-git-send-email-amir73il@gmail.com> <db0174cd-938d-e365-01ae-03afb9bd3d66@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:41144 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbdKYDpz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 24 Nov 2017 22:45:55 -0500
In-Reply-To: <db0174cd-938d-e365-01ae-03afb9bd3d66@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>

On Fri, Nov 24, 2017 at 9:32 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/11/23 22:27, Amir Goldstein Wrote:
>> Multiple redirects to the same lower dir will falsely return the
>> same st_ino/st_dev for two different upper dirs and will cause 'diff'
>> to falsely report that content of directories is the same when it is not.
>>
>> This is a test for a regression introduced in kernel v4.12 by
>> commit 72b608f08528 ("ovl: constant st_ino/st_dev across copy up"),
>> but also the first xfstest to require the redirect_dir feature that
>> was introduced as an opt-in feature in kernel v4.10.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>
>> Eryu,
>>
>> This test is for a "bug" that has not been acknoledges by Miklos
>> as a kernel bug yet. It may well fall within the jurisdiction of
>> fsck.overlayfs.
>>
>> IMO, cp -a of upper files and dirs qualifies to the statement in
>> Documentation/filesystems/overlayfs.txt:
>> "Offline changes, when the overlay is not mounted, are allowed to either
>> the upper or the lower trees."
>>
> Hi Amir:
>
> I have some persional opinions.
>
> If I understand right, I think we need to change this statement and add
> some limitations.

Maybe it is a good idea to clarify this statement, but that doesn't mean
that overlayfs should ignore an inconsistency when one is detected or
that it shouldn't make an effort to detect an inconsistency.

> I make an analogy with Ext4 filesystem:

I like this analogy, so I will use it to explain why the proposed kernel
fix makes sense.

>
> 1) Creating lower layers and upper dirs in overlayfs before first mount
>    is like mkfs.ext4 to create an image in Ext4fs. Ext4 filesystem can
>    guarantee consistency in this step but overlayfs cannot, so It's better
>    to hint users to check the "overlay image" through fsck.overlay after
>    he finish this "image".
>

One problem with this analogy: there is no mkfs.overlay, so users do
manually craft overlay layers today and no documentation change is
going to stop users from doing that for decades.

Another reason why it is desired to let even unprivileged users
craft layers is because it is a long outstanding goal to allow
unprivileged users to create an fs and mount it in their own
a usrens/mountns. Allowing unprivileged users to mount an fs
is supported only for a whitelist of file systems that are marked
with flag FS_USERNS_MOUNT. Overlayfs does not qualify for
that yet, but it is a much easier goal to qualify overlayfs for userns
mount than it is to qualify ext4 for userns mount and this is
desired for some use cases.


> 2) Change lower layers or upper dirs when overlayfs is offline is like
>    user modify ext4 image through tune2fs/debugfs or even modify it in
>    block device directly. Ext4fs also cannot guarantee everything is right
>    when user modify fs image limitless(should not crash), so fsck.ext4 is
>    necessary after modifing image(except fault injection). From overlayfs's
>    point of view, modify "overlay image" when it's offline is okay, but it
>    should pass fsck.overlay's check before next mount.
>

One problem with this analogy: users do have a way to manually change
overlay layers today and no documentation change is going to stop users
from doing that for decades. Because it is easy to change layers and often
does not ever require root privileges, it is not really a valid analogy to
debugfs. A user modifying ext4 with debugfs is either very smart, very stupid
very malicious or any combination of the above, but unlike modifying layers,
it cannot be an innocent user making an innocent mistake.

Therefore, it is very sensible for the kernel to check for inconsistencies.
Staying with the ext4 analogy: ext4 doesn't require that you run
e2fsck before mount, that was the situation 2-3 decades ago. Instead
ext4 will try to detect inconsistencies at runtime and return an error
(-EFSCORRUPTED) to user with a strong hint for user to run e2fsck.
Ext4 will also optionally panic or mount ro in such case.
Xfs will forcefully shut itself down in such case forcing repair.

> I guess most general users don't know which one the redirect xattr points to
> or even what the redirect xattr is, they maybe just want to copy whole
> directory in upperdir when they call "cp -a", so I think it can handled by
> fsck.overlay.
>
> Do I understand this correctly, any thoughts ?
>

I think you do understand this correctly and I think fsck.overlay is a very
much needed tool as overlayfs on-disk format is becoming less naiive,
but the only way to *make* users run fsck.overlay is for the kernel to hint
them or force them to do so.

>
>> So unless Miklos objects to ever fixing this "bug"?
>> I suggest that we include the failing test until kernel is fixed.
>>
>> Incidently, I already have patches for 'verify' feature [1], which
>> I intend to post after the merge window closes.
>> With 'verify' feature enabled this test passes.
>>
>>
>> [1] https://github.com/amir73il/linux/commits/ovl-index-all

I may have made it sound like I have a kernel fix which is an
alternative to running fsck.overlay, but this is very much not the case.
The test "passes" because kernel returns an error instead of
allowing diff to mistake two different dirs as the same.

[ Before the kernel fix:]
root@kvm-xfstests:~# diff -q /mnt/scratch/redirect1 /mnt/scratch/redirect2
[ Silence is not golden]

[ After the kernel fix:]
root@kvm-xfstests:~# diff -q /mnt/scratch/redirect1 /mnt/scratch/redirect2
[  226.143718] overlayfs: failed to verify origin
(ovl-upper/redirect2, ino=16777539, err=-116)
[  226.146100] overlayfs: suspected multiply redirected dir found
(ovl-lower/origin, upper=ovl-upper/redirect2,
index=index/00fb21008199b53994a1f94164ba995bab052f5e0a840000000000000030e947a6).
diff: /mnt/scratch/redirect2: Input/output error

If there was an official fsck.overlay tool, this warning is where kernel would
tell user: "...please run fsck.overlay"

Cheers,
Amir.
