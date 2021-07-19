Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914A7C07E9D
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Jul 2021 17:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C6C360E0C
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Jul 2021 17:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351267AbhGSQUu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 12:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353061AbhGSQPb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jul 2021 12:15:31 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929BAC073393
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jul 2021 09:21:07 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id p186so20691219iod.13
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jul 2021 09:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IELxd8u2KtJRLhncBFwtnLOSjptSI44+83RXSQKidPA=;
        b=dNQLV80vp+RKMgWw3QHClapUpI9v3tuNlBwVaMKa4Had+bHQFCBPNXgx8Z/uczYRbs
         7aiUGVEmuC5WI1+tnxrrpv5ER0ocH+rDewGpoqg7g8Cv4oAgne0RaHfK6BwqpltTFIVW
         O6VFilvUU6HugaZDZc7xVx3Zq4RogqJBhg/2NI5kougOpjISNIAwSPxfdbpvOTvEXrSM
         Jt/fDt3zKYb3dcm32U38X1xfe/Z/XhqRFDYANAwCbPmuTAoZ0SUrSznnJuczqviUSDY/
         icfJFhTt+kWhBNX6K0ylkAu7Auv2mm1FqhzV4lOy9uT6CaXsWKlpkIxH8AJwF+E8qPh0
         B7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IELxd8u2KtJRLhncBFwtnLOSjptSI44+83RXSQKidPA=;
        b=HualN9QVj2NJpwprL1eg3jit2EKHI6O2mhYOi/8PWQHM/GWmv0oafWq4WI4SKbp0V4
         yri+mo/i4mxx0wtMu5DJxJZ7V2w9WewQi3SqzATB+CX5/AP25DOUW+56HK5uWazXClwi
         MuEXXdul/9Bnjxe/hZQ1Vwd5Os3TWm0uPYtsYA3DJubbOlp9kxgqibu0gtDCXd2kKX6n
         5Pxc909AHqiWOreH0VWrDmyKTE5h7Gwi4Uyw7U1VyTHwzkSO0xH+0wwqY4DksPTLCbnE
         KAWUEMsQm0sgjQ1NNrCf8wr+MS7hy5NmuBpx9fYCSnuEPM9/DLFh4l6ou63UKdi+F8qM
         4E/Q==
X-Gm-Message-State: AOAM531AWc1b5+FYsiCyZ3CbzHvZIpjHfFeW6KywKYAB+Rp/ZFPe8Nqw
        p5nSgdxHRGRUoDtfWDTclgt1I/yogrHEADH9tjkeErrKKLo=
X-Google-Smtp-Source: ABdhPJwPMIkSnkhdOQFcZ/hqoj0+FH7Wpa8/hI4Hxa+iMXuW+nqEi+qD11EdU5CVXUyuWAuUZ708Q6tU4Pf46DkNU1A=
X-Received: by 2002:a05:6602:3304:: with SMTP id b4mr19316040ioz.186.1626713013573;
 Mon, 19 Jul 2021 09:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210426152021.1145298-1-amir73il@gmail.com> <CAOQ4uxg3CJGstSGsihibXvUtivOhRimnQKqrh=5mSqZa1hA8fQ@mail.gmail.com>
 <CAJfpegtZq=EPuoU_wxr4yEJtime4vW6oPFBnX5whrXS3ZSA6oQ@mail.gmail.com>
In-Reply-To: <CAJfpegtZq=EPuoU_wxr4yEJtime4vW6oPFBnX5whrXS3ZSA6oQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 19 Jul 2021 19:43:22 +0300
Message-ID: <CAOQ4uxjeHfEy-NHQ3s8gX6Rge9xUkJhfGWGNBFSRj6t4mhAUMQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip stale entries in merge dir cache iteration
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 19, 2021 at 6:24 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Fri, 4 Jun 2021 at 12:43, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Apr 26, 2021 at 6:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On the first getdents call, ovl_iterate() populates the readdir cache
> > > with a list of entries, but for upper entries with origin lower inode,
> > > p->ino remains zero.
> > >
> > > Following getdents calls traverse the readdir cache list and call
> > > ovl_cache_update_ino() for entries with zero p->ino to lookup the entry
> > > in the overlay and return d_ino that is consistent with st_ino.
> > >
> > > If the upper file was unlinked between the first getdents call and the
> > > getdents call that lists the file entry, ovl_cache_update_ino() will not
> > > find the entry and fall back to setting d_ino to the upper real st_ino,
> > > which is inconsistent with how this object was presented to users.
> > >
> > > Instead of listing a stale entry with inconsistent d_ino, simply skip
> > > the stale entry, which is better for users.
> > >
> >
> > Miklos,
> >
> > I forgot to follow up on this patch.
> > Upstream xfstest overlay/077 is failing without this patch.
>
> Can't reproduce (on ext4/xfs and "-oxino=on").
>
> Is there some trick?

Not sure. overlay/077 fails for me on v5.14.0-rc2 on ext4/xfs.

     QA output created by 077
    +entry m100 has inconsistent d_ino (234 != 232)
    +entry f100 has inconsistent d_ino (335 != 16777542)
     Silence is golden

Maybe you need to build src/t_dir_offset2?

Thanks,
Amir.
