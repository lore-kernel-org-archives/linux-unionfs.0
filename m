From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 00/13][V5] overlayfs: Delayed copy up of data
Date: Thu, 26 Oct 2017 10:18:19 +0300
Message-ID: <CAOQ4uxhDkDHAFxhs6mu6HQ+Z1+y8ykvcw5vbXO3H79kGJ6zAaA@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:48325 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbdJZHSV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 03:18:21 -0400
Received: by mail-yw0-f194.google.com with SMTP id q1so2126357ywh.5
        for <linux-unionfs@vger.kernel.org>; Thu, 26 Oct 2017 00:18:20 -0700 (PDT)
In-Reply-To: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi,
>
> Here is the V5 of patches. Following are changes from V4.

Please use git format-patch -v6 next time you post.
It tags all the patch subjects so it is easier to find the former
revision of specific patch.

>
> - Flipped the meaning of bit. Now OVL_METACOPY is called OVL_UPPERDATA and
>   dropped a barrier patch which implemented ordering requirements between
>   oi->flags and oi->__upperdentry.
>
> - Now ovl_d_real() does return upper dentry if upper dentry is metacopy only
>   dentry.

doesn't return upper dentry

But I am still not convinced that metacopy upper inode is not accessed in places
it shouldn't be accessed by vfs, via other APIs.

For example, ovl_permission(), ovl_getattr(), ovl_setattr(), ovl_listxattr(),
ovl_get_acl() will all access metacopy inode and that outcome will be desired.
But you did not provide a complete list of vfs APIs and verify for each
that accessing the metacopy upper via various variants of ovl_dentry_real()
is either not possible (because access requires a rw fd) or is the
desired outcome.

>
> - Added a fix to ovl_lookup() goto statement.

This patch is independent of this series AFAICT your patches don't
depend on it in.
Please post it separately with Fixes tag and CC stable

>
> - Renamed ->metadata_only to ->metacopy
>
> - Replaced BUG_ON() with WARN_ON() in ovl_copy_up_meta_inode_data()
>
> - Added WARN_ON(!OVL_TYPE_ORIGIN(type)) in ovl_getattr()
>
> - Took care of bunch of code organization comments from Amir.
>
> Original Description
> --------------------
> In one of the recent converstions, people mentioned that chown/chmod
> lead to copy up files as well as data. We could optimize it so that
> only metadata is copied up during chown/chmod and data is copied up when
> file is opened for WRITE.
>
> This optimization potentially could be useful with containers and user
> namespaces. In popular scenario, people end up doing chown() on whole
> image directory tree based on container mappings. And this chown copies
> up everything, breaking sharing of page cache between containers.
>
> With these patches, only metadat is copied up during chown() and if file
> is opened for READ, d_real() returns lower dentry/inode. That way,
> different containers can still continue to use page cache. That's the
> use case I have in mind.
>
> Basically, I am relying on storing OVL_XATTR_ORIGIN in upper inode
> during copy up. I use that information to get to lower inode later and
> do data copy up when necessary.
>
> I also store OVL_XATTR_METACOPY in upper inode to mark that only
> metadata has been copied up and data copy up still might be required.
>
> Any feedback is helpful.
>
> Thanks
> Vivek
>
> Vivek Goyal (13):
>   ovl: Put upperdentry if ovl_check_origin() fails
>   ovl: Create origin xattr on copy up for all files
>   ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check
>   ovl: Provide a mount option metacopy=on/off for metadata copyup
>   ovl: During copy up, first copy up metadata and then data
>   ovl: Copy up only metadata during copy up where it makes sense
>   ovl: A new xattr OVL_XATTR_METACOPY for file on upper
>   ovl: Fix ovl_getattr() to get number of blocks from lower
>   ovl: Set OVL_UPPERDATA flag during ovl_lookup()
>   ovl: Return lower dentry if only metadata copy up took place
>   ovl: Introduce read/write barriers around metacopy flag update
>   ovl: Do not export metacopy only upper dentry
>   ovl: Enable metadata only feature
>
>  fs/overlayfs/Kconfig     |   8 ++++
>  fs/overlayfs/copy_up.c   | 116 +++++++++++++++++++++++++++++++++++------------
>  fs/overlayfs/inode.c     |  15 +++++-
>  fs/overlayfs/namei.c     |  38 +++++++++++++++-
>  fs/overlayfs/overlayfs.h |   6 ++-
>  fs/overlayfs/ovl_entry.h |   1 +
>  fs/overlayfs/super.c     |  67 +++++++++++++++++++++++++--
>  fs/overlayfs/util.c      |  54 +++++++++++++++++-----
>  8 files changed, 257 insertions(+), 48 deletions(-)
>
> --
> 2.5.5
>
