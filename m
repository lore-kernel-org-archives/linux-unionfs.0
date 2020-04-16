Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C32C2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 07:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF5CB20732
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 07:40:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="W0vCtoV8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439522AbgDPHkM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439257AbgDPHkI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 03:40:08 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2438C061A0C
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 00:40:07 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id r7so1219613edo.11
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Apr 2020 00:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C4B2JuiR6OenV19EDaO+a5Oyya6tjKIKugo7LZEQy/o=;
        b=W0vCtoV8AFaw6SiKhIwRO/1JIF12l1GtD+VngCCa/V4TYn9c35+zyY9BnCxNdBcOQU
         0kqhjeAluEEiBrjQ9aNApaqjH6lXX8qjSBKM2fbfA1eNFPwyK8ujfZx5kKrNq0jHGtA7
         FyKBMaY4XrEgonLWB/vyzPXMaKZH7oZhaPE50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C4B2JuiR6OenV19EDaO+a5Oyya6tjKIKugo7LZEQy/o=;
        b=FjPTl42UdLeQ1u7V8TCc66G3h89UfGG5NG0ca/y+UJQ50NjvpVtNtNhx8UwDvzn2Wo
         WIpQwjS8fwIgoRie+CsVtpZL1vusDWwRebICOGbRWS0KRbfR32ERS7r8j9wJup9f/0q6
         i/Kce75kjglIVV0TjwalcdV/ASC4BnUo03MZJ/aWzswcfmtZTxO8VFGkd9PZtekQGEZQ
         005m0vGaDV++GX4YrNV9otwMabFndd9sBW40GF4IdaEnEVxSd47EVgaj8n29SCg90X60
         Q7+HRtiyS45ppEOzf781WmeKJ4f2MaFmoh2wUwaGClxLBI/nWDKzt6gsMs8YqNgkDQUt
         c4AQ==
X-Gm-Message-State: AGi0PuaUBErmU5elgQfDSfg/k0MnnsjAXwOOQsymYGEAG/5b+X0jaEFm
        DMFGsmM6j4zfMEXNbH2yRyaI0eWBP/rxtn5wi6RmWA==
X-Google-Smtp-Source: APiQypJF2kRXkwSPJUG6aznM5soL2qdQbwEP6ZPY1alEA5bBwwqo6KdJH0d9EWNfj0NaazwtA39qtqQELDFWh1F8Ywo=
X-Received: by 2002:a05:6402:22ed:: with SMTP id dn13mr6071079edb.212.1587022806270;
 Thu, 16 Apr 2020 00:40:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200210031009.61086-1-cgxu519@mykernel.net> <CAJfpegtRXwOTCtEdrg7Yie0rJ=kokYTcL+7epXsDo-JNy5fNDA@mail.gmail.com>
 <171819ad12b.c2829cd3806.7048451563188038355@mykernel.net> <CAJfpegstttRvDNYjs9+LaAxFjN21rYn1EWYnZDrXGAKygOj_Hg@mail.gmail.com>
In-Reply-To: <CAJfpegstttRvDNYjs9+LaAxFjN21rYn1EWYnZDrXGAKygOj_Hg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 16 Apr 2020 09:39:55 +0200
Message-ID: <CAJfpegsOq72aPmX8_7_wGboz81ezHqOskGgJH9ZgtTnOfRv1Bg@mail.gmail.com>
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

On Thu, Apr 16, 2020 at 9:21 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, Apr 16, 2020 at 8:09 AM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
> >
> >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-16 03:19:50 Miklos=
 Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
> >  > On Mon, Feb 10, 2020 at 4:10 AM Chengguang Xu <cgxu519@mykernel.net>=
 wrote:
>
> >  > > +               if (current->flags & PF_MEMALLOC) {
> >  > > +                       spin_lock(&inode->i_lock);
> >  > > +                       ovl_set_flag(OVL_WRITE_INODE_PENDING, inod=
e);
> >  > > +                       wqh =3D bit_waitqueue(&oi->flags,
> >  > > +                                       OVL_WRITE_INODE_PENDING);
> >  > > +                       prepare_to_wait(wqh, &wait.wq_entry,
> >  > > +                                       TASK_UNINTERRUPTIBLE);
> >  > > +                       spin_unlock(&inode->i_lock);
> >  > > +
> >  > > +                       ovl_wiw.inode =3D inode;
> >  > > +                       INIT_WORK(&ovl_wiw.work, ovl_write_inode_w=
ork_fn);
> >  > > +                       schedule_work(&ovl_wiw.work);
> >  > > +
> >  > > +                       schedule();
> >  > > +                       finish_wait(wqh, &wait.wq_entry);
> >  >
> >  > What is the reason to do this in another thread if this is a PF_MEMA=
LLOC task?
> >
> > Some underlying filesystems(for example ext4) check the flag in ->write=
_inode()
> > and treate it as an abnormal case.(warn and return)
> >
> > ext4_write_inode():
> >         if (WARN_ON_ONCE(current->flags & PF_MEMALLOC) ||
> >                 sb_rdonly(inode->i_sb))
> >                         return 0;
> >
> > overlayfs inodes are always keeping clean even after wring/modifying  u=
pperfile ,
> > so they are right target of kswapd  but in the point of lower layer, ex=
t4 just thinks
> > kswapd is choosing a wrong dirty inode to reclam memory.
>
> I don't get it.  Why can't overlayfs just skip the writeback of upper
> inode in the reclaim case?  It will be written back through the normal
> relcaim channels.

And how do we get reclaim on overlay inode at all?   Overlay inodes
will get evicted immediately after their refcount drops to zero, so
there's absolutely no chance that memory reclaim will encounter them,
no?

Thanks,
Miklos
