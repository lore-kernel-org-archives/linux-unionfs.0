Return-Path: <SRS0=U5BQ=4F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAB9C34022
	for <linux-unionfs@archiver.kernel.org>; Mon, 17 Feb 2020 15:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D099224649
	for <linux-unionfs@archiver.kernel.org>; Mon, 17 Feb 2020 15:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgBQPoa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 10:44:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47729 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbgBQPoa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Feb 2020 10:44:30 -0500
Received: from mail-ua1-f70.google.com ([209.85.222.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <mauricio.oliveira@canonical.com>)
        id 1j3iZQ-0000cy-HF
        for linux-unionfs@vger.kernel.org; Mon, 17 Feb 2020 15:44:28 +0000
Received: by mail-ua1-f70.google.com with SMTP id k24so3465968uag.18
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Feb 2020 07:44:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvNlQZqpY5uOm9Np4VEcXvFnLc3xFEPudEInjapFAlY=;
        b=GMvUhiphRsNs8opNUt6WYgfjMN34azqdAnCHXmg0cjwIwdqfaCUygaqe9YiUejYgNz
         BCNJ5h4LBzHh8AOynbEh1wXhwEZujSTiVXOgXXNm/0fIrDv1R8zkDuGkheMqHC/d5XXm
         ZMjd9bla3WoW3o0vJJ19mZznD2r6afqXlHSWnCcis10s3dslrcfASx8QfNv8chYbix08
         dwfE5zfP8A8y6wZYs8IsfqzkXGra5iAY5lRFpIkits80EmzJDKV8tHynUukS+NU9iSM+
         kkEI9YyztATqbM8koZ/opZW2Rs0bDzGhZgJYqLwwfT5SQqDKAmRs4EA+QpEuMF3L4XRs
         S7iw==
X-Gm-Message-State: APjAAAV8DVxIdPXmgL0HgyOOXCd2kraEsIMLgVM2TtaJ4WAWZ7o782Gi
        fXI2r1hpIYNCpoeFeSmyoL93qrbieFcUtzcuUUmZ3e203HkmpHsSmEDShrRwATwQCiq4mWt+6q5
        ytvwf0Hs3w5sp5pDL73kRjzDDXxPISMRi3zHj0cPJhYttXozuaCxVq/ku3ZI=
X-Received: by 2002:a05:6102:219:: with SMTP id z25mr8289146vsp.79.1581954267658;
        Mon, 17 Feb 2020 07:44:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqz50UZb7AH+OvTNarT/0hI6TofLWcbHshMMfurFolNpZY+QzHbapX0j1xDy8dvwXcSutVLkUeLFPNoDMchbuIg=
X-Received: by 2002:a05:6102:219:: with SMTP id z25mr8289128vsp.79.1581954267404;
 Mon, 17 Feb 2020 07:44:27 -0800 (PST)
MIME-Version: 1.0
References: <20200214151848.8328-1-mfo@canonical.com> <CAOQ4uxjGdBtzmd=anCbuKo23wMWTu8Ja36-qgGomGy7RSMJ0sg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjGdBtzmd=anCbuKo23wMWTu8Ja36-qgGomGy7RSMJ0sg@mail.gmail.com>
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
Date:   Mon, 17 Feb 2020 12:44:15 -0300
Message-ID: <CAO9xwp2Z6eF8xnkyh9rsTzCjGJNgZ2ogrLxqzosgjq3YRWeb2w@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fstests: overlay: initial support for aufs and
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Feb 14, 2020 at 3:45 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> +CC: <linux-unionfs@vger.kernel.org>
>
> On Fri, Feb 14, 2020 at 5:18 PM Mauricio Faria de Oliveira
> <mfo@canonical.com> wrote:
> >
> > This patchset allows the existing support for overlay to be used with
> > aufs and fuse-overlayfs, so the increase the coverage/test tools that
> > are available for these filesystems.
> >
> > Initial numbers on v5.4-based Ubuntu kernel on Ubuntu Eoan/19.10
> > (fuse-overlay installed from distro package), few tests excluded:
> >
> >  OVL_FSTYP=aufs
> >  - Ran: 645 tests
> >  - Not run: 483 tests
> >  - Failures: 22 tests
> >
> >  OVL_FSTYP=fuse.fuse-overlayfs
> >  - Ran: 530
> >  - Not run: 395
> >  - Failures: 29
> >
>
> It'd be interesting to know the baseline - what are those numbers for
> OVL_FSTYP=overlay with same kernel?
>

Oh, indeed.
Here's the numbers for the 3 filesystems again (re-runs as I noticed
some tests skipped in fuse-overlayfs previously.)

OVL_FSTYP=overlay (unset/default)
- Ran: 654
- Not run: 391
- Failures: 5

OVL_FSTYP=fuse.fuse-overlayfs
- Ran: 653
- Not run: 472
- Failures: 54

OVL_FSTYP=aufs
- Ran: 645
- Not run: 483
- Failures: 22

BTW, thanks for reviewing/commenting on the individual patches.

I'll review them in more detail, and think I can send out a v3 next week.

cheers,
Mauricio


> Thanks,
> Amir.
>
> > Thanks to Amir Goldstein for review/improvements/suggestions.
> >
> > Changes:
> >  - v2:
> >    - fix tests/overlay that hardcode the overlay fs type
> >    - add support to fuse-overlayfs with +3 other patches
> >  - v1:
> >    - [PATCH] common/overlay,rc: introduce OVL_ALT_FSTYP for testing aufs
> >
> > Mauricio Faria de Oliveira (5):
> >   common/overlay,rc,config: introduce OVL_FSTYP variable and aufs
> >   tests/overlay: mount: replace overlay hardcode with OVL_FSTYP variable
> >   common/rc: introduce new helper function _fs_type_dev_dir()
> >   common/rc: add quirks for fuse-overlayfs device/mount point
> >   common/overlay: silence some mount messages for fuse-overlayfs
> >
> >  README.overlay    |  5 ++++
> >  common/config     |  2 ++
> >  common/overlay    | 29 +++++++++++++++++++---
> >  common/rc         | 61 ++++++++++++++++++++++++++++++++++++++++-------
> >  tests/overlay/011 |  2 +-
> >  tests/overlay/035 |  2 +-
> >  tests/overlay/052 |  4 ++--
> >  tests/overlay/053 |  4 ++--
> >  tests/overlay/062 |  2 +-
> >  9 files changed, 92 insertions(+), 19 deletions(-)
> >
> > --
> > 2.20.1
> >



--
Mauricio Faria de Oliveira
