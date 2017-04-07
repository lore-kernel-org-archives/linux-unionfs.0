From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Fri, 7 Apr 2017 11:32:59 +0200
Message-ID: <CAJfpeguDJrtJn1bkM03pxH0eo=K81dFYm7OP3QSpBCj6aWZZhA@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
 <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
 <CAJfpegugsV8Lzwwiz5BncAnTVc2tPdYcG7eGrVhChcfc6CtBfw@mail.gmail.com> <CAOQ4uxispHXxq8qO9GHEyQm9nLWUiG9CfMzP59hffYM5OPB4DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36285 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751738AbdDGJdA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 05:33:00 -0400
Received: by mail-oi0-f46.google.com with SMTP id r203so79781037oib.3
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 02:33:00 -0700 (PDT)
In-Reply-To: <CAOQ4uxispHXxq8qO9GHEyQm9nLWUiG9CfMzP59hffYM5OPB4DA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Apr 6, 2017 at 6:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> I am thinking linked list of redirect_fh stored in upper inodes (of copy up
> hardlinks and redirected dirs). Loading the list at mount is just
> traversing the list
> and chaining all inodes in memory.
> upper remove may need to update one (prev) inode and copy up (or redirect)
> may need to update one (tail) inode.

I think you didn't take into account copied up and renamed
non-directories.  Those don't have redirect, yet need to find by lower
inode.

I have related idea:

When renaming a lower/merged directory or lower non-directory, always
add back-redirect pointer to moved object pointing to original
location, as well as forward-redirect to whiteout at original location
pointing to new location.   Possibly could do both with file handle.
Whenever either is moved/created/removed pointers need to be updated.
Hard linking a copied up file would result in duplication of the
forward pointers.  Solves the nfs export case, since we can always
find new location of objects based on location on lower layer.

Still doesn't solve the hard link copy-up, but now only a list of
partially copied up hard links is needed, which should be short
(unless someone is deliberately trying to mess with this, in which
case we really don't care about performance).

Thanks,
Miklos
