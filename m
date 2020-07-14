Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6295C433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B42320890
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:33:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XDhcppGN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgGNSdD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 14:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgGNSdC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 14:33:02 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF933C061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 11:33:02 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f23so18368999iof.6
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 11:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ttQgdXTLXkvDKDbRyaraJcQSrB7H4ZDsSjwyKwACLE=;
        b=XDhcppGNN5dFmE3dep91wDne+0WvcfTm1gOa9FeCb4Twdf5dzieJhInNnjRyIQPDPl
         t6J4cyVErg4cDMfilP6cQVdFPiIi+3kNEnYH3Zw6ni/GDXGfaf+mjYWiaTw6nSoPVBii
         fhvlWKHmqa/pU1six+v10xSSaZC/ZkYvYc+1j8vHy22f2RLmUUMY/XdOc+WfhYv+Pdo+
         B5kzoKkrtv4Q5sbnM8nZgwvC0fdJRKhjtxrEx+RHk9olJCO/mDLv8wfrCFJwqHqcvHdr
         G0wHYnT1dw8DvEddYbzOlJnWd0osGieIskRf8gWqoKyc8BBGDrd/bGg/+HwEkchqTF7F
         Gn0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ttQgdXTLXkvDKDbRyaraJcQSrB7H4ZDsSjwyKwACLE=;
        b=NbaZDe77aqWEy26bLCAH5GRBx4ztZ0vXMA7XPwY+KSbsrST/+cDJLXZafjNjDfr7dN
         jmS9CAqwNyN3uL5lOODZ2k9LMAXMF39C17BxvsHBtavW8FlJW6ozK69VRNOlZjADvjqm
         x+4vmHKbgnnciQSpLk0ZMfBozcSfZkhm9WR86dEzX5wnxDvGsYRcPenuUWsvtieFvs1F
         lRNxMHdPqkaEP8XjIwvrv/dEyPLN84EfbEPVsqXy+hsYjU5cptu1NAuPK2Uyn3/48BJT
         eOfK99oyBxAp+eMkPYyTUQzhUSCmd/FXh8I+Qfw3yVJ/MkxPDnfyJ2c340qINv/umtEC
         ymmw==
X-Gm-Message-State: AOAM531Y8zM3bj+721JAZOwfYSDFCrs0Y2jWv7uICRU+r54phuyf2cps
        XnVB8SkIeD4anlTLRrnGZ0pBn9oVVIVKkOijgUI=
X-Google-Smtp-Source: ABdhPJxOFA7CF3GnIbaCJ+SwC9xkK1/MM7ZxVM95Kb5QzES3oiWSutJ7UnRusx7wiCvvxsfIO4Ibn3cINBD/9+Kpx4U=
X-Received: by 2002:a05:6602:58a:: with SMTP id v10mr6232382iox.203.1594751582187;
 Tue, 14 Jul 2020 11:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-2-amir73il@gmail.com>
 <20200714181804.GF324688@redhat.com>
In-Reply-To: <20200714181804.GF324688@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Jul 2020 21:32:51 +0300
Message-ID: <CAOQ4uxj_GMcWvSGSWkTQvKj2gPCP1=R9T-t=baDrH+V3Q1mPrQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: force read-only sb on failure to create index dir
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 9:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Jul 13, 2020 at 05:19:43PM +0300, Amir Goldstein wrote:
> > With index feature enabled, on failure to create index dir, overlay
> > is being mounted read-only.  However, we do not forbid user to remount
> > overlay read-write.  Fix that by setting ofs->workdir to NULL, which
> > prevents remount read-write.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> This patch does not apply for me. What branch you have generated it
> against. I am using 5.8-rc4.

It's from my ovl-fixes branch.

Sorry I did not notice that it depends on a previous patch that Miklos
just picked up:

"ovl: fix oops in ovl_indexdir_cleanup() with nfs_export=on"

Thanks,
Amir.
