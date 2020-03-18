Return-Path: <SRS0=i+Vd=5D=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA5CC5ACD6
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Mar 2020 12:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2A720767
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Mar 2020 12:33:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GnAQFVxS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgCRMdo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 08:33:44 -0400
Received: from mail-il1-f169.google.com ([209.85.166.169]:34113 "EHLO
        mail-il1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgCRMdn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Mar 2020 08:33:43 -0400
Received: by mail-il1-f169.google.com with SMTP id c8so23509261ilm.1
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Mar 2020 05:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mGFF3i+WLQMQgRGTonNVpusjmRqhPUEEKKQyxV5O0u0=;
        b=GnAQFVxSQzK7I7LMV/Hh5IsRcUF5qAMC40EA6t6mXSOwQV7Zke4mmdTvZ2rMa0zeZu
         uw3CZV0tY/qxt3K7TR+TEmb4UcuVrM1Lxnp20QFpQYE/9j7tDF336VAVlt84yd1aefyp
         n0H5WzAfiNpYvB07g9f13SKU5lctKpOmZHhK4KLR1v1pHIFwqHjt3sYuk6QeY5lDEVW/
         yh8N0QD2hKuC+kAQACyo8XREXUfdK+fNmg/wy8vDS5QH0Zg2QRqnrabmfgCINyh1710G
         je9aDXmBdruNbsNfO9RkOZ+VCWzGAYueaQ1e1FYmqOaqaaTCHRVNgTLbDsErasYJedGr
         8upA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mGFF3i+WLQMQgRGTonNVpusjmRqhPUEEKKQyxV5O0u0=;
        b=rpxRNCJZy17bIezs/lGz+IWyazw0P35AKbQlWw8qT9Gu7Nd3odhGyHyZvSQfXaoe2k
         yxQPYeZ3r/t7hUdhh36/D+AecNLwpCZ3Q5C/HnqjSbA96hseb8vbFaJOmvoQDBLhLX0i
         SfmAgKIa4xzD4IaShuLfFgxTtKLeu7bPERMY+c+36sZ+ncVaEU/FzsSLPIzW2Q1wC4Hf
         Q1SK3wYicg3yUTKPfE8oaxYdLGKdXnJgdeDY0XLWIObVy1VDcOwnh7/c3siU/SdNP4D6
         gEdAUTSisHGQ67mm3zVcCffMTBWLXcjU+pk+1KbDZUlswe2arzZQC7u1rSBFTMocBYbD
         5s4g==
X-Gm-Message-State: ANhLgQ3Vw0Jm8cCBn2l/eFxlDoEiSYFOGU28qa44EW6OTvO5sU2K6tD/
        b/P4zAbqbxik+27Mo3hteGalLu2v1BxGNMv8VOuQA7Zd
X-Google-Smtp-Source: ADFU+vuVc+sFpkg/lqbCc2CDX8wpZZjZvfHhYL1GNol9BpzNVA5K96SOGyntthpQDd1aeVDE2tYUyqTGRcJZ4VvaDk0=
X-Received: by 2002:a92:9f1a:: with SMTP id u26mr3802676ili.72.1584534821019;
 Wed, 18 Mar 2020 05:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxjryJep94sLgVxV7sGab8K3yeeDUZwOYOfLtOOguW1pcA@mail.gmail.com>
 <CAOQ4uxiHKjNba8HD5JUWFxxJqyJxPMk3fFfA3fi-nO6uJngTAg@mail.gmail.com> <CAOQ4uxhBBnr5zFOn1Dr-XtDSo=p3BovyhK6xZh22GA=dv1L8Bw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhBBnr5zFOn1Dr-XtDSo=p3BovyhK6xZh22GA=dv1L8Bw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 18 Mar 2020 14:33:30 +0200
Message-ID: <CAOQ4uxiKdxujdKNWBRNxtvCrq5TDJuhoW5Oede0Hu1myoKfeEQ@mail.gmail.com>
Subject: [ANNOUNCE] unionmount-testsuite: master branch updated to dc24a45
To:     overlayfs <linux-unionfs@vger.kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi All,

The master branch on the unionmount-testsuite tree [1] has been updated.

Changes in this update:
- Align with v5.6-rc1 overlayfs code

The previous release of unionmount-testsuite (1724ef2) exposed a kernel
v4.17 regression:

 ./run --ov=1 --verify hard-link
 ...
 /mnt/a/no_foo110: File unexpectedly on upper layer

This kernel regression was fixed in v5.6-rc1 by commit  b7bf9908e17c
("ovl: fix corner case of non-constant st_dev;st_ino").
This release of unionmount-testsuite adapts the layer checks to the fixed
logic of v5.6-rc1.

The regression test above still fails on kernel v5.5, but with a
different error:
 ./run --ov=1 --verify hard-link
 ...
 /mnt/a/no_foo110: inode number/layer changed on copy up (got
34:434190, was 34:430077)


Thanks,
Amir.

[1] https://github.com/amir73il/unionmount-testsuite

The head of the master branch is commit:

dc24a45 Update layer check with pseudo st_dev for upper layer

New commits:

Amir Goldstein (1):
  Update layer check with pseudo st_dev for upper layer
