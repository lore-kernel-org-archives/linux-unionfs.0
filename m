From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: take lower dir inode mutex outside upper sb_writers lock
Date: Wed, 22 Nov 2017 10:34:35 +0100
Message-ID: <CAJfpegvFutFyP_o4LPxopCGe6LD0fs-Y4mAsUjnPO+f9Y3Sgow@mail.gmail.com>
References: <1510312687-9680-1-git-send-email-amir73il@gmail.com> <CAOQ4uxh-=vEQaW96_ZR1GcnOpbjy==k_zVsGy_Bt9kcdrdD-1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39643 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbdKVJeg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Nov 2017 04:34:36 -0500
Received: by mail-wm0-f67.google.com with SMTP id x63so8711608wmf.4
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Nov 2017 01:34:36 -0800 (PST)
In-Reply-To: <CAOQ4uxh-=vEQaW96_ZR1GcnOpbjy==k_zVsGy_Bt9kcdrdD-1w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Nov 22, 2017 at 6:46 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Nov 10, 2017 at 1:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> The functions ovl_lower_positive() and ovl_check_empty_dir() both take
>> inode mutex on the real lower dir under ovl_want_write() which takes
>> the upper_mnt sb_writers lock.
>>
>> While this is not a clear locking order or layering violation, it creates
>> an undesired lock dependency between two unrelated layers for no good
>> reason.
>>
>> This lock dependency materializes to a false(?) positive lockdep warning
>> when calling rmdir() on a nested overlayfs, where both nested and
>> underlying overlayfs both use the same fs type as upper layer.
>>
>> rmdir() on the nested overlayfs creates the lock chain:
>>   sb_writers of upper_mnt (e.g. tmpfs) in ovl_do_remove()
>>   ovl_i_mutex_dir_key[] of lower overlay dir in ovl_lower_positive()
>>
>> rmdir() on the underlying overlayfs creates the lock chain in
>> reverse order:
>>   ovl_i_mutex_dir_key[] of lower overlay dir in vfs_rmdir()
>>   sb_writers of nested upper_mnt (e.g. tmpfs) in ovl_do_remove()
>>
>> To rid of the unneeded locking dependency, move both ovl_lower_positive()
>> and ovl_check_empty_dir() to before ovl_want_write() in rmdir() and
>> rename() implementation.
>>
>> This change spreads the pieces of ovl_check_empty_and_clear() directly
>> inside the rmdir()/rename() implementations so the helper is no longer
>> needed and removed.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>
>> Miklos,
>>
>> Please consider this patch for v4.15.
>>
>> I bumped into the lockdep warning while testing file handles on nested
>> overlay and had to work around it by using different type of fs for the
>> lower-upper(xfs) and the upper-upper(tmpfs).
>>
>> The workaround doesn't suffice if there is another test mounting an overlay
>> with the same fs type used for upper-upper (e.g. unionmount-testsuite)
>> at the same machine boot, which happens on my automated testing.
>>
>> So fixing this removes a false positive from my automated testing.
>>
>
> Miklos,
>
> Any objections to this change?
>
> Thanks,
> Amir.

No objection, just need time to review.  Will do.

Thanks,
Miklos
