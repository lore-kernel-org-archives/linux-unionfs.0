From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 12/14] ovl: Do not expose metacopy only upper dentry
 from d_real()
Date: Fri, 17 Nov 2017 18:07:57 +0200
Message-ID: <CAOQ4uxjQv_yi0G87qEt4bq_LtvNMEELH+P82i_XarWiDjzwNXw@mail.gmail.com>
References: <20171116220335.13448-1-vgoyal@redhat.com> <20171116220335.13448-13-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:37098 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759041AbdKQQH6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 11:07:58 -0500
Received: by mail-yw0-f194.google.com with SMTP id x20so1451957ywg.4
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2017 08:07:58 -0800 (PST)
In-Reply-To: <20171116220335.13448-13-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 17, 2017 at 12:03 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> d_real() can make a upper metacopy dentry/inode visible to the vfs layer.
> This is something new and vfs layer does not know that this inode contains
> only metadata and not data. And this could break things.
>
> So to be safe, do not expose metacopy only dentry/inode to vfs using d_real().
>
> For regular d_real() call (inode == NULL, D_REAL_UPPER not set), if upper
> dentry inode is metacopy only and does not have data, return lower dentry.
>
> If d_real() is called with flag D_REAL_UPPER, return upper dentry only if
> it has data (flag OVL_UPPERDATA is set).
>
> Similiarly, if d_real(inode=X) is called, a warning is emitted if returned
> dentry/inode does not have OVL_UPPERDATA set. This should not happen as
> we never made this metacopy inode visible to vfs so nobody should be calling
> overlayfs back with inode=metacopy_inode.
>
> I scanned the code and I don't think it breaks any of the existing code.
> There are two users of D_REAL_UPPER. may_write_real() and
> update_ovl_inode_times().
>
> may_write_real(), will get an NULL dentry if upper inode is metacopy only
> and it will return -EPERM. Effectively, we are disallowing modifications
> to metacopy only inode from this interface. Though there is opportunity
> to improve it. (Allow chattr on metacopy inodes).
>
> update_ovl_inode_times() gets inode mtime and ctime from real inode. It
> should not be broken for metacopy inode as well for following reasons.
>
>
> - For any metadata operations (setattr, acl etc), overlay always calls
>   ovl_copyattr() and updates ovl inode mtime and ctime. So there is no
>   need to update mtime and ctime int his case. Its already updated.
>
> - For metadata inode, mtime should be same as lower and not change. (data
>   can't be modified on metadata inode without copyup).
>
> - For file writes, ctime and mtime will be updated. But in that case
>   first data will be copied up and this will not be a metadata inode
>   anymore. And furthr call to d_real(D_REAL_UPPER) will return upper
>   inode and new mtime and ctime will be obtainable.
>
> So atime updates should work just fine for metacopy inodes.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
