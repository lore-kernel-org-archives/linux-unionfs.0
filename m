From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix nested overlayfs mount
Date: Wed, 16 Nov 2016 10:28:17 +0100
Message-ID: <CAJfpegsBgNa0AYibyDwq-B5R5a7R6y6zMvmwzzBJXDNee-tv_A@mail.gmail.com>
References: <1479288159-20396-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33631 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752360AbcKPJ2S (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Nov 2016 04:28:18 -0500
Received: by mail-oi0-f42.google.com with SMTP id 128so54305536oih.0
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Nov 2016 01:28:18 -0800 (PST)
In-Reply-To: <1479288159-20396-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 16, 2016 at 10:22 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> The introduction of overlayfs features broke nested mounting
> of overlayfs as lowerdir of another overlayfs mount.
>
> When the upper overlayfs checks overlayfs features xattr
> on the underlying overlayfs mount, it gets -EPERM and aborts.
>
> Fix this by returning -ENODATA instead of -EPERM from
> ovl_own_xattr_get().  This behavior is consistent with the
> behavior of ovl_listxattr(), which filters out the private
> overlayfs xattrs.

Yes, it makes sense regardless of the features xattr.

Applied.

Thanks,
Miklos
