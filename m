From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 04/11] ovl: store file handle of lower inode on copy up
Date: Wed, 26 Apr 2017 11:39:37 +0200
Message-ID: <CAJfpegsPYR=nWQxKbLvw1istWu8a-VogBAbt=WdxM+ho-yJa5A@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com> <1493025256-27188-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:32936 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1437416AbdDZJjj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 05:39:39 -0400
Received: by mail-oi0-f51.google.com with SMTP id y11so170031633oie.0
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2017 02:39:38 -0700 (PDT)
In-Reply-To: <1493025256-27188-5-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Mon, Apr 24, 2017 at 11:14 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Sometimes it is interesting to know if an upper file is pure
> upper or a copy up target, and if it is a copy up target, it
> may be interesting to find the copy up origin.
>
> This will be used to preserve lower inode numbers across copy up.
>
> Store the lower inode file handle in upper inode xattr overlay.fh
> on copy up to use it later for these cases.
>
> On failure to encode lower file handle, store an invalid 'null'
> handle, so we can always use the overlay.fh xattr to distignuish
> between a copy up and a pure upper inode.
>
> If lower fs does not support NFS export ops or if not all lower
> layers are on the same fs, don't try to encode a lower file handle
> and use the 'null' handle instead.

One other question regarding this:  do we want  to store the handle of
the next file in the copy up chain or the handle of the original file?

This patch seems to do the "next file" thing.  For directories,
obviously that's what we want, but for files...

Thanks,
Miklos
