Return-Path: <SRS0=REe/=6M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41581C83000
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17B61206D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jQG0CKGR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgD1PPR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727108AbgD1PPR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Apr 2020 11:15:17 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F67AC03C1AB
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2020 08:15:17 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id 19so23194725ioz.10
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Apr 2020 08:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=peXWrvolagQ69mR/W7iWXYWHkBT/g1ootkzn8QZwWZw=;
        b=jQG0CKGRsP6Dcv533J1kQLbpNX90EMvWzEspNBicnKPT0NigCsgXmfQpwZCvcQFa60
         XjpBrEtoH835fnwpaY4HhysrQ70ahXc9cujzQFwl5EoCwv+d4puiWX/7Yc2CPWi5ok9p
         MZvlZDVsGZAAHvvB79Hwm9fYOK5gF4VaOXrnBVYTnJXVFaqTpX7B25mSRe0/U8JvMXFD
         2EK0atBVhAmZlaeXw/BiVnpQcwX2h1Feg0es7chaNTjyLM3nJGFNYxI6qpnHXwWYTxJS
         PPec1nl2DI5ojLh8e3yNoN2fhw5Pn1Fb7JUpQFh+I71zcTEQnbQTYoN0ar/ck0iMGOhX
         /pJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=peXWrvolagQ69mR/W7iWXYWHkBT/g1ootkzn8QZwWZw=;
        b=JZqDR3b0yYWPikGriEsSClFz8PyEmu2K7pb6ZVDyTnbM2o6LASPq3igvq48HgF6eiI
         JQMMlGOfAVuzSU0Wpzs0mcCPO3UIYM/a/V5B9TpcN+WUBwKnzH1bIefPUn4LA4IAMI/c
         araw/erDe0cJFr6VmlchCA56njBzJygpLLNV4nj96CpVTddlkPb3H6nKhrkQ9SN2k6MP
         05V+V/rUkZdL4CHgfjei1Dnq77Y51YOOkCU4ihP8HSpsCm7Vmg8lPA6acIQOPpbbRh8J
         sR7P9YDv5KxUGtBtzVCyTnHCqW5Vgmw0hx9nHVhGRUvhmOqgj8vWReF2plcIsy4SIoc+
         IVWA==
X-Gm-Message-State: AGi0PuZrDnlvfyMqff5ux9RJwwpNb8AUV6Ouk0OAu/dqvb/VRA+ubz4c
        NsU7/pa+MS2Jmx4QBTo1iSahQHrcawJbD5ZYzOUYog==
X-Google-Smtp-Source: APiQypK5eI9HlM34Msf9oj+WeyWZQWwH2IQYtmr75eppKb4nLQL+JSFFsdOsMqbOidAzMuuaRxV3TRSEyZRYb8L+wNM=
X-Received: by 2002:a02:c9cb:: with SMTP id c11mr24500354jap.93.1588086916866;
 Tue, 28 Apr 2020 08:15:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200422102740.6670-1-cgxu519@mykernel.net> <CAOQ4uxj5JsWOgQ8vHqTkAXx16Y9URTgNpALY5XO=VNUAMTkOMw@mail.gmail.com>
 <171a49cb02a.e6962d897896.4484083556616944063@mykernel.net>
 <CAOQ4uxhowSRqD9kSoUHg+D8-RdxF8vBbTauTchgnpG5MoSNSEA@mail.gmail.com>
 <171aadd9966.100e576ad1248.8616898883060201949@mykernel.net>
 <CAOQ4uxi_zp45KrjnR4FJx56gsDPsoim4U0H7hj1ta4+gXAwQtQ@mail.gmail.com>
 <20200428122104.GA13131@miu.piliscsaba.redhat.com> <CAOQ4uxh4ZVqOHtiytk4fHB5otNd8VRM-Z_8ZYpW1qMjzAsmkZw@mail.gmail.com>
 <CAJfpegvCyr_JJr8_n+qXOHVeCxgHGmizCqZ3b2mKAA9M_qbQQw@mail.gmail.com>
In-Reply-To: <CAJfpegvCyr_JJr8_n+qXOHVeCxgHGmizCqZ3b2mKAA9M_qbQQw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 28 Apr 2020 18:15:05 +0300
Message-ID: <CAOQ4uxgMiPOu0m3j6Rq1Dkr5fsj32HCaAf8MrcuQjp+tT1DYww@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: whiteout inode sharing
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 28, 2020 at 4:32 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, Apr 28, 2020 at 3:16 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Apr 28, 2020 at 3:21 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > > And I don't really see a reason to disable whiteout hard links.  What scenario
> > > would that be useful in?
> >
> > I have a vague memory of e2fsck excessive memory consumption
> > in face of many hardlinks created by rsync backups.
> > Now I suppose it was a function of number of files with nlink > 1 and not
> > a function of nlink itself and could be a non issue for a long time, but I am
> > just being careful about introducing non-standard setups which may end up
> > exposing filesystem corner case bugs (near the edge of s_max_links).
> > Yeh that is very defensive, so I don't mind ignoring that concern and addressing
> > it in case somebody shouts.
>
> Right, and even if such a corner case bug exists, it's still primarily
> a bug in the underlying filesystem and should be fixed there. A
> workaround in overlay would only make sense if for some reason the
> primary fix is difficult or impossible.
>

Sure.

> > > +fallback:
> > > +       whiteout = ofs->whiteout;
> > > +       ofs->whiteout = NULL;
> > > +success:
> >
> > This label is a bit strange, but fine.
>
> Agreed, changed to "out:"
>

I meant no reason to have goto label when you can just return whiteout,
but it's fine either way.

Thanks,
Amir.
