From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 1/5] ovl: generalize the lower_layers[] array
Date: Mon, 13 Jan 2020 16:03:49 +0200
Message-ID: <CAOQ4uxgf_zY5bk9Vzqjh6iRZqPVA63S8aVt-YmQ-4v7CAP3AYw@mail.gmail.com>
References: <20191222080759.32035-1-amir73il@gmail.com> <20191222080759.32035-2-amir73il@gmail.com>
 <CAJfpegsuNXzS8giOcA=0oKe3Qz9R=50d+9guNSaWvNZxCrksPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-il1-f195.google.com ([209.85.166.195]:42346 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728621AbgAMOEL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jan 2020 09:04:11 -0500
Received: by mail-il1-f195.google.com with SMTP id t2so8228273ilq.9
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jan 2020 06:04:10 -0800 (PST)
In-Reply-To: <CAJfpegsuNXzS8giOcA=0oKe3Qz9R=50d+9guNSaWvNZxCrksPQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 13, 2020 at 12:05 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sun, Dec 22, 2019 at 9:08 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Rename lower_layers[] array to layers[], extend its size by one
> > and initialize layers[0] with upper layer values.
> > Lower layers are now addressed with index 1..numlower.
> > layers[0] is reserved even with lower only overlay.
> >
> > This gets rid of special casing upper layer in ovl_iterate_real().
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---

> > -                               lower_layer = ovl_layer_lower(dentry);
> > +                               lower_layer = ovl_dentry_layer(dentry);
>
> I find this confusing.   I expected ovl_dentry_layer() to be an
> analogue of ovl_dentry_real(), but it's not: it will return upper
> layer if there's no lower layer, not the other way round.
>
> How about keeping the ovl_layer_lower() helper and open code the new
> behavior at the single point where it would be used?  I can make that
> change if you ACK that I didn't miss anything.

I agree. I noticed this myself and had a mental note to get back to this,
but the mental note got lost.

Thanks,
Amir.
