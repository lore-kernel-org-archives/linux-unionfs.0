Return-Path: <SRS0=188/=DB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1279CC4363D
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 02:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BCF2176B
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 02:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQQaxyUT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIXCoe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 22:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgIXCoe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Sep 2020 22:44:34 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E11DC0613CE;
        Wed, 23 Sep 2020 19:44:34 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id z5so1022067ilq.5;
        Wed, 23 Sep 2020 19:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BRy63J7lzGhd9jdc38JcBxAK9/pfwjgE6AzE/iurxgo=;
        b=VQQaxyUT0pJquESujAZPFLqiBaiFHZrOxSuDF2VkUv+12mdbaVziWmHrhqxvfoHElR
         X2e+bhnkMTwhQOSgN4POr/YI9m7sKBOcOp6S6swSOhaDjPPQh7SRbDS0kVLhD6fncvql
         WITeH610dXsWJJ0uw6JWM39iL4tzg4Q92JVnG9XndWjLU73BZ2l//hPn0Zm59Gx+ea9a
         w1ahJlw22lQxZLp6fOOsnAZwRcV8Dp8dz9khY1UtT+Fq+BX2BIiVlReuadWFRDpro8rq
         MC5lyEHpmP9q8TPmRKe9CgxZdheCvXTdwZXgIX5ykQ1WdeUSz4kPiOEeSlA8BEjptYNd
         f5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BRy63J7lzGhd9jdc38JcBxAK9/pfwjgE6AzE/iurxgo=;
        b=SsbdeiZ21jr1c/8xWkkmJYTAFo2QqYarIePuaQ3Sl5iU5Y8IXJO8TWTkdYfVkWFEcx
         AyxmuMVnDG2aR+xjeopdw3bPu2ERiP4XLzpMqjya3f6pSMPi3xnEhTlWi3tBkrzGSW6I
         O5mOY/UxdEbY3gse9xBfAgtUaEKTwq227pbfVjhkSkO1tZGZ1kjUyT9BWfBmql6cXGTt
         1neA8RFDMQoBrN34x3D5ovb4jKgpOJgKNRDzKK/R+fWfRuDS0E2SRVQz0j/XKEPlJXc0
         2gha0ibDIPrnYB3N1tYr9Pf/AX+s1J8Iu4czHChLX8y+xPf+oZAqmhlUT/r7HBBuv0pR
         NkcQ==
X-Gm-Message-State: AOAM531d2UjD1GFcDt1UkAiHzN4lMyDdR1EdruBWfDV4g2MjqAZ5RE8j
        2jOrmD/0eAY0JD07ht9cyou96DQuT6/evH49EkU=
X-Google-Smtp-Source: ABdhPJyIVWERBZnR/rQTUaHUqvGijIa4rkumE0Z7edDQRxUtdZqvPeVDybBHWANC4VXG37YqsLvMKEPV4WJy+0U9uaM=
X-Received: by 2002:a92:de45:: with SMTP id e5mr2179119ilr.275.1600915473360;
 Wed, 23 Sep 2020 19:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200923152308.3389-1-ptikhomirov@virtuozzo.com> <20200923194713.GD88270@redhat.com>
In-Reply-To: <20200923194713.GD88270@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 24 Sep 2020 05:44:22 +0300
Message-ID: <CAOQ4uxjZ58bCNz7K6_2bk+O2ALEVFxoNPBXABKMC-+D9-oZ6=w@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: introduce new "index=nouuid" option for inodes
 index feature
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 23, 2020 at 10:47 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Sep 23, 2020 at 06:23:08PM +0300, Pavel Tikhomirov wrote:
> > This relaxes uuid checks for overlay index feature. It is only possible
> > in case there is only one filesystem for all the work/upper/lower
> > directories and bare file handles from this backing filesystem are uniq.
>
> Hi Pavel,
>
> Wondering why upper/work has to be on same filesystem as lower for this to
> work?
>

I reckon that's because I asked for this constraint, so I will answer.

You are right that the important thing is that all lower layers are
on the same fs, but because of
  a888db310195 ovl: fix regression with re-formatted lower squashfs

I preferred to keep the rules simpler.

Pavel's use case is clone of disk and change of its UUID.
This is a real use case and I don't think it is unique to Virtuozzo,
so I wanted index=nouuid to address that use case only and
I prefer that it is documented that way too.

Ironically, one of the justifications for index=nouuid is virtiofs -
because fuse is now allowed as upper (or as same fs),
one can already use fuse passthough (or one could use fuse
passthrough when nfs export works correctly) as a "uuid anonymizer"
for any fs, so in practice, index=nouuid cannot do any more harm
then one can already do when enabling index over virtiofs.

That is why I prefer the interpretation that index=nouuid means
"use null uuid instead of s_uuid for ovl_fh" over the interpretation
"relax comparison of uuid in ovl_fh".

Thanks,
Amir.
