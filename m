From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 3/5] ovl: generalize the lower_fs[] array
Date: Mon, 13 Jan 2020 16:35:05 +0200
Message-ID: <CAOQ4uxgsuv47D5oZe69cG2VYKZ-D6dC9h1qNo8z8ssL+qr0aMQ@mail.gmail.com>
References: <20191222080759.32035-1-amir73il@gmail.com> <20191222080759.32035-4-amir73il@gmail.com>
 <CAJfpegvqXAc2gH2zeAU3V+cNPujdT4h9gJ8f1m=NaAxUL5iXCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:44743 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgAMOfQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jan 2020 09:35:16 -0500
Received: by mail-io1-f67.google.com with SMTP id b10so9974404iof.11
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jan 2020 06:35:16 -0800 (PST)
In-Reply-To: <CAJfpegvqXAc2gH2zeAU3V+cNPujdT4h9gJ8f1m=NaAxUL5iXCw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 13, 2020 at 4:30 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sun, Dec 22, 2019 at 9:08 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Rename lower_fs[] array to fs[], extend its size by one and use
> > index fsid (instead of fsid-1) to access the fs[] array.
> >
> > Initialize fs[0] with upper fs values. fsid 0 is reserved even with
> > lower only overlay, so fs[0] remains null in this case.
> >
> > This gets rid of special casing upper layer in ovl_map_dev_ino().
>
> Okay, but shouldn't this last one (which changes behavior) be split
> into a separate patch?
>

Right.
I should probably mention change of behavior in commit message
anyway...

Thanks,
Amir.
