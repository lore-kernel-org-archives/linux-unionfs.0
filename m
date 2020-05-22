Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231D9C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 18:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06289206DD
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 18:54:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wsi7LEjg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbgEVSyF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 May 2020 14:54:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45330 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730840AbgEVSyE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 May 2020 14:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590173642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E/NY7atph5yZUS2SuBQhFRnCbvYDVMYgXeB+elMZM6I=;
        b=Wsi7LEjgI7xpYYDPsEToy9wWssvPFw070u4CQ3GZfxXbr8/2afzWZ9LFY/J8saWyYOFqDq
        verROGI3l9aTd3p7Ld88GhDVPR6gh85NxumWsMp+Rf8J3WZvcf9AxTSk2IlmRWAEa8NCzh
        gdmdOfGUf+/ulCU/9BbfykZ+3yL2cIM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-X5Utaqc0MDm70t44gy-h8A-1; Fri, 22 May 2020 14:54:01 -0400
X-MC-Unique: X5Utaqc0MDm70t44gy-h8A-1
Received: by mail-qv1-f70.google.com with SMTP id l17so11527039qvm.12
        for <linux-unionfs@vger.kernel.org>; Fri, 22 May 2020 11:54:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E/NY7atph5yZUS2SuBQhFRnCbvYDVMYgXeB+elMZM6I=;
        b=eC85o2lCa/WCdiqgLtfeC+bOIIJcfq67EqqkmuxV7uuNmJMqjuCLqllf5wOZWmY7tj
         L45F5vrhRcLIrFtMVrXie75pz4tGBaa7a/FEUAWtAHWR7/zZ8eZgtjGDz4I9QPGPadRi
         67aoIvqsVTMRGRruBKmBjm6+MV9lkCMZUuS1k8oKGvx8jit1qJJ8rUw0Q5hi94UyGFpk
         pYQ62NWI4M258Cbcl+fqzD/OVDeopeDB1TBBtr6VPciqCnDKCdwvFpnqoPNjji33eEpT
         F6Od3uIWDEfwexgvwonRS0CGEv7EtOd3PRgztBLuPO57l7MIvlRRzfhBeaRGFgP7kziG
         zDeg==
X-Gm-Message-State: AOAM531n3hK/JKWNXHEORQ5oJ/bf6cE8laHvGT8nE7oElCmEZCuJwYN0
        NSpCbBrG1MJO2ncSGYc9nkngFTbmmMjG8a0+sTSeHnthyIQoOrmdkl0FXbPyiiBxXPkGE4yOqZd
        fy28MINYqrrKzp+f8mlouo3lM7ZQh9GteiOcOMBeC9w==
X-Received: by 2002:ac8:6a09:: with SMTP id t9mr17251950qtr.7.1590173641101;
        Fri, 22 May 2020 11:54:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbxr6F952pnH66Ybf4aYPRDiPNGnNWNtV2AqqamKyJkx4ekz3DUmjn2w4Ud12SVL+kOWfT5/QtW00UoW0ai/o=
X-Received: by 2002:ac8:6a09:: with SMTP id t9mr17251936qtr.7.1590173640781;
 Fri, 22 May 2020 11:54:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200522085723.29007-1-mszeredi@redhat.com> <20200522160815.GT23230@ZenIV.linux.org.uk>
 <CAOssrKcpQwYh39JpcNmV3JiuH2aPDJxgT5MADQ9cZMboPa9QaQ@mail.gmail.com> <CAOQ4uxi80CFLgeTYbnHvD7GbY_01z0uywP1jF8gZe76_EZYiug@mail.gmail.com>
In-Reply-To: <CAOQ4uxi80CFLgeTYbnHvD7GbY_01z0uywP1jF8gZe76_EZYiug@mail.gmail.com>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Fri, 22 May 2020 20:53:49 +0200
Message-ID: <CAOssrKfXgpRykVN94EiEy8xT4j+HCedN96i31j9iHomtavFaLA@mail.gmail.com>
Subject: Re: [PATCH] ovl: make private mounts longterm
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 22, 2020 at 7:02 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > > -     mntput(ofs->upper_mnt);
> > > > -     for (i = 1; i < ofs->numlayer; i++) {
> > > > -             iput(ofs->layers[i].trap);
> > > > -             mntput(ofs->layers[i].mnt);
> > > > +
> > > > +     if (!ofs->layers) {
> > > > +             /* Deal with partial setup */
> > > > +             kern_unmount(ofs->upper_mnt);
> > > > +     } else {
> > > > +             /* Hack!  Reuse ofs->layers as a mounts array */
> > > > +             struct vfsmount **mounts = (struct vfsmount **) ofs->layers;
> > > > +
> > > > +             for (i = 0; i < ofs->numlayer; i++) {
> > > > +                     iput(ofs->layers[i].trap);
> > > > +                     mounts[i] = ofs->layers[i].mnt;
> > > > +             }
> > > > +             kern_unmount_many(mounts, ofs->numlayer);
> > > > +             kfree(ofs->layers);
> > >
> > > That's _way_ too subtle.  AFAICS, you rely upon ->upper_mnt == ->layers[0].mnt,
> > > ->layers[0].trap == NULL, without even mentioning that.  And the hack you do
> > > mention...  Yecchhh...  How many layers are possible, again?
> >
> > 500, mounts array would fit inside a page and a page can be allocated
> > with __GFP_NOFAIL. But why bother?  It's not all that bad, is it?
>
> FWIW, it seems fine to me.
> We can transfer the reference from upperdir_trap to layers[0].trap
> when initializing layers[0] for the sake of clarity.

Right, we should just get rid of ofs->upper_mnt and ofs->upperdir_trap
and use ofs->layers[0] to store those.

Thanks,
Miklos

