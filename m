Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E918C47095
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Jun 2021 07:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10586610A2
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Jun 2021 07:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbhFIHbb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 9 Jun 2021 03:31:31 -0400
Received: from mail-ua1-f43.google.com ([209.85.222.43]:37742 "EHLO
        mail-ua1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbhFIHbb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 Jun 2021 03:31:31 -0400
Received: by mail-ua1-f43.google.com with SMTP id f34so975638uae.4
        for <linux-unionfs@vger.kernel.org>; Wed, 09 Jun 2021 00:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J+ogSnuTZ3yD6xYTurA+YR+K5zVSMrn16Ioq8dOjGqQ=;
        b=JPg5lI1gWkTwLa79VnF6ms88UzbPMbHS6tZJYiZDS7ZRY7pitJz1aWzLwMnpCMbvEC
         MOPpM0xYDgDQ4PVf1aiGnaVabwHjdP4dgZJ3QsIX49SLu6H2+mEW/dvChrt9PJyUrCM8
         xVFX0RCRxj7c/0BSBV40ULOFax9/AbuaRtGFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J+ogSnuTZ3yD6xYTurA+YR+K5zVSMrn16Ioq8dOjGqQ=;
        b=XKXgr0CHvbfpUBqjrQi78TT9sGQqEoQuPDUc+YJ7d50bP2zoCcimAXe/u+wHiZuAsf
         P8KJNuxsVMfMALd2RvYvzx4wf+kKtHcCI9zOvku26Ixtindt0LHtrZRPWiPPoJ3WRkDL
         2FyUeoeJUDFj1VsqUmXuWd0z5kkQTFymHMwF3doZWge5uq4Mpe80mk9WfyI2GDYuScKg
         5wrrE+D8+VxrvAqBxOxeqZDkPCMqLkYyMrCabC4qcCzXEI6TlvZuHWKoH8Y1fO1l8NIz
         bNOueXwR4IV0Bb6CLfnWNPcLsS3rqevIzSFU0qXvbm9v6l7R5iEyZtRku9KI4DzmbfxC
         JW2Q==
X-Gm-Message-State: AOAM533u3cu1FISa+v6Y8p3YzzRD6T6jPnXNNwyq5bYzn7y9z0DXvtX+
        uB+GtjqLC66GMEmsEQ0nWE+uwgr7mG9+NI/Zwyr57zRdQ8k=
X-Google-Smtp-Source: ABdhPJxY/nNRQQHBCOKyi38pcTUxtF+m73L4eBOLobx2vRSZkFeH2HFiybtdIKy346++KuYArbXd4ZRBtxqEluIUPjk=
X-Received: by 2002:ab0:2690:: with SMTP id t16mr16363819uao.9.1623223716569;
 Wed, 09 Jun 2021 00:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
 <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
 <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com>
 <CAOQ4uxiqxJBHkiDDuPvL=pMvfqkPadDWReLOwzGpiEn3BBwcjQ@mail.gmail.com>
 <CAJfpegtC+bg3_onOuzQv116axuX36y13P-_ojA5ZOUjfdTPR-g@mail.gmail.com> <CAOQ4uxheGdKSqEBYAOTf7=UwqeW=JAaZBwaCs-ng28G7rtqZ7Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxheGdKSqEBYAOTf7=UwqeW=JAaZBwaCs-ng28G7rtqZ7Q@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 9 Jun 2021 09:28:25 +0200
Message-ID: <CAJfpegtupBqa6c4qgMVayWZO+5noGEnSAd9tOWySedx+VA=5JQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 9 Jun 2021 at 08:08, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jun 8, 2021 at 9:20 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Tue, 8 Jun 2021 at 17:33, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Tue, Jun 8, 2021 at 5:49 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Tue, 8 Jun 2021 at 16:37, Amir Goldstein <amir73il@gmail.com> wrote:

> > > > > While you are here, do you think that will be sufficient for the on-disk format
> > > > > of overlay.xflags?
> > > > >
> > > > > struct ovl_xflags {
> > > > >         __le32 xflags;
> > > > >         __le32 xflags_mask;
> > > > > }
> > > >
> > > > I think I'd prefer a slightly more complex, but user friendlier
> > > > "+i,-a,..." format.
> > > >
> > >
> > > OK, but since this is not a merge, we'd only need:
> > > overlay.xflags = "ia..."
> > >
> > > Which is compatible with the format of:
> > > chattr =<xflags> <file>
> >
> > Fine.   Not sure what xflags_mask would be useful for in your proposal, though.
> >
>
> The idea was that in the context of fileattr_get(), any specific xflag
> value can be one of: SET, CLEAR, REAL.
>
> For most inodes all flags are REAL (no xflags xattr)
> All flags but the 4 in OVL_FS_XFLAGS_MASK are always REAL
> (i.e. taken from fileattr_get() on real inode).
>
> If we ever decide to extend OVL_FS_XFLAGS_MASK, say to include
> DIRSYNC, then an upper inode with DIRSYNC that was in state
> REAL before upgrade would become CLEAR after upgrade unless
> we kept the old xflags_mask in xattr.
>
> With the string format, this is not a concern.
> Therefore, I like the string format better.

Hmm, so if the attribute letters would have fixed places in the string
and clear attributes would be represented by a space or a "-" then
that would be similarly extensible.   Just having a list of set
attribute letters would not allow having three states.

Thanks,
Miklos
