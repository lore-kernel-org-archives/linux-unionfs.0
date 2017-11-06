From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 8/8] ovl: ovl_iterate_real() for all pure upper/lower
 in non-samefs case
Date: Mon, 6 Nov 2017 13:45:56 +0200
Message-ID: <CAOQ4uxiaQM+VKLmg=+SHTf1Li_r=jqTU=4BLA6Q6RGeDuE_ZCQ@mail.gmail.com>
References: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
 <1509655091-13630-9-git-send-email-amir73il@gmail.com> <CAJfpegt8d6iqWfmwdQtjaag47JkvebKrNgn0SvWSegVJ5VZPyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:45569 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752164AbdKFLp5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Nov 2017 06:45:57 -0500
Received: by mail-yw0-f182.google.com with SMTP id j4so7535836ywb.2
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Nov 2017 03:45:57 -0800 (PST)
In-Reply-To: <CAJfpegt8d6iqWfmwdQtjaag47JkvebKrNgn0SvWSegVJ5VZPyA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Nov 6, 2017 at 11:35 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Nov 2, 2017 at 9:38 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> For non-samefs case, all directory entries are "impure" because the
>> st_ino value returned from stat(2) is not the st_ino value of the
>> real inode.
>>
>> In order to provide the same d_ino values for the directory type entries,
>> we never iterate the real dir directly in non-samefs case.
>>
>> ovl_fill_real() has been modified to return the overlay inode number
>> as d_ino of the "." and ".." entries.
>>
>> Build the impure dir cache for non-samefs case even if there is no
>> "impure" xattr on dir, but if real dir has nlink > 2 or nlink == 1,
>> which indicates that is has subdirs.
>>
>> Update non-merge dir cache version on every change in subdir entry
>> and reset the dir cache after copy up when directory becomes !is_real.
>>
>
> I don't really like this.  Non-samefs d_ino will always be hacky,
> whether consistent with st_ino or not (it loses the uniqueness
> property of d_ino, that is guaranteed in a normal filesystem).
>
> Spending possibly large amounts of memory and CPU cycles to achieve
> consistency is dubious.   Especially since nobody seems to be
> complaining about it.
>
> So, I'd just drop 6/8 and 8/8.
>
> And I'm still hoping we can get some infrastructure for partitioning
> the ino space (i.e. filesystem can report that it will only use N bits
> from the available 64).  This would allow properly solving the
> non-samefs case without adding hacks.
>

Oh! there is a ridiculously simple way for some file systems to know
that they are using 32 bit inodes.
We already call ovl_can_decode_fh() for upper and all lower layers.
All we need to do is actually encode the layer directory and check
returned fh_type.

If fh_type is FILEID_INO32_GEN, bingo!
That turns out to be true to all file systems that use the default
implementation of .encode_fh, including the ext* family, squashfs
and more.

XFS with mount option inode32 will also encode fh_type
FILEID_INO32_GEN, unless file system size is very large, so that
gives users a way to easily opt-in for constant st_ino when xfs
is involved.

I'll see if I can sketch a patch.

Amir.
