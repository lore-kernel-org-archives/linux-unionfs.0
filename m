Return-Path: <SRS0=wxOy=BA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB71C433E3
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Jul 2020 13:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30EE20578
	for <linux-unionfs@archiver.kernel.org>; Tue, 21 Jul 2020 13:44:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rVN061AU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgGUNow (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 09:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgGUNow (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Jul 2020 09:44:52 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE90BC061794
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Jul 2020 06:44:51 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y2so21439930ioy.3
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Jul 2020 06:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/N13S84dF++zFF4g0IGr1Xz2sV8c4eQI9qVDznGqWOg=;
        b=rVN061AUCtaJAP8zPWApeh0ZESKUKzs0nFswydo31SjBZalTkjYeU7FqCopYzR5GLR
         2SZNbiy6navKnUgczKtcrGgZazenURKhOak+O++DaQHWlJPVMrjzd1g/6UCvSO8uUteA
         eQC/Edx4yzu867+5BLqrriGCn3z1KEBqxEL9uz0xkOoD7M+Cq5+3ZtAUkSLaGh3BH9tv
         yRsQINxiQkCcAhmpWhUgVDU5d7RRFYHFrVs4zRGLANWHjaMgzSseLrYwYasIigfEFi62
         80lWvqgIE8f5IqGuWE7M8YBqr7ShvwAfjpDhDhxbbo6LYQQeHF8TyOE2rP/gSWiJFujl
         +DxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/N13S84dF++zFF4g0IGr1Xz2sV8c4eQI9qVDznGqWOg=;
        b=iWV94Oi0qEnlT9z/X9uDGeOYpIcPGmhlvdEFD4BpyXI+15rzawAM8kiQYEJ1px1hQ7
         Icy3jOe9TOm9GNV6udCAU69MbOVFV+vOoMiCj0tUhDjwuJhuo5NSbmlKwxkjgEgZqPO7
         Rab3txlA518IIMMVzoXdHlv1iuZf2lQPR0HoZKLMHpqyHQ7ZD7T+ii0RYxF7SmVOC6YC
         q0z3c2jEFmvYMwN48k3LK1pW5kvjwHLO1SJu9OkJpYJ1WQk2WbnxUTLKQ8Kam3fR1mj3
         dlXfjLRM7GPuOKeQ8MVSs8yGA74n5DsMFJYdMe4uGn5tQh2RG3toYOnP6jjFZ3aJGOWY
         4YHQ==
X-Gm-Message-State: AOAM533M7oPjCX2Fx398gUJdpDWSVX+Do1KKg1BLP+HD/5jzz961cKzj
        fvgQm6amxUVQevT+KgJgw847iylvWHcTuso8zmM=
X-Google-Smtp-Source: ABdhPJwh1qDY7OGaE5p6rP0rOj2msZfNbA76eEuXm9gwy9o417j5JHR4mxIQM8sFwxMsobTR93o54iPwjczf2g+sK4A=
X-Received: by 2002:a5e:8b04:: with SMTP id g4mr4989529iok.203.1595339091275;
 Tue, 21 Jul 2020 06:44:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200706161227.GB3107@redhat.com> <CAJfpegtBjv60ZYJYSgQfU9EFx+eMbjqzcZ1HFV8P2nL64x5D2A@mail.gmail.com>
 <20200720161618.GD502563@redhat.com> <CAJfpegt2k=r6TRok57tKPcLyUhCBOcBAV7bgLSPrQYXsPoPkpQ@mail.gmail.com>
In-Reply-To: <CAJfpegt2k=r6TRok57tKPcLyUhCBOcBAV7bgLSPrQYXsPoPkpQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 21 Jul 2020 16:44:39 +0300
Message-ID: <CAOQ4uxi=wp-3=+cJ1Cfmx2qr_y=AB0cMQM-hW-G02TJZCa=WUQ@mail.gmail.com>
Subject: Re: [PATCH v4] overlayfs: Provide mount options sync=off/fs to skip sync
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>, pmatilai@redhat.com,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 21, 2020 at 4:16 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Jul 20, 2020 at 6:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> > For building images containers folks need to sync upper layer. Their
> > current plan is to use "syncfs upper/" because it is same as if overlay
> > was mounted with sync=fs. But this syncs whole upper filesystem and
> > not just upper of a particular overlayfs instance
> >
> > So idea was to provide sync=fs from the beginning and ask container
> > folks to use this. So that in future if we can optimize sync=fs to
> > sync selctive inodes, then container runtime will automatically
> > benefit from it without any changes. It also reduces the chances
> > of error on container runtime which fail to sync upper.  Hence idea
> > of sync=fs sounded appleaing to me.
>
> Not sure I understand the reason for sync=fs?  Should it rather be
> sync=shutdown?
>

Sounds good to me.

> >
> > Havid said that, I am open to dropping sync=fs for now, if you don't
> > see the value at this point of time.
>
> At this point it doesn't add any usefulness, so let's just drop it.
>
> > >
> > > Naming: I'm not at all convinced by any name having "sync" in it.  I
> > > think "sync=no" is about the implementation, not the functionality,
> > > and so it's confusing. The functionality is better described by
> > > "volatile" or "temporary".   But I can live with sync=... if voted
> > > down.
> >
> > I am fine with the name "volatile/temporary" for sync=off.
>
> How about needing "volatile" for all kinds of modes that reduce the
> normal durability/integrity guarantees.  Then additional "sync=foobar"
> option to control the details?
>

Fine by me.

Thanks,
Amir.
