Return-Path: <SRS0=GnLN=63=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC894C47076
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 10:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC15F23127
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 May 2020 10:54:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="acK46gYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgEMKyq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 13 May 2020 06:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgEMKyq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 May 2020 06:54:46 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C39C061A0C;
        Wed, 13 May 2020 03:54:45 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h10so3402449iob.10;
        Wed, 13 May 2020 03:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9s3Hd4XCIF1GOezZT5Pm+AuR5fgaynrw5CpM1mHHtaE=;
        b=acK46gYzIVXCzeB72Tyo6PQlhTjvO2Cf7BMw8qZNE3dJMT9ZlnzQb+pZRCuFDjwfNw
         kmxy/q+7O0yMWxLvjAI0Sn4DqQbjEQlBMlAXA29jF4bwehPt1yKIdPe2SV867fvtLAX2
         uTt+j04ws8mQAYq8/C59XfvysYxuPFbg2ccpA92ZsbkGadG9/IF9ECDodp9h17usgBo5
         SLsf17tlK+FJE0w2OKEWCmdOaobtR6U37QpdEI5/W7t6mbvnUlpKy3K4+8L8EOqtY3vc
         +KRQu56f0QhK+/tSfUTthk/dJBuGOtjtSP/hp+f/BE3q/xRcI3QDifHWkaIEg2EgKerS
         u3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9s3Hd4XCIF1GOezZT5Pm+AuR5fgaynrw5CpM1mHHtaE=;
        b=LJJmWjpqHUGrmMmUTPVW6m8jrQhkOIPMcKMNlR4KboMVK5QMhRq0iyQubE8ZMdBKC3
         IZufb/q2h+QEkGEY6lp4cNgc0ZeCpQoGYqRk8yCjbAs9nXL9wrHsgoy+Pg2nAvwpNEzi
         WzG8TYfgO+BU4Yn35xXTHhQMDC7NnKC3XmNNUR2DJer3qy1Cju3ngB19PGg5vT6DUJNP
         zVAppYZyNhgMxE56acZLcsrj+LFyqyF5Xg3rSYIX7bDRmKe45Byqt1DU+yiIEBkbTc9s
         obaavcVCwvehgwNL7wo8mCb3X31sWRFRgtizYkaUigbZzG7OLtsitl+Sug6TnfNSeKMQ
         JhIQ==
X-Gm-Message-State: AGi0PuZh+2JXb5ZsbpCgcZV12JWPEl9LoVDoP039bBvag3vWNHiSDwYZ
        Q4JFR98BcirgV7aelwihk6jX/kl+A/F3wJzL+9ERs01F
X-Google-Smtp-Source: APiQypIgllGn31Ud1VOPru2NcZTTVadvfB3uHRXpxFNXM8F6vZZFVdYztd8H4kr/6vbKz8NuD1brtZ2d2BEbWj/e3dc=
X-Received: by 2002:a02:58c3:: with SMTP id f186mr22494593jab.120.1589367285285;
 Wed, 13 May 2020 03:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200506101528.27359-1-cgxu519@mykernel.net> <20200510155037.GB9345@desktop>
 <172015c8691.108177c8110122.924760245390345571@mykernel.net>
 <20200512162532.GD9345@desktop> <CAOQ4uxiFPrMWrhqjPo3PcgKFiKwSKfh7p+f5hM5fZYKr51HEWA@mail.gmail.com>
 <20200513011019.GY47669@e18g06458.et15sqa> <1720c092a68.c8052b8d3001.6829163626760635444@mykernel.net>
 <CAOQ4uxhV4ubSLmwTh9dHg-FWXYHo8uMh8QVNXhmtN=ahBFRoHg@mail.gmail.com> <CAJfpegttGkTBFgiaUVE549DUwEedb9T9c_dZD32ZJDxdyYpKaQ@mail.gmail.com>
In-Reply-To: <CAJfpegttGkTBFgiaUVE549DUwEedb9T9c_dZD32ZJDxdyYpKaQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 13 May 2020 13:54:34 +0300
Message-ID: <CAOQ4uxiQHag64S5Fd18ZYOMsou=EhffN-f3LSK5cTC9cU2ObKA@mail.gmail.com>
Subject: Re: [PATCH v4] overlay: test for whiteout inode sharing
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Eryu Guan <eguan@linux.alibaba.com>, Eryu Guan <guan@eryu.me>,
        fstests <fstests@vger.kernel.org>,
        linux-unionfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > I suppose it is more suitable, but since at the moment there is only one(?)
> > such feature and there is an open question whether it should or should not
> > be configurable, I myself would have taken the easy path, but Miklos
> > often has a different perspective on these sort of things...
>
> What exactly are we testing?
>

What are testing against silent regressions.
If some change breaks whiteout share we won't know about it
without a test.

> Hard linked whiteouts are an optimization, not something to be relied
> on in any case.  The test should succeed even if overlayfs decides for
> some reason not to share the inode.
>

The best practice would be to ask overlay if feature is supported
in the kernel AND make sure that overlay mount did not disable it
on a specific instance (because of upper fs capabilities).
That is what  _check_overlay_feature does for "features" that have
both module param AND a mount option.

If overlay says that the feature is expected to be enabled on the
instance, we check correctness of the feature. Otherwise, we
report that "feature" is not supported on this instance.

Thanks,
Amir.
