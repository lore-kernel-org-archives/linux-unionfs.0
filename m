From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 2/5] ovl: relax same fs constrain for constant st_ino
Date: Thu, 1 Jun 2017 16:32:45 +0300
Message-ID: <CAOQ4uxh7DT+m51jyRn_0v-38c8yFVafra_P=n9KWHfqNr913dw@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <1496307779-2766-3-git-send-email-amir73il@gmail.com> <1507928.BJF3V1jpy0@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32905 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbdFANcq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 09:32:46 -0400
Received: by mail-oi0-f68.google.com with SMTP id h4so6735419oib.0
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Jun 2017 06:32:46 -0700 (PDT)
In-Reply-To: <1507928.BJF3V1jpy0@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jun 1, 2017 at 3:30 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Thursday, June 1, 2017 2:32:56 PM IST Amir Goldstein wrote:
>> For the case of all layers not on the same fs, use the copy up
>> origin st_ino/st_dev for non-dir, if we know it.
>>
...
> Hi Amir,
>
> The following question is not directly related to your patch.
>
> With this patch applied, we have the following code snippet inside
> ovl_getattr(),
>
>        if (!is_dir || samefs) {
>                 if (OVL_TYPE_ORIGIN(type)) {
>                         struct kstat lowerstat;
>                         u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
>
>                         ovl_path_lower(dentry, &realpath);
>                         err = vfs_getattr(&realpath, &lowerstat,
>                                           lowermask, flags);
>                         if (err)
>                                 goto out;
>
> When invoking vfs_getattr() on a non-dir file, the code assumes that the
> copy-up origin inode always exists in lowerdir.

Code does not assume that.
Code verifies that the copy up origin stored in xattr overlay.origin
is still valid
and not stale in ovl_check_origin().

> Are we assuming that after an
> overlayfs filesystem has been unmounted, the lower filesystem should never be
> manipulated (e.g. deleting the file which was the copy-up origin)? If the
> copy-up origin file gets deleted, On a later mount of the overlayfs
> filesystem, calls to stat(2) for the corresponding upperdir file will fail
> because of vfs_getattr() returning an error code.
>

The case you are describing can happen. It will cause ovl_check_origin()
to NOT follow the stored copy up origin and in the snippet above
OVL_TYPE_ORIGIN(type) will be false.

Furthermore, even if copy up origin was not deleted, but the lower
layer has been copied (cp -a) or the lower filesystem does not support
NFS export, or lower filesystem does not have a valid UUID (e.g. tmpfs).
All those cases will end up with OVL_TYPE_ORIGIN(type) being false
and then inode numbers will not remain constant across a mount cycle
(or drop caches).

Amir.
