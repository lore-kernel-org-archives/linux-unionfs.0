From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 07/23] ovl: verify stored origin fh matches lower dir
Date: Fri, 5 Jan 2018 18:26:55 +0200
Message-ID: <CAOQ4uxg-DfS1iWzozN3LBhDJtO=TLkSjuXY+fe5O3Uz0hCGg-A@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-8-git-send-email-amir73il@gmail.com> <20180105160427.GD29480@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:40130 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbeAEQ05 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 11:26:57 -0500
Received: by mail-yb0-f194.google.com with SMTP id s10so2051119ybl.7
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Jan 2018 08:26:56 -0800 (PST)
In-Reply-To: <20180105160427.GD29480@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 5, 2018 at 6:04 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jan 04, 2018 at 06:40:02PM +0200, Amir Goldstein wrote:
>> When the "verify" feature is enabled, a directory inode found in lower
>> layer by name or by redirect_dir is verified against the file handle of
>> the copy up origin that is stored in the upper layer.
>>
>> This introduces a change of behavior for the case of lower layer
>> modification while overlay is offline. A lower directory created or
>> moved offline under an exisitng upper directory, will not be merged with
>> that upper directory.
>>
>> The "verify" feature should not be used after copying layers,
>> because the new lower directory inodes would fail verification.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  Documentation/filesystems/overlayfs.txt | 16 ++++++++++++++++
>>  fs/overlayfs/namei.c                    | 13 +++++++++++++
>>  2 files changed, 29 insertions(+)
>>
>> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
>> index e6a5f4912b6d..00e0595f3d7e 100644
>> --- a/Documentation/filesystems/overlayfs.txt
>> +++ b/Documentation/filesystems/overlayfs.txt
>> @@ -299,6 +299,22 @@ filesystem are not allowed.  If the underlying filesystem is changed,
>>  the behavior of the overlay is undefined, though it will not result in
>>  a crash or deadlock.
>>
>> +When the underlying filesystems supports NFS export, overlay mount can be
>> +made more resilient to offline and online changes of the underlying lower
>> +layer by enabling the "verify" feature.
>> +
>> +On every copy_up, an NFS file handle of the lower inode, along with the
>> +UUID of the lower filesystem, are encoded and stored in an extended
>> +attribute "trusted.overlay.origin" on the upper inode.
>> +
>> +When the "verify" feature is enabled, a lookup of a merged directory, that
>> +found a lower directory at the lookup path or at the path pointed to by
>> +the "trusted.overlay.redirect" extended attribute, will verify that the
>> +found lower directory file handle and lower filesystem UUID match the
>> +origin file handle that was stored at copy_up time.  If a found lower
>> +directory does not match the stored origin, that directory will not be
>> +merged with the upper directory.
>> +
>>  Testsuite
>>  ---------
>>
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index 46a3e31b0225..56deb2785af7 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -734,6 +734,19 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>>                       }
>>               }
>>
>> +             /*
>> +              * When "verify" feature is enabled, do not merge with a lower
>> +              * dir that does not match a stored origin xattr.
>> +              */
>> +             if (upperdentry && !ctr && ovl_verify(dentry->d_sb)) {
>> +                     err = ovl_verify_origin(upperdentry, this, false,
>> +                                             false);
>> +                     if (err) {
>> +                             dput(this);
>> +                             break;
>> +                     }
>> +             }
>> +
>
> So this will verify directory origin only for top level lower dir. Rest
> of the lowers can still be modified offline without this code noticing it?
>

Correct, from patch 6/23:

+       } else if (ofs->config.verify && ofs->config.upperdir && stacklen > 1) {
+               pr_warn("overlayfs: option 'verify=on' cannot verify
redirects from middle layer dirs\n");

Amir.
