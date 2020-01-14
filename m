From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 3/5] ovl: generalize the lower_fs[] array
Date: Tue, 14 Jan 2020 22:58:18 +0200
Message-ID: <CAOQ4uxi2n6TdGM1EbVdd5U1-gp_Gyx5YRuMs9VQjR+dDT8Capw@mail.gmail.com>
References: <20191222080759.32035-1-amir73il@gmail.com> <20191222080759.32035-4-amir73il@gmail.com>
 <CAJfpegvqXAc2gH2zeAU3V+cNPujdT4h9gJ8f1m=NaAxUL5iXCw@mail.gmail.com> <CAOQ4uxgsuv47D5oZe69cG2VYKZ-D6dC9h1qNo8z8ssL+qr0aMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-il1-f194.google.com ([209.85.166.194]:37594 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANU6a (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jan 2020 15:58:30 -0500
Received: by mail-il1-f194.google.com with SMTP id t8so12828395iln.4
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jan 2020 12:58:29 -0800 (PST)
In-Reply-To: <CAOQ4uxgsuv47D5oZe69cG2VYKZ-D6dC9h1qNo8z8ssL+qr0aMQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 13, 2020 at 4:35 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Mon, Jan 13, 2020 at 4:30 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Sun, Dec 22, 2019 at 9:08 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > Rename lower_fs[] array to fs[], extend its size by one and use
> > > index fsid (instead of fsid-1) to access the fs[] array.
> > >
> > > Initialize fs[0] with upper fs values. fsid 0 is reserved even with
> > > lower only overlay, so fs[0] remains null in this case.
> > >
> > > This gets rid of special casing upper layer in ovl_map_dev_ino().
> >
> > Okay, but shouldn't this last one (which changes behavior) be split
> > into a separate patch?
> >
>
> Right.
> I should probably mention change of behavior in commit message
> anyway...
>

Turns out this change was a mid-series bug and not intentional.

ofs->fs[0].pseudo_dev was not even initialized at this point in the
series. The last patch in the series in the one changing behavior
of upper layer st_dev.
I fixed up this problem and the other review comments, tested and
and pushed to:

https://github.com/amir73il/linux/commits/ovl-layers-v3

Also rebased branch ovl-ino in case you were going to continue
on to review the next series.

Let me know if you want me to re-post.

Thanks,
Amir.
