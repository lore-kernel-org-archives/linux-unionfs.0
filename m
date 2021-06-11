Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D96C4743D
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Jun 2021 07:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B900E61364
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Jun 2021 07:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhFKHdT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 03:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhFKHdR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Jun 2021 03:33:17 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907E0C061574
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Jun 2021 00:31:19 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id b14so4237224ilq.7
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Jun 2021 00:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lG2+iWFso62mXqanXXl12kDU8RJLBPlg+WJyzRV7xW4=;
        b=Eqpx08zcGhWiKwK9ApQqayDPdKnMeuVnou1WxoqXNl+yT4XV1g+pSasSxM4y2sY9wF
         SdD/9qfytn9BDVZgh/gNUlo42pliUqk3y8rDbNH5/WLJxzVHJ24n8EQpieUX2MQ5EoLz
         rF5WHAMmDkNWh5ptw1NNI8nbOg08ZfBIMmYZjkQrZSPnBL0reHE/tnqPXM74X+eXLV1s
         qItEHmkwyS/Q4cjAp4NNrGBnU7k4MKagO0QFZIRDt01sIrpLnnRQBVffBrWQluwDCDr3
         V9LIkjnchcY927rxwqkxpgHzFpPyHsrI04WSW3q+bt9Sg/2fqcR7dynuERDEAYuJMTky
         nhIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lG2+iWFso62mXqanXXl12kDU8RJLBPlg+WJyzRV7xW4=;
        b=p+DWN6neNyywoHnfu7elbV5Hcz3xwx42s5g+t85iImPjAcGzmKIIhhRylig0OWpm93
         r31vJHJmAra5G7M3dRLQyhW3FkbeL4IYQYKq0/bJcVOjHJOb9iTh7Qd/ePhoiA8W+AmG
         BlubFbU1GSj8ybnHVy6Lh9PCNkWQWdMggwg0gXxJ6SMgkMUMViUSufGgbNzHAXLQc+F5
         1vcDW8u38MjZja+BbzeroIhJF/jLj0Q4Cs8BduY96t12grhmh9SHsah+WwqBCzG6mG3X
         E8hsZBjVvGVz1cWETQJJnbmyoz47ppN9x8d+uL5LwQ3EGBVZ1MJhKXICaxvr332KYlSJ
         +vAA==
X-Gm-Message-State: AOAM530t7MavIqNT7sLrS0RQkFk/OcCFUsX8dsgDrgrnZRItcmLbg44j
        IIzJrn1ABJhHBmDgeYjK3KGr2mrtQMfKvLL1OM3porYWuKA=
X-Google-Smtp-Source: ABdhPJwtPXZCHeWSK9WrVpzjw2haZ6vgMpxkHqivAZ8snSrsJRLHyNd3aU5zzf2wBOZgtmcZiKPCnZkTLuNlkyrfyuw=
X-Received: by 2002:a05:6e02:4e:: with SMTP id i14mr2179962ilr.72.1623396678197;
 Fri, 11 Jun 2021 00:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
 <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
 <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com>
 <CAOQ4uxiqxJBHkiDDuPvL=pMvfqkPadDWReLOwzGpiEn3BBwcjQ@mail.gmail.com>
 <CAJfpegtC+bg3_onOuzQv116axuX36y13P-_ojA5ZOUjfdTPR-g@mail.gmail.com>
 <CAOQ4uxheGdKSqEBYAOTf7=UwqeW=JAaZBwaCs-ng28G7rtqZ7Q@mail.gmail.com>
 <CAJfpegtupBqa6c4qgMVayWZO+5noGEnSAd9tOWySedx+VA=5JQ@mail.gmail.com> <CAOQ4uxjXWWmqFRs3GoyruQ1PUYOE7DiTVqqMFP_RkU7mo7GuaQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjXWWmqFRs3GoyruQ1PUYOE7DiTVqqMFP_RkU7mo7GuaQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 11 Jun 2021 10:31:07 +0300
Message-ID: <CAOQ4uxiHyd4iRxgtDGorNK8fzBJgViUXxgAtS7nfAdHMQeiAew@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 9, 2021 at 10:57 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Jun 9, 2021 at 10:28 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Wed, 9 Jun 2021 at 08:08, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Tue, Jun 8, 2021 at 9:20 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Tue, 8 Jun 2021 at 17:33, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > On Tue, Jun 8, 2021 at 5:49 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > > >
> > > > > > On Tue, 8 Jun 2021 at 16:37, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > > > > > > While you are here, do you think that will be sufficient for the on-disk format
> > > > > > > of overlay.xflags?
> > > > > > >
> > > > > > > struct ovl_xflags {
> > > > > > >         __le32 xflags;
> > > > > > >         __le32 xflags_mask;
> > > > > > > }
> > > > > >
> > > > > > I think I'd prefer a slightly more complex, but user friendlier
> > > > > > "+i,-a,..." format.
> > > > > >
> > > > >
> > > > > OK, but since this is not a merge, we'd only need:
> > > > > overlay.xflags = "ia..."
> > > > >
> > > > > Which is compatible with the format of:
> > > > > chattr =<xflags> <file>
> > > >
> > > > Fine.   Not sure what xflags_mask would be useful for in your proposal, though.
> > > >
> > >
> > > The idea was that in the context of fileattr_get(), any specific xflag
> > > value can be one of: SET, CLEAR, REAL.
> > >
> > > For most inodes all flags are REAL (no xflags xattr)
> > > All flags but the 4 in OVL_FS_XFLAGS_MASK are always REAL
> > > (i.e. taken from fileattr_get() on real inode).
> > >
> > > If we ever decide to extend OVL_FS_XFLAGS_MASK, say to include
> > > DIRSYNC, then an upper inode with DIRSYNC that was in state
> > > REAL before upgrade would become CLEAR after upgrade unless
> > > we kept the old xflags_mask in xattr.
> > >
> > > With the string format, this is not a concern.
> > > Therefore, I like the string format better.
> >
> > Hmm, so if the attribute letters would have fixed places in the string
> > and clear attributes would be represented by a space or a "-" then
> > that would be similarly extensible.   Just having a list of set
> > attribute letters would not allow having three states.
> >
>
> Right. Will do that.
>

Taking a step back.

The main problem this is trying to solve is losing persistent inode flags
on copy-up.

If this was just NOATIME and SYNC the solution would have been
simple - copy up the flags along with other metadata we copy up.

We wouldn't even need to limit ourselves to the 4 vfs inode flags
in ovl_copyflags(). We could add the the copied up flags more
fs specific flags that we know to be safe and rational to copy
such as NOCOW, NODUMP and DIRSYNC.

The secondary problem is that copying IMMUTABLE/APPEND
to upper inode on copy up is not an option, so the solution is to
store those properties in an xattr.

I think we should split the solution to the primary and secondary
problems and avoid an over-designed generic future extendable
xflags xattr feature.

So I am leaning towards a more focused solution for
IMMUTABLE/APPEND in the form of either two boolean
xattr overlay.{immutable,appendonly} or one single bytes
xattr overlay.protected.

Thanks,
Amir.
