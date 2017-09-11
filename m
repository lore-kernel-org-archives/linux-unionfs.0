From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: v4.13 overlay fs: sometimes fails when creating or moving files
Date: Mon, 11 Sep 2017 15:19:44 +0300
Message-ID: <CAOQ4uxjHsukvK77OpJWA=noYMW4AVVWdVyHEYL8KGRGFV1H1Kw@mail.gmail.com>
References: <20170908143704.3c74d20f@localdomain> <CAOQ4uxjC+ONu9nj-BJ8XwuWU0ofq5ySd-YRmXdikQjPAXj3WuA@mail.gmail.com>
 <CACTE=goi1H-rEKA4_2iZTsaW9k9k+kMCgnzWcZJBt4+-M93pmg@mail.gmail.com>
 <CAOQ4uxhKy1uWarTyAQqXmvk5nPsLYEsb1zgfSaSv-mcxby0+6g@mail.gmail.com>
 <CACTE=gp1JRmVtY_SR4YRx5CsPPFrrPsgbxq=JYH_VYRq8rQZsw@mail.gmail.com> <CAOQ4uxjEMJUGesER22p_wE2THejhNCobdcyOEZb5YffR9uKD2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:37569 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbdIKMTq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Sep 2017 08:19:46 -0400
Received: by mail-yw0-f196.google.com with SMTP id v137so2411740ywg.4
        for <linux-unionfs@vger.kernel.org>; Mon, 11 Sep 2017 05:19:45 -0700 (PDT)
In-Reply-To: <CAOQ4uxjEMJUGesER22p_wE2THejhNCobdcyOEZb5YffR9uKD2w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Sun, Sep 10, 2017 at 10:21 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sun, Sep 10, 2017 at 5:10 PM, Jordi Pujol <jordipujolp@gmail.com> wrote:
>> This error disappears after installing 4.13.1, but other problems have
>> arised when unmounting some kind of filesystems.
>>
>
> That is strage, because I see nothing fs related in v4.13..v4.13.1
> which umount problems are you referring to?
>
>> Maybe it was not an overlayfs error.
>>
>
> Ehm.. maybe, but considering the changes in overlayfs for v4.13
> I cannot rule out that we missed some subtle race with overlay inode
> cache that would change behavior.
>
> Also, I did not test much with lower fs that does not support file handles,
> and that is the case in your setup, so there might be a bug hiding there.
>

Sure enough, testing with squashfs as lower layer found a bug very
much like you described.
Bug is easy to reproduce by trying to hardlink a lower file.
Harder to reproduce with rename, because it requires that dentry
of a copied up file is evicted from cache after rename, but that overlay
inode is still in cache.

You are welcome to try this fix if problem is reproducing for you
or verify the simpler hardlink regression.

Thanks,
Amir.

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -581,8 +581,7 @@ static bool ovl_verify_inode(struct inode *inode,
struct dentry *lowerdentry,
 {
        struct inode *lowerinode = lowerdentry ? d_inode(lowerdentry) : NULL;

-       /* Lower (origin) inode must match, even if NULL */
-       if (ovl_inode_lower(inode) != lowerinode)
+       if (lowerdentry && ovl_inode_lower(inode) != lowerinode)
                return false;
