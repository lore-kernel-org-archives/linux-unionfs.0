From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Fri, 7 Apr 2017 18:07:14 +0300
Message-ID: <CAOQ4uxgtnF-ziZTsRt8xnokr66+rQnTQvTJ4gBYozPgUoE0P9Q@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
 <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
 <CAJfpegugsV8Lzwwiz5BncAnTVc2tPdYcG7eGrVhChcfc6CtBfw@mail.gmail.com>
 <CAOQ4uxispHXxq8qO9GHEyQm9nLWUiG9CfMzP59hffYM5OPB4DA@mail.gmail.com>
 <CAJfpeguDJrtJn1bkM03pxH0eo=K81dFYm7OP3QSpBCj6aWZZhA@mail.gmail.com>
 <CAJfpegupcgWcP3yC=8Lpe-=m=oq_7f2OR9f14+p+ug+67gWBPA@mail.gmail.com>
 <CAOQ4uxjbfBOvHMwe0xRdXox8Uy3XwdaxJmQpiYDVBT8854z4+w@mail.gmail.com> <CAJfpegts8UjOXYLoUyn9m-tLK7fXyFH=mmm3J3vAZ4U_Xm9=XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34885 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdDGPHP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 11:07:15 -0400
Received: by mail-oi0-f65.google.com with SMTP id g204so2305402oib.2
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 08:07:15 -0700 (PDT)
In-Reply-To: <CAJfpegts8UjOXYLoUyn9m-tLK7fXyFH=mmm3J3vAZ4U_Xm9=XQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Apr 7, 2017 at 4:03 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>
> One more idea:  do it out-of-band (e.g. under workdir) but do it as a
> plain directory tree shadowing the lower trees that contains the
> forward redirect information.  It spares us the implementation of the
> database, since the filesystem does it for us.  Yes, it can get out of
> sync with the overlay, but so can any mapping in-band or out-of-band.
>

I like this.

"don't implement a database of files, because filesystem is already
a super complex and optimized database of files metadata" is a
design concept I feel strongly about.

It always bothered me that is_lower_positive() is not cached
in a single place.

I am not concerned about getting out of sync to to an
implementation bug.
I am concerned about not being able to program power fail safe
code that does not require calling fsync for metadata operations.

Because the shadow directory existence is not a problem
we can safely create it anytime before upper rename
and if we set a redirect_fh on the shadow dir, we can also
do that anytime before rename and we are also safe wrt
upper rmdir.

So forget the linked list construct.
Shadow tree on-disk construct is better in all aspects
and it is easier to debug.

You do realize that this feature is RO_COMPATIBLE
because if workdir will have nested dirs overlay in
old kernel will be mounted readonly (at least from some
kernel version), which makes me like this idea even more :-)

Several lower layers complicates things a bit because
path A could have different forward redirects to different
upper dirs from different lower layers.

I can try to do a POC that assumes there are no redirects
in the lower layers and then see how we proceed from there.

Amir.
