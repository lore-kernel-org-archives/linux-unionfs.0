From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Fri, 7 Apr 2017 13:47:50 +0300
Message-ID: <CAOQ4uxjbfBOvHMwe0xRdXox8Uy3XwdaxJmQpiYDVBT8854z4+w@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
 <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
 <CAJfpegugsV8Lzwwiz5BncAnTVc2tPdYcG7eGrVhChcfc6CtBfw@mail.gmail.com>
 <CAOQ4uxispHXxq8qO9GHEyQm9nLWUiG9CfMzP59hffYM5OPB4DA@mail.gmail.com>
 <CAJfpeguDJrtJn1bkM03pxH0eo=K81dFYm7OP3QSpBCj6aWZZhA@mail.gmail.com> <CAJfpegupcgWcP3yC=8Lpe-=m=oq_7f2OR9f14+p+ug+67gWBPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35728 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754799AbdDGKrv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 06:47:51 -0400
Received: by mail-oi0-f65.google.com with SMTP id g204so1224118oib.2
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 03:47:51 -0700 (PDT)
In-Reply-To: <CAJfpegupcgWcP3yC=8Lpe-=m=oq_7f2OR9f14+p+ug+67gWBPA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Apr 7, 2017 at 12:56 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Apr 7, 2017 at 11:32 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Apr 6, 2017 at 6:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> When renaming a lower/merged directory or lower non-directory, always
>> add back-redirect pointer to moved object pointing to original
>> location, as well as forward-redirect to whiteout at original location
>> pointing to new location.   Possibly could do both with file handle.
>> Whenever either is moved/created/removed pointers need to be updated.
>> Hard linking a copied up file would result in duplication of the
>> forward pointers.  Solves the nfs export case, since we can always
>> find new location of objects based on location on lower layer.
>
> This breaks when an ancestor of a forward-redirect is moved/removed.

Right. but may still be feasible to mix this idea with a linked list
of only renamed dirs (topology transformation info).

>
> A linked list would still work, but all these are bit fragile.  I feel
> it's better to keep this sort of info out-of-band.
>

My main concern with out-of-band metadata is that we will have to sync
this metadata and it is easier to think on metadata transactions in
terms of changes
that are natively bundled together with the original inode
modification by the fs.

For that matter, I like the forward/backward redirect by fh idea, because
affected inodes are most of the time already part of the metadata transaction.
Also, backward redirect should be by path (like it is now) so it is
agnostic for more
renames and forward redirect should be by fh for the same reason and so it
is agnostic to moved object remove as well.

This is interesting enough for me to play with as part of "promotion"
for redirect_fh,
so I may just try to sketch some rough POC for NFS export.

Come to think about it, NFS export of regular file don't need to
follow renames at all:
- The handle for a regular file is always the handle for the real
lower or upper inode
- To decode a handle, create an O_TMPFILE style overlay dentry, which
is not linked
  to any path in overlay, but has the _upperdentry/lowerstack setup
- This way, nfsd can open a read-only handle from the ancient past (why not...)
- Directory handles would have to use the lowermost inode
- To decode a directory handle we need either forward redirect pointers on any
  new object created on top of lower dir or maintain a linked list  and hash or
  all renamed dirs

Am I missing something?

Amir.
