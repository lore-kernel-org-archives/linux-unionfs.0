From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Fri, 7 Apr 2017 15:03:01 +0200
Message-ID: <CAJfpegts8UjOXYLoUyn9m-tLK7fXyFH=mmm3J3vAZ4U_Xm9=XQ@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
 <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
 <CAJfpegugsV8Lzwwiz5BncAnTVc2tPdYcG7eGrVhChcfc6CtBfw@mail.gmail.com>
 <CAOQ4uxispHXxq8qO9GHEyQm9nLWUiG9CfMzP59hffYM5OPB4DA@mail.gmail.com>
 <CAJfpeguDJrtJn1bkM03pxH0eo=K81dFYm7OP3QSpBCj6aWZZhA@mail.gmail.com>
 <CAJfpegupcgWcP3yC=8Lpe-=m=oq_7f2OR9f14+p+ug+67gWBPA@mail.gmail.com> <CAOQ4uxjbfBOvHMwe0xRdXox8Uy3XwdaxJmQpiYDVBT8854z4+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33206 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754710AbdDGNDD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 09:03:03 -0400
Received: by mail-oi0-f49.google.com with SMTP id b187so85044625oif.0
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 06:03:02 -0700 (PDT)
In-Reply-To: <CAOQ4uxjbfBOvHMwe0xRdXox8Uy3XwdaxJmQpiYDVBT8854z4+w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Apr 7, 2017 at 12:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> Come to think about it, NFS export of regular file don't need to
> follow renames at all:
> - The handle for a regular file is always the handle for the real
> lower or upper inode
> - To decode a handle, create an O_TMPFILE style overlay dentry, which
> is not linked
>   to any path in overlay, but has the _upperdentry/lowerstack setup

I don't think nfs will allow such a scheme.  NFS3 server is stateless,
which means there's no open/close in the protocol.   Hence we can't
copy-up on open(O_WR*) and return a different file handle for writing.
If client looks up a file currently on lower and we return file handle
based on lower file, then we must be able to decode that handle after
the file has been copied up and even after rename.  And this must work
reliably even if the overlay dentry is no longer in the dcache.

So there's no option, other than to have a reverse mapping somewhere.

One more idea:  do it out-of-band (e.g. under workdir) but do it as a
plain directory tree shadowing the lower trees that contains the
forward redirect information.  It spares us the implementation of the
database, since the filesystem does it for us.  Yes, it can get out of
sync with the overlay, but so can any mapping in-band or out-of-band.

Thanks,
Miklos
