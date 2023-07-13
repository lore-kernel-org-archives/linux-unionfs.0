Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9616CC001DD
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Jul 2023 16:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjGMQPb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 12:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjGMQPb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2023 12:15:31 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E09E26B2;
        Thu, 13 Jul 2023 09:15:29 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id ada2fe7eead31-440ad576d87so378724137.1;
        Thu, 13 Jul 2023 09:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689264929; x=1691856929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAzbOQIDfQaaRF2mNdJO7AZIHFfzQ6Xj8bCSW7+ay68=;
        b=sAlmlEhoIXTNcfzulXTg/0+qeYpkt9g8tAxc74oaiVDRwKPmUMTSAmQaYtuHD640rY
         oeL+gxRNkd41KADYLcPJJt0uQhY5fEFIQYD1ogc6TvKlVzT1WtF+vaTiXbJUMLwd2/T2
         6/yZuy/0Eg/sqaG/SfVpZJQHRGO0GNAJGR8UuNvN7QoVAPdD9BSxPdcnlMNy0KK1Ae73
         nKwcDG6IY2F2i5k+zosDixDFZJfTru11CTAyZUQRKO4xxy9lNysRhJ8KlsF8DKKzPlPf
         g6+k9V4Y5Fcbpxxm4evYLcx9dAULeT+PywlIig2lAFgIaUmThh3LEEPfRzlX7WccIe2S
         S5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689264929; x=1691856929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qAzbOQIDfQaaRF2mNdJO7AZIHFfzQ6Xj8bCSW7+ay68=;
        b=R6e459rNx1fZBo9RsTYdko+XqqyxdXfIEbzGAQ5+Jn7GZNpRU+yrRIq98mj++WxiJ9
         NTP49vjUd3VBObm4EOo74n7J2rpqHzG0+Ym0ufjh2FKWXSjLJzZ9wWC2FfUzWTQRNPx0
         v2v0nAdJiVoOf/u7lp0TpVHbSbheeGMDieFASt+6ScePUjbtRNvuKg80u/EvzUBYblKO
         cJ5szikpHMjq0hQJu3kAyQ/Xggsf0nzamroX3o9WhuvWbcNwAyzJl2+NrjFvmIqtXOXF
         GM+/RBW3quu5iTGwsd4ob2evZzSBf8eCej2cctFNdYMe7I9zFEEh1fBaFSgA1yWwtaLs
         mVlw==
X-Gm-Message-State: ABy/qLZ1hh5mLOJ++N8JO3T9RUNaUOiy/cvbNhixNpc5SchRGqag8eVS
        PbIi8eB8PXPkKPQp50WnMxlzUCQlmNUf1Zp+YENedFTu
X-Google-Smtp-Source: APBJJlE7UaE0SChJN8jYw51pleDWarGr3Jg541dTzlfDtByVh4Sk4Gzt3lQCG3c6HsLmEbwVzVTIXaIKeTmVHjAyWx8=
X-Received: by 2002:a67:f7c7:0:b0:443:664f:f15 with SMTP id
 a7-20020a67f7c7000000b00443664f0f15mr1515226vsp.5.1689264928844; Thu, 13 Jul
 2023 09:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1688979643.git.alexl@redhat.com> <20230713153457.5723wtjidhvlxfyz@zlang-mailbox>
In-Reply-To: <20230713153457.5723wtjidhvlxfyz@zlang-mailbox>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 13 Jul 2023 19:15:17 +0300
Message-ID: <CAOQ4uxhdn=e-k=K7cCWbuaA4nPVnWrAwqKH+mTdRDaTKQhUp+A@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] overlayfs: Test data-only upperdirs and fs-verity
To:     Zorro Lang <zlang@redhat.com>
Cc:     alexl@redhat.com, fstests@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 13, 2023 at 6:35=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Mon, Jul 10, 2023 at 11:07:09AM +0200, alexl@redhat.com wrote:
> > From: Alexander Larsson <alexl@redhat.com>
> >
> > This adds support for testing the new data-only upperdir feature which =
is
> > currently in master and will be in 6.5-rc1. It also adds tests for the
> > fs-verity validation feature which is queued in overlayfs-next for 6.6.
> >
> > All new tests check for the required features before running, so
> > having it in early will be nice for testers of linux-next.
> >
> > Changes since v1:
> >  * Consistently use $fstyp and $scratch_mnt in _require_scratch_verity
> >    (Pointed out by Eric Biggers)
> >  * Added Signed-off-by to patches from Amir
> >
> > Alexander Larsson (1):
> >   overlay: Add test coverage for fs-verity support
> >
> > Amir Goldstein (3):
> >   overlay: add helper for mounting rdonly overlay
> >   overlay/060: add test cases of follow to lowerdata
> >   overlay: Add test for follow of lowerdata in data-only layers
>
> This patchset looks good to me, and I didn't regression from it. So if th=
ere's
> not more review points from overlayfs side, I'll merge this patchset in n=
ext
> fstests release.
>

That would be great.

Thanks,
Amir.
