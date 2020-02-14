Return-Path: <SRS0=3MWK=4C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FA7C2BA83
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B74D9222C2
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:45:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WexSahva"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389746AbgBNSpZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:45:25 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:34756 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389723AbgBNSpZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Feb 2020 13:45:25 -0500
Received: by mail-il1-f195.google.com with SMTP id l4so8914422ilj.1;
        Fri, 14 Feb 2020 10:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ujLZ//Mw6vtAjFLcWjyIUHYK6uJak5XPcS0/tv4WkGY=;
        b=WexSahva98CfswF0q/JWX+SFIgttENQENTSOqxMFmfVdqh6Zc+mz9Yl9GcC40Z4ywq
         G9WeUKklsFeFVdbvEJ/XpZWLzrU499V+gVQSyywCigzypa78O2yjRX+cPOzf295sGt2D
         n1CpfBBLUXrteki1icteEtctyoIFYm53ADmye4pC0wD6vXVs2VWemyxq7XN9BMmxHx0s
         cjgZB4VFF/lFx66L/33idNyDiIwcg19mQcax9f2VEw8O50uUft/68T3lmfzL7i3zwmln
         rU+gNWRP+wA3i92E7rhRkBUv3DTxaPRcR6szJaMUFuingUfzFpUNMX4+zK8IOimqmyYB
         772A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ujLZ//Mw6vtAjFLcWjyIUHYK6uJak5XPcS0/tv4WkGY=;
        b=PJCrRSCQu9l7Utpyzc4lLpD0qtp4/sGGsrFNvZnYJRPpZ1H+QUmmhIxcZ6tlqMtbSx
         pAWATua5wS7BPei2K+oZ735CnMFilCCKpqaV/FWlgH3iXCC2PJLrKJj4OC0ru1xxiA4F
         UIsXFbmdJBuCvO1XRdjOlabA/i4qj65GL5Vxv5488pFtt+lvrR8UWFEKkpf1GreuCD2g
         hbqgxV2+HXZOiRiaOvSc5S0p/xQQs4uJb28LyrNWAH5q5i80R6iecg9Iuqgd1Hzgz2tp
         h2JE0p9fCRi5pZTq7Zw79U4UWKmcr8714mGSS0jueZ6ROg4Ywq61ScOyqCi40b7xLUxn
         0RaQ==
X-Gm-Message-State: APjAAAUTZO8t/fhsKd4g8+82QknpBPaTpDRO5zZusa4a/+EuliFk5E+l
        +BmReypRyzPRbseVy6cHwU0n0rba+/REJRScIKpvWs8h9nE=
X-Google-Smtp-Source: APXvYqwZOoj7uz+HGZX4MVZbuAVWhm0csKWg0ZAO7KM5cKu3MpIfR0KEBYBMCocltnOsaXxCP21GNbjY99w+/D97RjQ=
X-Received: by 2002:a92:5c8a:: with SMTP id d10mr4496735ilg.137.1581705924496;
 Fri, 14 Feb 2020 10:45:24 -0800 (PST)
MIME-Version: 1.0
References: <20200214151848.8328-1-mfo@canonical.com>
In-Reply-To: <20200214151848.8328-1-mfo@canonical.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 14 Feb 2020 20:45:13 +0200
Message-ID: <CAOQ4uxjGdBtzmd=anCbuKo23wMWTu8Ja36-qgGomGy7RSMJ0sg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fstests: overlay: initial support for aufs and
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
Cc:     fstests <fstests@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

+CC: <linux-unionfs@vger.kernel.org>

On Fri, Feb 14, 2020 at 5:18 PM Mauricio Faria de Oliveira
<mfo@canonical.com> wrote:
>
> This patchset allows the existing support for overlay to be used with
> aufs and fuse-overlayfs, so the increase the coverage/test tools that
> are available for these filesystems.
>
> Initial numbers on v5.4-based Ubuntu kernel on Ubuntu Eoan/19.10
> (fuse-overlay installed from distro package), few tests excluded:
>
>  OVL_FSTYP=aufs
>  - Ran: 645 tests
>  - Not run: 483 tests
>  - Failures: 22 tests
>
>  OVL_FSTYP=fuse.fuse-overlayfs
>  - Ran: 530
>  - Not run: 395
>  - Failures: 29
>

It'd be interesting to know the baseline - what are those numbers for
OVL_FSTYP=overlay with same kernel?

Thanks,
Amir.

> Thanks to Amir Goldstein for review/improvements/suggestions.
>
> Changes:
>  - v2:
>    - fix tests/overlay that hardcode the overlay fs type
>    - add support to fuse-overlayfs with +3 other patches
>  - v1:
>    - [PATCH] common/overlay,rc: introduce OVL_ALT_FSTYP for testing aufs
>
> Mauricio Faria de Oliveira (5):
>   common/overlay,rc,config: introduce OVL_FSTYP variable and aufs
>   tests/overlay: mount: replace overlay hardcode with OVL_FSTYP variable
>   common/rc: introduce new helper function _fs_type_dev_dir()
>   common/rc: add quirks for fuse-overlayfs device/mount point
>   common/overlay: silence some mount messages for fuse-overlayfs
>
>  README.overlay    |  5 ++++
>  common/config     |  2 ++
>  common/overlay    | 29 +++++++++++++++++++---
>  common/rc         | 61 ++++++++++++++++++++++++++++++++++++++++-------
>  tests/overlay/011 |  2 +-
>  tests/overlay/035 |  2 +-
>  tests/overlay/052 |  4 ++--
>  tests/overlay/053 |  4 ++--
>  tests/overlay/062 |  2 +-
>  9 files changed, 92 insertions(+), 19 deletions(-)
>
> --
> 2.20.1
>
