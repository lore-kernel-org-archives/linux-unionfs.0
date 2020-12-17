Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1AAC4361B
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 19:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A303F22D72
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Dec 2020 19:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgLQTrd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 14:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbgLQTrd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Dec 2020 14:47:33 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3475C061794
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 11:46:52 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id d20so10589412otl.3
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Dec 2020 11:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JSHBznY61nzbcvETgxTC+sNW3vNQ48NZaRcwJrg1O5k=;
        b=q+sTALB90lys+NnVwsPsY582qJIKPuiiHXXVXeRVg+lW3QY0NMaiYdBw82tNXTp/O0
         U46+0Ve3DcxXbGDnjIkFiSiTebDz0xZujRxzpEZjHaDAWjxeR+Nagre5p4UOwBMutHLE
         KA2t2rdrKBsNPluoAqoL/5hhY6uXREeWumb9kU8SnQNou6APWqDR5uGuaO68ykzReYnd
         Asu7A0+PLz45ULPkPILqJvPm3BfVcz77qIXbrluv1tkPYEh207E4BGG91wJAurmdAn5a
         gQ4DMqfrJ2jX6EdxzyoAeB2GsSA5XiLEs5NvX+N4hfkYu/obml8YJU1/UCPPif6upAY8
         IvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JSHBznY61nzbcvETgxTC+sNW3vNQ48NZaRcwJrg1O5k=;
        b=VzUlk2EwAagVkqO+stRVihFvEJ3aUAw6hi+HpnDjcaqNzyKAmV+0mULwVAi1oZqG+Q
         qSiljjF1rjxU2EW3LnX79TmTZeSWuN7asWtFYPhYkAvXbYcQFAvwBF1Ulzaz3+lccu3V
         HehQlSYQPyx/RLYnaapCqB09qsH3xIa1pzNemNwCG6VOTt0uTH2MOIjxF/KW7IORfCcg
         KyilLNW0vEoNn4OXY58xcvw/D1WHBaGa8w3gGKgokVG2bqs7OdQUeU+NwIhUUifrVK8T
         KHRJQUP9e6l4DBajjKyVjoaUPFRpwH5YY5EIekJ5wNZnfDiqlNEZ0601Hv7f/urpfbd2
         Z3VQ==
X-Gm-Message-State: AOAM5325lYdpPgGU4uOSW9jv1kEcH/ME2balA8Ao9MTvOo4+F9RFdglg
        dREu0yDuV20oVzGFnws4chq1sq8oWTo52c+RrCZgF4sEkFEKWA==
X-Google-Smtp-Source: ABdhPJwxXJ1CZml5Qctz9ZTszUb8FjP0VISlafAHCJXqosKvVhCmexzXx1rNJ07HzKiOZ3a2qFHgzJkG6WWSAlW9MYQ=
X-Received: by 2002:a05:6830:23bb:: with SMTP id m27mr416530ots.198.1608234411909;
 Thu, 17 Dec 2020 11:46:51 -0800 (PST)
MIME-Version: 1.0
References: <2nv9d47zt7.fsf@aldarion.sourceruckus.org> <2n1rfrf5l0.fsf@aldarion.sourceruckus.org>
 <CAOQ4uxg4hmtGXg6dNghjfVpfiJFj6nauzqTgZucwSJAJq1Z3Eg@mail.gmail.com>
 <CAOQxz3wW8QF-+HFL1gcgH+nVvySN3fogop0v+KNcxpbzu9BkJA@mail.gmail.com>
 <CAOQ4uxgsFnkUqnXYyMNdZU=s_Wq18fdbr0ZhepNLMYh9MfPe9w@mail.gmail.com>
 <CAOQxz3wUvi_O7hzNrN8oTGfnFz-PiVr3Z6nG1ZXLFjpnH4q81g@mail.gmail.com>
 <CAOQxz3zGaKnJCUe7DuegOqbbPAvNj8hTFA6_LsGEPTMXwUpn6g@mail.gmail.com>
 <CAOQ4uxifSf-q1fXC_zxOpqR8GDX8sr2CWPsXrJ6e0YSrfB6v8Q@mail.gmail.com>
 <CAOQxz3xZWCdF=7AZ=N0ajcN8FVjzU2sS_SpxzwRFyHGvwc7dZA@mail.gmail.com> <CAOQ4uxjmUY+N6sBoD-d2MN4eehPCcWzBXTHkDqAcCVtkpbG2kw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjmUY+N6sBoD-d2MN4eehPCcWzBXTHkDqAcCVtkpbG2kw@mail.gmail.com>
From:   Michael Labriola <michael.d.labriola@gmail.com>
Date:   Thu, 17 Dec 2020 14:46:38 -0500
Message-ID: <CAOQxz3y8N6ny23iA1Fe0L4M1gR=FHP5xANZXquu4NSLoucorKw@mail.gmail.com>
Subject: Re: failed open: No data available
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Dec 17, 2020 at 1:07 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Dec 17, 2020 at 6:22 PM Michael Labriola
*snip*
> > On Thu, Dec 17, 2020 at 7:00 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > Thanks, Amir.  I didn't have CONFIG_DYNAMIC_DEBUG enabled, so
>
> I honestly don't expect to find much in the existing overlay debug prints
> but you never know..
> I suspect you will have to add debug prints to find the problem.

Ok, here goes.  I had to setup a new virtual machine that doesn't use
overlayfs for its root filesystem because turning on dynamic debug
gave way too much output for a nice controlled test.  It's exhibiting
the same behavior as my previous tests (5.8 good, 5.9 bad).  The is
with a freshly compiled 5.9.15 w/ CONFIG_OVERLAY_FS_XINO_AUTO turned
off and CONFIG_DYNAMIC_DEBUG turned on.  Here's what we get:

 echo "file fs/overlayfs/*  +p" > /sys/kernel/debug/dynamic_debug/control
 mount borky2.sqsh t
 mount -t tmpfs tmp tt
 mkdir -p tt/upper/{upper,work}
 mount -t overlay -o \
    lowerdir=t,upperdir=tt/upper/upper,workdir=tt/upper/work blarg ttt
[  164.505193] overlayfs: mkdir(work/work, 040000) = 0
[  164.505204] overlayfs: tmpfile(work/work, 0100000) = 0
[  164.505209] overlayfs: create(work/#3, 0100000) = 0
[  164.505210] overlayfs: rename(work/#3, work/#4, 0x4)
[  164.505216] overlayfs: unlink(work/#3) = 0
[  164.505217] overlayfs: unlink(work/#4) = 0
[  164.505221] overlayfs: setxattr(work/work,
"trusted.overlay.opaque", "0", 1, 0x0) = 0

 touch ttt/FOO
touch: cannot touch 'ttt/FOO': No data available
[  191.919498] overlayfs: setxattr(upper/upper,
"trusted.overlay.impure", "y", 1, 0x0) = 0
[  191.919523] overlayfs: tmpfile(work/work, 0100644) = 0
[  191.919788] overlayfs: tmpfile(work/work, 0100644) = 0

That give you any hints?  I'll start reading through the overlayfs
code.  I've never actually looked at it, so I'll be planting printk
calls at random.  ;-)

-- 
Michael D Labriola
21 Rip Van Winkle Cir
Warwick, RI 02886
401-316-9844 (cell)
