From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/4] ovl: cast a shadow of incomapt index into the past
Date: Fri, 10 Nov 2017 18:30:30 +0200
Message-ID: <CAOQ4uxiZqUYkW7w0Nf_=VZUrVATcAQ7pgOHQWd6DXtVnHXSWGQ@mail.gmail.com>
References: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
 <1508839381-24750-4-git-send-email-amir73il@gmail.com> <20171110145327.GC16917@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:55538 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752559AbdKJQab (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 11:30:31 -0500
Received: by mail-yw0-f180.google.com with SMTP id t11so8551668ywg.12
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 08:30:31 -0800 (PST)
In-Reply-To: <20171110145327.GC16917@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Nov 10, 2017 at 4:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Oct 24, 2017 at 01:03:00PM +0300, Amir Goldstein wrote:
>> Because overlayfs features were not implemented in the first version
>> of overlayfs merged in v3.18, we cannot enforce old kernel not to mount
>> overlayfs with new backward incompatible features... but we can try to
>> set traps for those who try to perform those mounts.
>>
>> When enabling a backward incompatible feature, we create a
>> non-empty directory nested 2 levels deep under "work" dir, e.g.:
>> workdir/work/incompat_features/incomapt_index.
>>
>> Very old kernels (i.e. v3.18) will fail to remove a non-empty "work"
>> dir and fail the mount. Newer kernels will fail to remove a "work"
>> dir with entries nested 3 levels and fall back to read-only mount.
>>
>> User mounting with old kernel will see a warning like these in dmesg:
>>   overlayfs: cleanup of 'incompat_features/incompat_index' failed (-39)
>>   overlayfs: cleanup of 'work/incompat_features' failed (-39)
>>   overlayfs: cleanup of 'ovl-work/work' failed (-39)
>>   overlayfs: failed to create directory /vdf/ovl-work/work (errno: 17);
>>              mounting read-only
>
> This sounds interesting. I am scratching my head and understand what is
> backward compatibility in this case.
>
> So basically somebody booted a new kernel and enabled a new feature. And
> now downgraded to old kernel and tried to mount again. And old kernel is
> working with metadata of new kernel. To me this if forward compatibility
> and not backward compatibility. (Something like ext3 being able to mount
> ext4).
>
> If yes, failing to mount using old kernel for metadata created by
> newer kernel (incomatible metadata), sounds reasonable to me.
>
>>
>> These warnings should give the hint to the user that:
>> 1. mount failure is caused by backward incompatible features
>
> Should we call this forward incomatible feature? Older kernels can't work
> with metadata of index feature.
>

To avoid confusion let's just call them incomap/rocompat features without
referring to forward/backward, because the terminology is not what matters.

When you are confused go to documentation of ext4/xfs and see what that
means. Its the exact same concept:
- old kernel cannot mount an fs with unknown incomapt features
- old kernel can mount only read-only, as fs with unknown rocompat features

ext4 also has "compat" features, meaning that old kernel can mount them,
but user programs can check if feature exist for whatever reasons.
e2fsck will refuse to modify fs even if it has unknown "compat" features.
xfs_repair will just warn on unknown "compat" features but will modify fs.
I did not see a reason to introduce "compat" features for overlayfs just yet,
because there are no userspace tools/lib that can check them.

Amir.
