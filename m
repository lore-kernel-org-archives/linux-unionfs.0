Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA6BC2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 08:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 375DC206B9
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 08:00:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="h3W6cm4M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440088AbgDPIA1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 04:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440319AbgDPIA0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 04:00:26 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F87C061A0C
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 01:00:25 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rh22so635404ejb.12
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 01:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xO6LqvMROHy0tzTBTR7GOWcmjPrgrDVb0HvLkc11pas=;
        b=h3W6cm4MAL8NYcOE2POyu2YPKrffIL2d9QyM01xEFCLnTta8k4hNvKbBPT1lEHuUr2
         YYARModr3btRpFAXy9VIPF9Wlpe6brfmXIWV+NbpYCUwOZbkl6cmyjV+bVhGcHrvV74t
         a0r2kvSaCQZ8s3GZ2y9tDuV4PSffAiMYwB/lA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xO6LqvMROHy0tzTBTR7GOWcmjPrgrDVb0HvLkc11pas=;
        b=ShhaI/Oi+IdwKTlxQcpF2XfaGEgc77/hPdDO8HA3w/Hn+dWNJkCq61zDHQsLsQwWtL
         bwd0g7YfeNrNr+CZJZhYyCZutSt8zlclRFQxbTJguuxYrd3s5zZwBBzsOj1nrIsYPOWs
         eEpyTpejXD7+X8iDvVLaMdUOsDdgW7ipOMQHu98J9CT7SmTcyuTuK+/hJtg2EaO2KFfg
         kNB9hEi0alTAKEAD25v2q9rQQfkLkXC7cIEwcDZLbL33Ya1ZgQ8cfDceJqVosHlnD+Sh
         Mk/14rwtTebf7vCR/Xms0JOJ6lHmoQMtvb4vIEBPuErOT73jhm//xjpSJRs0ZmGsoqtY
         CJ9g==
X-Gm-Message-State: AGi0PuZOYHo+9A3dTNh+8YaOuFqM8USXS9Sf68+dWps81PF2q3IGTGq/
        zwaPpUGfGqRsdNpf+yDmxb62l67rekKP6965etouEIyR
X-Google-Smtp-Source: APiQypKyLgBBdV/T+I1Sy2BgLhT0+ARPjLg/eKHB1AacTm6NLp589Ahd8TNmAOuYE1eijrg7znsnXNfv23akG4FBiZU=
X-Received: by 2002:a17:906:841a:: with SMTP id n26mr8813674ejx.43.1587024024429;
 Thu, 16 Apr 2020 01:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200210031009.61086-1-cgxu519@mykernel.net> <CAJfpegtRXwOTCtEdrg7Yie0rJ=kokYTcL+7epXsDo-JNy5fNDA@mail.gmail.com>
 <171819ad12b.c2829cd3806.7048451563188038355@mykernel.net>
 <CAJfpegstttRvDNYjs9+LaAxFjN21rYn1EWYnZDrXGAKygOj_Hg@mail.gmail.com> <CAJfpegsOq72aPmX8_7_wGboz81ezHqOskGgJH9ZgtTnOfRv1Bg@mail.gmail.com>
In-Reply-To: <CAJfpegsOq72aPmX8_7_wGboz81ezHqOskGgJH9ZgtTnOfRv1Bg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 16 Apr 2020 10:00:13 +0200
Message-ID: <CAJfpegsooG8-kVkozZYf3sP_UL78nTAaqmcUyPTktTiyzSa+Kw@mail.gmail.com>
Subject: Re: [PATCH v11] ovl: Improving syncfs efficiency
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 16, 2020 at 9:39 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, Apr 16, 2020 at 9:21 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Thu, Apr 16, 2020 at 8:09 AM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
> > >
> > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-16 03:19:50 Mikl=
os Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
> > >  > On Mon, Feb 10, 2020 at 4:10 AM Chengguang Xu <cgxu519@mykernel.ne=
t> wrote:
> >
> > >  > > +               if (current->flags & PF_MEMALLOC) {
> > >  > > +                       spin_lock(&inode->i_lock);
> > >  > > +                       ovl_set_flag(OVL_WRITE_INODE_PENDING, in=
ode);
> > >  > > +                       wqh =3D bit_waitqueue(&oi->flags,
> > >  > > +                                       OVL_WRITE_INODE_PENDING)=
;
> > >  > > +                       prepare_to_wait(wqh, &wait.wq_entry,
> > >  > > +                                       TASK_UNINTERRUPTIBLE);
> > >  > > +                       spin_unlock(&inode->i_lock);
> > >  > > +
> > >  > > +                       ovl_wiw.inode =3D inode;
> > >  > > +                       INIT_WORK(&ovl_wiw.work, ovl_write_inode=
_work_fn);
> > >  > > +                       schedule_work(&ovl_wiw.work);
> > >  > > +
> > >  > > +                       schedule();
> > >  > > +                       finish_wait(wqh, &wait.wq_entry);
> > >  >
> > >  > What is the reason to do this in another thread if this is a PF_ME=
MALLOC task?
> > >
> > > Some underlying filesystems(for example ext4) check the flag in ->wri=
te_inode()
> > > and treate it as an abnormal case.(warn and return)
> > >
> > > ext4_write_inode():
> > >         if (WARN_ON_ONCE(current->flags & PF_MEMALLOC) ||
> > >                 sb_rdonly(inode->i_sb))
> > >                         return 0;
> > >
> > > overlayfs inodes are always keeping clean even after wring/modifying =
 upperfile ,
> > > so they are right target of kswapd  but in the point of lower layer, =
ext4 just thinks
> > > kswapd is choosing a wrong dirty inode to reclam memory.
> >
> > I don't get it.  Why can't overlayfs just skip the writeback of upper
> > inode in the reclaim case?  It will be written back through the normal
> > relcaim channels.
>
> And how do we get reclaim on overlay inode at all?   Overlay inodes
> will get evicted immediately after their refcount drops to zero, so
> there's absolutely no chance that memory reclaim will encounter them,
> no?

Spoke too soon.   Obviously this case is about dentry reclaim, not
inode reclaim.

So how about temporarily clearing PF_MEMALLOC in this case?  Doing
this is a kernel thread doesn't seem to add any advantages.

The real solution, as has already been stated, would be to have
changes to upper go though the overlay mapping.

Thanks,
Miklos
