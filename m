Return-Path: <SRS0=VDYA=5Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58EFC2BA19
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 18:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A21B620753
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 18:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h19z6zIi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDIS1L (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 14:27:11 -0400
Received: from mail-il1-f177.google.com ([209.85.166.177]:42431 "EHLO
        mail-il1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgDIS1L (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 14:27:11 -0400
Received: by mail-il1-f177.google.com with SMTP id f16so605182ilj.9
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Apr 2020 11:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gyFtLf91QG0V6Q0s9IS35MLXGunZz1Wj2CZITRf57ZE=;
        b=h19z6zIiP3H3wFiGhi6JXcdRPmUOp1mVBwj5/RNbEdWFMLiwbzEV/orzUOpvIB3zHU
         ecvm+LeM+8AY+To6Rw30MkEacB6gyQSIjiNezsanq18ay1Q6ERKuIFBkyhZcjm75i5a2
         62NFVGM7WLmNBqmy6Oojb9yCC42PRP+8Ia05o2KrRngj+bJbsl/nXm5pfts047ONa6B6
         cSLfbTab28+O4ypadLLFgsTiVSohEI0wOu2ib8YKe7gpWdQHg0ZPMszr5aJj9Duby+3l
         FVPrVg4Ydj9y6dW1OasvABqEWwRChrDmKBnoYqe1hmyIWdxuTZM8Sq+5ODQ+COOak8dM
         jfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gyFtLf91QG0V6Q0s9IS35MLXGunZz1Wj2CZITRf57ZE=;
        b=dT8GtBEcRhpLRK28W25R2JBKjqfpWEKNDVWtDc2d2yIU3BK95WazQtLkauLPxdmab2
         6ieRfBBmf0QydR4Soz0mVeWi54iJFwxd+0FRNxFCDY2Ex/IaYvRuJpfM2vA9rLPpMR1n
         qygZvY9u2ArkPhzG1yWg7twyU1OdbBL9B9mHybtWs3y8cFutLE6sCvanGtePTUMdL2zo
         JidXzLKdW36xDp/y9FXPvxJzuIutoItAt2ZjvtOd7sbPEf7kkdtgWYxaaBKu5Td8uzxj
         XKTfeGPXj9f7q+T04kJ45CcRqx1L/GcuV8yF6AIbo+gySfonpEMGUrTCkyZd5c8eBcmN
         WhNw==
X-Gm-Message-State: AGi0PuYcGixJPE1wYCCToe6f/Y/vFSMGxCnz85IzsRdPRYMyfBd1gNa3
        TX0S+lcs9CTPdzDTwGqMCpoJrQsxWek7YL2/UbBp5CQv
X-Google-Smtp-Source: APiQypJf1nhkWCLDfH9qA7ynNVaK8BWtlo9BrgbJF5b+bQKsAQlyzPYSsQJL5/Rc5BEbCz97JKTuu+oAN1+umF7K0sg=
X-Received: by 2002:a92:394d:: with SMTP id g74mr1104764ila.250.1586456831179;
 Thu, 09 Apr 2020 11:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxjryJep94sLgVxV7sGab8K3yeeDUZwOYOfLtOOguW1pcA@mail.gmail.com>
 <CAOQ4uxiHKjNba8HD5JUWFxxJqyJxPMk3fFfA3fi-nO6uJngTAg@mail.gmail.com>
 <CAOQ4uxhBBnr5zFOn1Dr-XtDSo=p3BovyhK6xZh22GA=dv1L8Bw@mail.gmail.com> <CAOQ4uxiKdxujdKNWBRNxtvCrq5TDJuhoW5Oede0Hu1myoKfeEQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiKdxujdKNWBRNxtvCrq5TDJuhoW5Oede0Hu1myoKfeEQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 9 Apr 2020 21:27:00 +0300
Message-ID: <CAOQ4uxg_gYbvh7-OaJF5=YXsFSBNbQHCm2yb_-oiq=OFvSz1FQ@mail.gmail.com>
Subject: [ANNOUNCE] unionmount-testsuite: master branch updated to a9a4f4f
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
- Support testing nested overlayfs configurations

The following test arguments:

    ./run --ovov --xino --verify

setup a non-samefs nested overlay with --xino and demonstrate the
best effort nature of xino - upper inode numbers are in the xino domain
and lower inode numbers overflow xino bits and fallback to lower layer
pseudo st_dev and the lower overlay st_ino.

This was used to develop the recently merged ovl-ino changes.

Thanks,
Amir.

[1] https://github.com/amir73il/unionmount-testsuite

The head of the master branch is commit:

a9a4f4f Support testing nested overlayfs configurations

New commits:

Amir Goldstein (1):
  Support testing nested overlayfs configurations
