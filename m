Return-Path: <SRS0=taqF=7L=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28358C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 15:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F8820776
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 15:46:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h1NzYeYU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgE2Pq4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 May 2020 11:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE2Pq4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 May 2020 11:46:56 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1246CC03E969
        for <linux-unionfs@vger.kernel.org>; Fri, 29 May 2020 08:46:56 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id l20so2894672ilj.10
        for <linux-unionfs@vger.kernel.org>; Fri, 29 May 2020 08:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kNP4Aphj/8PgPCBdJBBc4Dqy3E7ghgLivNCJRc8crxs=;
        b=h1NzYeYUkJXiM9WUlzwVoQ44DxutnVC91FFQWiH17+9l9cRnQfdDcTPTMF3LX91BrZ
         5glvtWb6RCkrwLAr4Qp5HMKeDsqyN7RznEkgsexku6L9jxG8MGlKXqjvLcULMJxRHA7K
         TWSl3BJ4OuqkorEJfwiKVXzqU38z7uRlqJ8aG1qzdMH9xT5ilNhIxaXYbUzuP8gZOQ9h
         Hy6Ao18v03Tq1mPUsqQ9Kbn9PAI0hjHPQ0H1gcensgvMBW+wwTXjj6v4AdTnyCbZeZ+C
         PB2jK1jdWwJcvBTv4FdAgHD510zGb7tE1o2jkYNRFU76yfsTg3fKxig0tiXQPFpsqTWM
         AE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kNP4Aphj/8PgPCBdJBBc4Dqy3E7ghgLivNCJRc8crxs=;
        b=pABv9fg6lfz9nXl8DpfDNGMysY9iMHj4brcRzfa8O0EnoOwnPoBhcCgLo4h01Sf9jN
         rSO68Om6J6NcsV3uKFg7WcsNMD/mcso8vo9dOjw623fimBfbeuQcU5QprfjATd332uqW
         lMQUq7MKKFqIN0Vo1tSNWUfWr8EB0gQho4WmDQjOLmxfz4m82DD1Dlqsy+ATNGdM9LQD
         BEyVNQtI1juSTVxwk3/Mo6bvAT36yozpxnGHOTrNavDm4m8oOfYWFpERLeO4ba6RwkFM
         tw0PSM6dTlVgpNAYNGBxMvtT27ITZHFF17P+eoTSAfj4NzIGObuohvqnVsWKs0qUuTNy
         3MVA==
X-Gm-Message-State: AOAM532juC7ohw9BXBe1P34Zw66/tMqkWowvlOhmhxhuPkGAuGbZs2V6
        kYjPS5CrNsj/pPWRO/XrAGJRyWOPmcSgq/GbLwM=
X-Google-Smtp-Source: ABdhPJzEJpCA95EhvQNqzWx2nDTDylqH6O6I6b5P3lHQQJ/wYx8hPwShBLThkx+InY3WLSS2rjQRV6FmKbE+XIjD3B0=
X-Received: by 2002:a92:4015:: with SMTP id n21mr8135801ila.137.1590767215417;
 Fri, 29 May 2020 08:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200527041711.60219-1-yangerkun@huawei.com> <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
 <20200527194925.GD140950@redhat.com> <CAOQ4uxis2fgf_c02q=Fy2h=C0U+_zrfUmxW1HQOJ0A7KaKqWgg@mail.gmail.com>
 <20200528173512.GA167257@redhat.com> <CAOQ4uxhnsc8AHfeQJ-eHFEjyONRF5bXBvRd-D29Nao4Bz8EM0g@mail.gmail.com>
 <20200529141623.GA196987@redhat.com>
In-Reply-To: <20200529141623.GA196987@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 29 May 2020 18:46:43 +0300
Message-ID: <CAOQ4uxhie2s+yvF1jpPnh6-+a-r8kz589Y5znAX_jmeWqo+SCQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > > @@ -1023,7 +1020,7 @@ struct dentry *ovl_lookup(struct inode *
> > >          *
> > >          * Always lookup index of non-dir non-metacopy and non-upper.
> > >          */
> > > -       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> > > +       if (ctr && (!upperdentry || (!d.is_dir && !uppermetacopy)))
> > >                 origin = stack[0].dentry;
> > >
> >
> > I think this should be:
> >
> >           * Always lookup index of non-dir and non-upper.
> >           */
> >           if (!origin && ctr && (!upperdentry || !d.is_dir))
> >                  origin = stack[0].dentry;
> >
> > uppermetacopy is guaranteed to either have origin already set or
> > exit with an an error for ovl_verify_origin().
>
> Only if index is enabled and upper had origin xattr.
>
> (!d.is_dir && ofs->config.index && origin_path)
>
> So if index is disabled or uppermetacopy did not have "origin" xattr,
> we will not have origin set by the time we come out of the loop.
>

True. But if index is disabled, setting origin is moot. origin is only
ever used here to lookup the index.

About "origin" xattr. If it is not set in upper that lower fs probably does
not have file handle support. In that case, index cannot be enabled
anyway.

> I see for non-metacopy regular files, if upper did not have origin
> xattr, that means origin_path will by NULL. That means ctr will be
> 0 and that means we will not set "origin" for non-metacopy regular
> files in such case. So question is, should we set "origin" for
> metacopy upper files in such a case.
>
> We did not have origin xattr, but we looked up lower layers for
> upper metacopy. In theory, stack[0].dentry is origin for upper
> metacopy files. Should we use it? Current logic does not and that's
> why this additiona check (!d.is_dir && !uppermetacopy).
>

I agree with your analysis, but this is a very theoretical discussion.
Unless I am missing something, I think we have written a very complex
condition for a corner case that doesn't seem to be valid or interesting.

Basically, for non-dir, if there is no "origin" xattr, then there should be no
index, because the metacopy feature was added way long after we
started storing "origin" on copy up. That's not the case for directories.

There is one corner case where it may be relevant -
overlay layers with metacopy that were created on fs with no file handle
support (or no uuid) that are migrated to a filesystem with file handle
support (and metacopy xattr are preserved in migration).
In that case, index may be enabled while upper metacopy exists
without "origin".

What happens if we do not set origin and do not lookup index in that case?
We can get two overlay inodes, both from different metacopy upper inodes
redirected to the same lower inode, that have the same st_ino, but differnt
metadata.

I suppose we should have a protection in place for not making broken
upper hardlinks that are metacopy, but I don't see it...

> >
> > HOWEVER, if we set origin to lower, which turns out to be a lower
> > metacopy, we then skip this layer to the next one, but origin remains
> > set on the skipped layer dentry, which we had already dput().
> > Ay ay ay!
>
> We only skip the intermediate metacopy entries in lower. So top most
> lower metacopy will still be retained. For example, if there are 3
> lower layers where top two are metacopy and one data, then we will
> only skip middle one. And middle one should not be origin for upper.
>
>                 /*
>                  * Do not store intermediate metacopy dentries in chain,
>                  * except top most lower metacopy dentry
>                  */
>                 if (d.metacopy && ctr) {
>                         dput(this);
>                         continue;
>                 }
>
> For the first lower, ctr will be 0 and we will always store it in
> stack. So if it is metacopy dentry, it will still be stored at
> stack[0].
>
> Do you still see the problem?

No. it's fine. My eyes missed the ctr condition.
I still think since you are changing this code.
It will be much easier to follow if both simple continue statement
are at the top of the loop.

Thanks,
Amir.
