From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 00/23] Overlayfs consistency verification with full index
Date: Thu, 11 Jan 2018 18:55:15 +0200
Message-ID: <CAOQ4uxhd+feiS-7fyk92wFeOYHrJLzo2NAjK-LpH3Ph4jEmrqg@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:38942 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933231AbeAKQzR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Jan 2018 11:55:17 -0500
Received: by mail-yb0-f179.google.com with SMTP id 65so1372161ybz.6
        for <linux-unionfs@vger.kernel.org>; Thu, 11 Jan 2018 08:55:16 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Thu, Jan 4, 2018 at 6:39 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> This is the 2nd revision of the prep patch series for NFS export.
> I am posing the prep patches only to overlayfs list and will post
> NFS export implementation to fsdevel.
>

Miklos,

3rd revision of prep patches after addressing V2 comments is
available at [1].

Changes since v2:
- Rename mount/config option from "verify" to "nfs_export"
- Rename dir index entries xattr from ".origin" to ".upper"
- Re-factor ovl_{get|set|verify}_origin() helpers
- Abandon ovl_dentry_is_renamed() test for lower st_ino
- Document overhead on mount with full index
- Document change of behavior when verifying lower origin

After you are done with review of NFS export patches
and I will post V3 of prep patches to list.

> In the 1st revision the mount option 'index=all' was used to request
> a full index. This revision re-brands the feature as 'verify=on',
> including a config/module option and documentation that explains the
> benefits of full index (i.e. avoid multiple redirect).
>

In V3, as agreed, the feature name is "nfs_export". There are 2 helpers
called ovl_index_all() and ovl_index_lower() both return the value of
ofs->coinfig.nfs_export, each used in relevant code.

> The prep series goes on a bit beyond implementation of 'verify=on'.
> Patches 17-23 create the whiteout index entries and make some more
> changes that are prerequisites for NFS export implementation.
>

Patches 17-23 as well as NFS export patches have been rebased and
tested. They are mostly unmodified since V2. The complete work is
availabe at [2].

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-index-all-v3
[2] https://github.com/amir73il/linux/commits/ovl-nfs-export
