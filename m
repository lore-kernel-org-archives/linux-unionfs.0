Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F23C433E7
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF363223B0
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:58:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oEHXG272"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgGNO6N (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgGNO6N (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 10:58:13 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA80C061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:58:12 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id p205so9029817iod.8
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pEtilVuPAA1S1kpb1ipGGxjfvIEasM3rp6KiRMbNQP8=;
        b=oEHXG272jX7vv67PjsPc19Fs0Flh3CC3ZUKI5TNiAWje58EX4VeTmaomN0nlIgHUTc
         QNEbwj721bCyJqgL5R9/VGjRXPt1o0VzUGHFiqoO2xgFR3qg2/jIQpTokpf7b0UDeFYL
         e4qciTCMSs6SMrRnUn0lr3t5itac0jHjIP44BCgxLVNaINV6tToJghvgL6Y1ZeKLnxoF
         ixllrjfZ2AlUYJpPR9o7mcGaSdWf2uLO5vEdqaEm+YUSqb0QAM1weEURL+aPGawz/OYG
         qKJMXhshGaI1noyM6AXKo6YQl0O63NNQgeR56Hyrq0X059yJvJpPxPKQBUj4ZtUo+aLn
         LznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pEtilVuPAA1S1kpb1ipGGxjfvIEasM3rp6KiRMbNQP8=;
        b=buH4dS4xA3dPHWI1lYHFxAETp6Zw/Bh7acIsZ8803nrDZLQW5DdsAUJfbvVnxGFwxq
         BDmW2nUycCCkl0Byj/GBt+jLGnLeioZxfl78rk1EJQFqD/Wui/oMBoRKT5Y9qWre1a/A
         U5bYTSZijRoCglXRvzWAJD1kKQfcTFu6KRCvgrYb/LAKqU/o0+UoaZxm53GqAT+CMHcS
         QRctfelEolGDYYWyAXyTlPpxkO9pQuqaDeRiCzYgaVGzZBORVNpsmypwQmKpyXaCPftG
         ObM3QTyPjLe4PJRthJC2QwbsRJ6W7RxfhoPIJUABUph4BlxiLvMngeLu0Qclm9dZzV6X
         ceTQ==
X-Gm-Message-State: AOAM530a6WciiwscexrgfsNQxLzY93Tc1iGr2oF2A5CFG8pQ3PFhZlIg
        yXWDV8xg3h9UYUHNFOvMrtMiHKlDG+8tATWI0lo=
X-Google-Smtp-Source: ABdhPJygAwlby7P9axMWJsoWjL4otB9ljT+4KgQSrymPDTun/Kf6mtGn59PflvnnKGR0eZIBR7zGWbdGfneScSRPvAs=
X-Received: by 2002:a05:6602:58a:: with SMTP id v10mr5271029iox.203.1594738692207;
 Tue, 14 Jul 2020 07:58:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-3-amir73il@gmail.com>
 <CAJfpegs46Mn_z_Gj9V_mE_nSvhkOySR7+R8m4_8Tv3g9F2TMSQ@mail.gmail.com>
In-Reply-To: <CAJfpegs46Mn_z_Gj9V_mE_nSvhkOySR7+R8m4_8Tv3g9F2TMSQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Jul 2020 17:58:00 +0300
Message-ID: <CAOQ4uxj7MqtdRxX6CbJo6WhmqgT7yFA=1_QLDeiMZ-8Sqd-OXQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: fix mount option checks for nfs_export with no upperdir
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 5:52 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Jul 13, 2020 at 4:19 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Without upperdir mount option, there is no index dir and the dependency
> > checks nfs_export => index for mount options parsing are incorrect.
> >
> > Allow the combination nfs_export=on,index=off with no upperdir and move
> > the check for dependency redirect_dir=nofollow for non-upper mount case
> > to mount options parsing.
>
> Okay, but does this combination make any sense?

Do you mean configuration of non-upper exported to NFS?
Why not? Anyway, we allowed it and regressed it.

Thanks,
Amir.
