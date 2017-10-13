From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix EIO from lookup of non-indexed upper
Date: Fri, 13 Oct 2017 18:20:26 +0300
Message-ID: <CAOQ4uxi_nDnuLOHxUKnRgBYUbrA6L64CWDn8PvLd3Ag2zDKZSg@mail.gmail.com>
References: <1507824184-6244-1-git-send-email-amir73il@gmail.com> <20171013133456.GA26536@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34278 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758516AbdJMPU2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 13 Oct 2017 11:20:28 -0400
In-Reply-To: <20171013133456.GA26536@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "# v4 . 13" <stable@vger.kernel.org>

On Fri, Oct 13, 2017 at 4:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 12, 2017 at 07:03:04PM +0300, Amir Goldstein wrote:
>> Commit fbaf94ee3cd5 ("ovl: don't set origin on broken lower hardlink")
>> attempt to avoid the condition of non-indexed upper inode with lower
>> hardlink as origin. If this condition is found, lookup returns EIO.
>>
>> The protection of commit mentioned above does not cover the case of lower
>> that is not a hardlink when it is copied up (with either index=off/on)
>> and then lower is hardlinked while overlay is offline.
>>
>> Changes to lower layer while overlayfs is offline should not result in
>> unexpected behavior, so a permanent EIO error after creating a link in
>> lower layer should not be considered as correct behavior.
>>
>> This fix replaces EIO error with a warning in cases where upper has
>> origin but no index is found, or index is found that does not match upper
>> inode. In those cases, lookup will not fail and the returned overlay
>> inode will be hashed by upper inode instead of by lower origin inode.
>>
>> Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
>> Cc: <stable@vger.kernel.org> # v4.13
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>
>> Miklos,
>>
>> Following a discussion with Vivek about metacopy feature and the option
>> of setting ORIGIN for non-indexed lower hardlinks on copy up, I came to
>> a conclusion that the current EIO behavior is not quite tollerant to lower
>> changes as one would hope and that it should be fixed in stable kernels.
>>
>> I've implemented an xfstest to test the EIO behavior has been fixed [1].
>>
>> Amir.
>>
>> [1] https://github.com/amir73il/xfstests/commits/overlayfs-devel
>>
>>  fs/overlayfs/inode.c     | 20 ++++++++++++++++----
>>  fs/overlayfs/namei.c     | 22 ++++++++++++----------
>>  fs/overlayfs/overlayfs.h |  3 ++-
>>  3 files changed, 30 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>> index a619addecafc..321511ed8c42 100644
>> --- a/fs/overlayfs/inode.c
>> +++ b/fs/overlayfs/inode.c
>> @@ -598,18 +598,30 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
>>       return true;
>>  }
>>
>> -struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry)
>> +struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
>> +                         struct dentry *index)
>>  {
>>       struct dentry *lowerdentry = ovl_dentry_lower(dentry);
>>       struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
>>       struct inode *inode;
>> +     /* Already indexed or could be indexed on copy up? */
>> +     bool indexed = (index || (ovl_indexdir(dentry->d_sb) && !upperdentry));
>
> Hi Amir,
>
> Looks like current code hashes inodes of lowerdentry even if nlink=1
> (index=on, upperdentry=NULL). IIUC this will never be indexed.
>
> So I am wondering why do we hash inodes of lower when nlink=1. When is it
> used.
>

To understand this need a bit of past and future perspective on index feature.
I am developing index feature for:
1. Not breaking hardlinks
2. NFS export

My first version of index patches indexed all non-dir on copy up as well
as hash all non-dir inodes, with the intention of using index for both goals.

Miklos reduced the scope of index=on to index only lower hardlinks,
because at this point in time, the sole purpose of index in not
breaking hardlinks.
(I have now implemented index=all to cater NFS export).

IIRC, in one version of the patches, Miklos added hashing conditional
to lower nlink > 1 and I voted against it, so he relaxed the condition.

My argument was that we need to minimize the damage in case lower nlink
is changed while overlay is mounted. My feeling was that allowing 2
overlay inode
to co-exist, one from when lower nlink == 1 and another from when
lower nlink > 1
can lead us to very bad places, because concurrent copy up of the 2
lower aliases
is not protected by the same overlay inode lock.

Anyway, AFAICT, we are gaining something (robustness) and not loosing anything
from hashing lower inodes.

Amir.
