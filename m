Return-Path: <SRS0=DgkE=AT=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36C1C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 08:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58E7920674
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 08:00:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="naiTVYQL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgGHIAk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 04:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGHIAk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Jul 2020 04:00:40 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29F7C08C5DC
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2020 01:00:39 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b15so40849857edy.7
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2020 01:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ckncIkpeRK6X3GSamNioOuUdnYHfmJ6tHp2tvZ7ju4s=;
        b=naiTVYQLIFLTWzdNXqKE+GLAZT1Nm+STa0TUg3NQIRtRAGHBHZzCJG3ZrQNYFpIJmV
         VwZHOMW8Jgu8CsPTfO6iHyXDdO80X2a3OYET068pvmYlDcanFtfwthHXQYrptv7velWd
         9iS6MRLwc8TucjUyjtKeggJHFrJOfQZfap88Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ckncIkpeRK6X3GSamNioOuUdnYHfmJ6tHp2tvZ7ju4s=;
        b=KimhGBxrVFepX2oaECQf1xjau9tjq7tL53AGm1q07/O+G8HWH7FAV/eq5nTOy6V1BE
         tArbfv0Me4bPhL6ylJIakiCpfOFMc1JWj4CAayfAlZEf/wm6PEyYCT8rn/cxWxkiPkLv
         eK4lwu3nB4rfJ2X77cxtDglo64r49c1nkTcDu17DfB54fKoTD/eoJgdej4TD9p4iJGM1
         w2hPOcr4OgWwJtxx0Gfc53PDMVNMvGTov3zhaAFcu64QzV5cimv3jB+EzGwwptmpRYBQ
         HDarsgda+egqop8EzsI8WpFOBkSQkZByqdrDl+GZRoM97oxLz1dLm29JPgLfA9Ft3fBc
         kIIQ==
X-Gm-Message-State: AOAM530IoUEV23t/aClCnKLfpbv7pWVBDhz4zOBTh5ASxV2gaiM7CxH2
        wj/e+MCKaMOWMf5qQtzNS5Yf9vOieE+uqtLvNaPnSQ==
X-Google-Smtp-Source: ABdhPJxkrJCq8OgGCj1XuIBF0WOWZRwwpLBWLeBCMFRkLXS/9/qtNEOZzfBUFu0sm8LBwHVQXs0q61s9ZGdZPxttuKc=
X-Received: by 2002:a05:6402:1bdd:: with SMTP id ch29mr55157377edb.134.1594195238432;
 Wed, 08 Jul 2020 01:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <32532923.JtPX5UtSzP@fgdesktop> <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
 <106271350.sqX05tTuFB@fgdesktop> <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
 <20200707155159.GA48341@redhat.com> <CAOQ4uxhMq_8xwCU2t+WveTGgc9MAWE2RD66q5UjQ1r09EoLzHA@mail.gmail.com>
 <20200707215309.GB48341@redhat.com> <CAOQ4uxhd+kYzaDmndCV5rgiswfHnyLjZokmUa+BVk9t31C=HWg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhd+kYzaDmndCV5rgiswfHnyLjZokmUa+BVk9t31C=HWg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 8 Jul 2020 10:00:27 +0200
Message-ID: <CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 8, 2020 at 8:55 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Jul 8, 2020 at 12:53 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Tue, Jul 07, 2020 at 08:41:20PM +0300, Amir Goldstein wrote:
> > > > > Miklos,
> > > > >
> > > > > At first glance I did not understand how changing lower file handles causes
> > > > > failure to ovl_verify_inode().
> > > > > To complete the picture, here is the explanation.
> > > > >
> > > > > Upper file A was copied up from lower file with inode 10 in old squashfs
> > > > > and the "origin" file handle composed of the inode number 10 is recorded
> > > > > in upper file A.
> > > > >
> > > > > With newly formatted lower, lower A has inode 11 and lower B has inode 10.
> > > > > Upper file B is copied from lower file B with inode 10 in new squashfs and
> > > > > the "origin" file handle composed of the inode number 10 is recorded
> > > > > in upper file B.
> > > > > Now we have two upper files with the same "origin" that are not hardlinks.
> > > > >
> > > > > On lookup of both overlay files A and B, ovl_check_origin() decodes lower
> > > > > file B (inode 10) as the lower inode.
> > > > > This lower inode is used to get the overlay inode number (10) and as
> > > > > the key to hash overlay inode in inode cache.
> > > > >
> > > > > Suppose A is looked up first and it's inode is hashed.
> > > > > Then B is looked up and in ovl_get_inode() it finds the inode hashed
> > > > > by the same lower inode in inode cache, but fails ovl_verify_inode()
> > > > > because:
> > > > > d_inode(upperdentry) /* B */ != ovl_inode_upper(inode) /* A */
> > > > >
> > > > > This can also happen when copying overlay layers to a new
> > > > > fs tree and carrying over the old "origin" xattr.
> > > > > In practice, the UUID part of the stored "origin" xattr is meant to
> > > > > protect against decoding lower fh when migrating to another
> > > > > filesystem, but layers could be migrated inside the same filesystem.
> > > > > Since squashfs does not have a UUID, re-creating sqhashfs is similar
> > > > > to migrating layers inside the same filesystem.

No, I think copying layers is a different issue: it's not possible to
get the same file handle for A and B since they are

 - either on different filesystems and uuid is different
 - on the same filesystem, hence fh must be unique for the lifetime of the fs

> Now, suggestions for work arounds:
>
> 1. Don't follow with lower null uuid (patch posted) - no caveats

We could add some sort of "overlay version"  to origin to be able to
trust null uuid, but only if created in *this* instance of overlayfs.
That way we retain some of the advantages without any of the
drawbacks.   This does not seem too complex theoretically, but not
sure if it's worth it.

> 2. Opt-out of following origin with explicit option e.g. "index=nofollow"
> 3. Don't follow origin unless one of the following opt-in features:
>     metacopy,index,xino

Maybe, if 1) is problematic for some reason.

Thanks,
Miklos
