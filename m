From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Fri, 7 Apr 2017 11:56:08 +0200
Message-ID: <CAJfpegupcgWcP3yC=8Lpe-=m=oq_7f2OR9f14+p+ug+67gWBPA@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
 <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
 <CAJfpegugsV8Lzwwiz5BncAnTVc2tPdYcG7eGrVhChcfc6CtBfw@mail.gmail.com>
 <CAOQ4uxispHXxq8qO9GHEyQm9nLWUiG9CfMzP59hffYM5OPB4DA@mail.gmail.com> <CAJfpeguDJrtJn1bkM03pxH0eo=K81dFYm7OP3QSpBCj6aWZZhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36393 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbdDGJ4K (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 05:56:10 -0400
Received: by mail-oi0-f42.google.com with SMTP id r203so80287198oib.3
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 02:56:10 -0700 (PDT)
In-Reply-To: <CAJfpeguDJrtJn1bkM03pxH0eo=K81dFYm7OP3QSpBCj6aWZZhA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Apr 7, 2017 at 11:32 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Apr 6, 2017 at 6:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> When renaming a lower/merged directory or lower non-directory, always
> add back-redirect pointer to moved object pointing to original
> location, as well as forward-redirect to whiteout at original location
> pointing to new location.   Possibly could do both with file handle.
> Whenever either is moved/created/removed pointers need to be updated.
> Hard linking a copied up file would result in duplication of the
> forward pointers.  Solves the nfs export case, since we can always
> find new location of objects based on location on lower layer.

This breaks when an ancestor of a forward-redirect is moved/removed.

A linked list would still work, but all these are bit fragile.  I feel
it's better to keep this sort of info out-of-band.

Thanks,
Miklos
