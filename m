From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v9 01/15] ovl: Do not look for OVL_XATTR_NLINK if index is
 not there
Date: Wed, 29 Nov 2017 19:04:28 +0200
Message-ID: <CAOQ4uxi6UY_hdPGQSaREUYzC1tUo-XBDjwi0bos3VPdTcjZi0A@mail.gmail.com>
References: <20171129155448.32721-1-vgoyal@redhat.com> <20171129155448.32721-2-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:44792 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdK2RE3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Nov 2017 12:04:29 -0500
Received: by mail-yw0-f195.google.com with SMTP id m129so1603358ywb.11
        for <linux-unionfs@vger.kernel.org>; Wed, 29 Nov 2017 09:04:29 -0800 (PST)
In-Reply-To: <20171129155448.32721-2-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Nov 29, 2017 at 5:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Soon, we will be creating OVL_TYPE_ORIGIN entries even for hardlinked
> files with index=off. That means, it is possible that there is no
> index and hence no OVL_XATTR_NLINK set on upperdentry but lowerdentry
> is still there. In that case current implementation gets -ENODATA
> from vfs_getxattr)() and it warns and returns fallback. I can get
> following warning.
>
> "overlayfs: failed to get index nlink ....."
>
> Pass in index instead of upperdentry in ovl_get_nlink(). That way, if
> index is not there, we know that OVL_XATTR_NLINK should not be
> present and just return fallback.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
