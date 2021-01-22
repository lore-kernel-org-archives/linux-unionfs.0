Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8335C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 Jan 2021 17:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F50D23A79
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 Jan 2021 17:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbhAVR1k (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 12:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbhAVQFT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 Jan 2021 11:05:19 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A82C061788
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Jan 2021 08:04:39 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id n19so128915ooj.11
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Jan 2021 08:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tyhicks-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uOcDAQTvbMFsGW2wN4EW2b9gto6d910RnbvMcnDkd/c=;
        b=bXsPFrB1DV10D190ze4iNrrBtwxSSmGn8GrafBPD8BtyliQHqw2ujTyLDkoZ5OWg96
         6mipU1MFOuHREzL57e6Q38tAtdqs11tzO6y7rYligD0OnUaG7xcUlS0KmEkfAM0Yswgu
         l++pDvDOnvP/GdecS4qp8nK7kjhRgr4yIBykvRURR76yz2BEwPVLZ3CX8agwcxDDHSFr
         QiXBIbhIQPDcMg2oRqrarqb5vDUym50sSShT5GnuyVhklzDs16MyaduLffdt/dXgdOnO
         Xk4kYv3OylnZ5xhixhBLqJ58EZw1FUQbqz4w08kgeUSkYT3jgBjpggdnOyWhVRE7Czu1
         kV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uOcDAQTvbMFsGW2wN4EW2b9gto6d910RnbvMcnDkd/c=;
        b=Ok18JN21xi01mMyG2jSDytdK7hOhA+E3p5xNxTdb+6zpNxfSTBVQUcg2HMHYNWVQjL
         H7zHOSEuO9QBuNizWzikxh3jJkE/PoGZ/XzxHeNqgdAJFJ14G7O306pDE4awH5TsHoOd
         QfaQHo+GcVt1bIgo8Lu8Toa+S+5O4y4rnnCltmg910Cl9X1TtQauEYQAc7795n8MWoh/
         9sSTl+VNDGaZh0GbeL8Rsv196rfFtmxa0AvjUURpbeIZYvScrYTm8nyS8v79cJ4A9vKW
         96LHb1jxSoDsUJVnU1TrZuweli1qn4SwQ168fYZjHLttDLAhpx21UYbNUEUZ+JJEnT+G
         m9NQ==
X-Gm-Message-State: AOAM5324VdoZ7msosMj1X35jwPpamAEd6h/bBsOccdrb8IC5O75S05eO
        8mK9+pie6lgVZ0J/xOoWVl2yHA==
X-Google-Smtp-Source: ABdhPJzIjq8M1jb98C+LunJrol58KNv9YwNRZtbUnN8EKKfvwE3/ZyEzVUyiSlU2AxPGpBEkCN2gaA==
X-Received: by 2002:a4a:94cc:: with SMTP id l12mr4259445ooi.70.1611331478531;
        Fri, 22 Jan 2021 08:04:38 -0800 (PST)
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net. [162.237.133.238])
        by smtp.gmail.com with ESMTPSA id q6sm1743948otm.68.2021.01.22.08.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 08:04:37 -0800 (PST)
Date:   Fri, 22 Jan 2021 10:04:19 -0600
From:   Tyler Hicks <code@tyhicks.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Serge E . Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 1/2] ecryptfs: fix uid translation for setxattr on
 security.capability
Message-ID: <20210122160419.GA81247@sequoia>
References: <20210119162204.2081137-1-mszeredi@redhat.com>
 <20210119162204.2081137-2-mszeredi@redhat.com>
 <87a6t4ab7h.fsf@x220.int.ebiederm.org>
 <CAJfpegvy4u9cC7SXWqteg54q-96fH3SqqfEybcQtAMxsewAGYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvy4u9cC7SXWqteg54q-96fH3SqqfEybcQtAMxsewAGYg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 2021-01-20 08:52:27, Miklos Szeredi wrote:
> On Tue, Jan 19, 2021 at 10:11 PM Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> >
> > Miklos Szeredi <mszeredi@redhat.com> writes:
> >
> > > Prior to commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap() call into
> > > vfs_setxattr()") the translation of nscap->rootid did not take stacked
> > > filesystems (overlayfs and ecryptfs) into account.
> > >
> > > That patch fixed the overlay case, but made the ecryptfs case worse.
> > >
> > > Restore old the behavior for ecryptfs that existed before the overlayfs
> > > fix.  This does not fix ecryptfs's handling of complex user namespace
> > > setups, but it does make sure existing setups don't regress.
> >
> > Today vfs_setxattr handles handles a delegated_inode and breaking
> > leases.  Code that is enabled with CONFIG_FILE_LOCKING.  So unless
> > I am missing something this introduces a different regression into
> > ecryptfs.
> 
> This is in line with all the other cases of ecryptfs passing NULL as
> delegated inode.
> 
> I'll defer this to the maintainer of ecryptfs.

eCryptfs cannot be exported so I do not think this proposed fix to
ecryptfs_setxattr() creates a new regression wrt inode delegation.

Tyler

> 
> Thanks,
> Miklos
