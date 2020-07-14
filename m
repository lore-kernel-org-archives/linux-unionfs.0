Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD94CC433E1
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 15:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AACA32067D
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 15:20:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THoO/BlQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgGNPUW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 11:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNPUW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 11:20:22 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F9EC061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 08:20:21 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so17686498iob.4
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 08:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V1EZ+KYxnVS2t1/R/ex5fCaErMJMGYam1yYK8UTS6Kk=;
        b=THoO/BlQgQA4U2zfEMHoM2SdKstVIfvzM1/ysnVH8oTPXQ2LRh9L+M0EvUj19mSnAM
         91LVnhk4Wx/olHPlKu9ZNFW1k7VPRpmvrorBqtf5MF6QxuVMQFMynqqIGwvV+F65hhCx
         kqFAsPz5qTr8abu7JZCVuUJpAqbFA1cLQWHjRJ1/H7X4azn8AgNs+kUW3TkeIccocU9n
         u8GPrmBuJw/Fbryfl89xGN/i/zqxfO/aHnohsGMYnObCQH2X9s97HLb9JsHsMl6BPbg0
         +GfZfEMaoPRwUFXj2JxjkaUqI685UfloCQN3rI5Ga2DjhBfKJijgWXrH0+HBjxmJwwn7
         Eq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V1EZ+KYxnVS2t1/R/ex5fCaErMJMGYam1yYK8UTS6Kk=;
        b=d/7/lDHgCwy/x9an4VWWd4nIcRhsLfDDQQzLukIiBAgvLgaudjNZ6gdyRQwuyLGDa7
         +kP83l+zyQevhtpYwSVidnk45tNt5RJbAoYgnHdQ782xNaqhrlCx3onV6QW6Z16N8KBx
         hUH3A1EPUiWaUKZC4WFZJE05XqeOO7284LgGHcAiID4CyTC9LKNzFi+ufOrHnPPAUpX1
         lJei2akoKr6KgGvf5mZEVtnjl0MhgIlmfETFyR2KEOD9pZ5C2sl080IS4zkh80Mt59qc
         ADlASFqsTks4ERSvmOPQVYG9bIZJ7GvqCyeyFt3FQpPBqStqkdjIdQdzTKMHUnGYwqM1
         Wq5A==
X-Gm-Message-State: AOAM531rgElEPdN98Ytc0s5g/D1PPUKFOqMd+Ej4eIbXDIAyccFChXKS
        jpcVdnRI6MXkxJYiP6VAReSmfJ2+yVzhtNYk2Ow=
X-Google-Smtp-Source: ABdhPJytLnmf9p5asnJiPyb5+ES2btaMeXvxQjdgKO4IB/hNSftEYkyaxndZfkkyiDqMkWsOESXLFI543fqpGWl1akc=
X-Received: by 2002:a6b:ba03:: with SMTP id k3mr5378598iof.72.1594740021214;
 Tue, 14 Jul 2020 08:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200713141945.11719-1-amir73il@gmail.com> <20200713141945.11719-3-amir73il@gmail.com>
 <CAJfpegs46Mn_z_Gj9V_mE_nSvhkOySR7+R8m4_8Tv3g9F2TMSQ@mail.gmail.com>
 <CAOQ4uxj7MqtdRxX6CbJo6WhmqgT7yFA=1_QLDeiMZ-8Sqd-OXQ@mail.gmail.com> <CAJfpegtX=OXMM6CFcPddGFtO3w-guREfPisg9u63xSNLYRJ+uA@mail.gmail.com>
In-Reply-To: <CAJfpegtX=OXMM6CFcPddGFtO3w-guREfPisg9u63xSNLYRJ+uA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Jul 2020 18:20:10 +0300
Message-ID: <CAOQ4uxiHx7ei4rChQSM8ZBRDuwhbnSjrbZiur+xrcuMUbQ+zjA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: fix mount option checks for nfs_export with no upperdir
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 6:09 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, Jul 14, 2020 at 4:58 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Jul 14, 2020 at 5:52 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Mon, Jul 13, 2020 at 4:19 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > Without upperdir mount option, there is no index dir and the dependency
> > > > checks nfs_export => index for mount options parsing are incorrect.
> > > >
> > > > Allow the combination nfs_export=on,index=off with no upperdir and move
> > > > the check for dependency redirect_dir=nofollow for non-upper mount case
> > > > to mount options parsing.
> > >
> > > Okay, but does this combination make any sense?
> >
> > Do you mean configuration of non-upper exported to NFS?
> > Why not? Anyway, we allowed it and regressed it.
>
> Ah, right.  I was confused and thought we'd want to allow
> nfs_eport=on,index=on with no upper dir.  But that's nonsense
> obviously.
>

Heh no.
FYI, I got to this because working on the configuration:
ro,upperdir=...,nfs_eport=on,index=off

for snapshot, since it's a (forced) read-only mount, even though it
has an upperdir and copy ups, it has no upper rename/unlink, so there is
no need for an index to follow from lower to upper nor to follow redirect
from upper to lower.

Thanks,
Amir.
