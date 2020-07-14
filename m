Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05BAC433E3
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7DC22518
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:28:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Pq2DX9Rk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgGNO2E (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgGNO2E (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 10:28:04 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8459C061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:28:03 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n26so22201374ejx.0
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vGW+DNIn/pteCUqcWJOlk1XIMMCUB5G6jSX58C2tPsA=;
        b=Pq2DX9RkUSgLHp31X80hWSxo3G7CvJeNdsMWiR+D1EPX59pwEksElNVYjBGk9TZUeZ
         pXO+pgOy59h20MrVQqyLsJXyQzMY7JStdLDtvkDwRYn/q4XlSERkfC1AlkrMOxD0UpjT
         V2bfS/LTk1RcxdL1SdxZPXPXrgxyNzxPwRYwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vGW+DNIn/pteCUqcWJOlk1XIMMCUB5G6jSX58C2tPsA=;
        b=SD1s3hUatpqs70mSpoLD/fvunWVPp58IF5Wk5f5jWT+6M5pifeM6CB00tLaorbtr4Q
         7/DZbQsSZkGNCGJO1q5o5zHbcymwRHlv8h8K81h+od0TVI+27OyA5zhTtWnc0ivT2adf
         zQbbGx5uBh8vi5Ct8uLaNoJjbteHixA7fji/p0pTe/NKCgTx0I05Cr9AQr2cprmuQIre
         b7FOjULa94FSOLd7D+2FpmSArrTXCTogIGXuQR+Gk8joazXykcTCG1AIK4NLcMhf5Hsd
         I8WGsBwucZPIp3YwrwDTt41Kb51wHXNx0/ke+Du6DQcThGodbLcrsaI4QAeGD2OUnPi2
         Q1EA==
X-Gm-Message-State: AOAM5304T915N+dUsrLui+HF4GDo23E37WM6hEwKPzEl5R7bPrQLZAJE
        s7OovdzMYqIIuNUmTtbW9HQM8Aw0fbo816omK5kbuA==
X-Google-Smtp-Source: ABdhPJwlhtWuWwr7vTEcblrCbvaiUM5BSDIfsKuofIauB2vdhBMkXeRU7egoUEZVLDAYtOPScJQNnubPpquMH8a+jYw=
X-Received: by 2002:a17:906:824c:: with SMTP id f12mr4616826ejx.443.1594736882662;
 Tue, 14 Jul 2020 07:28:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200708131613.30038-1-amir73il@gmail.com>
In-Reply-To: <20200708131613.30038-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 14 Jul 2020 16:27:51 +0200
Message-ID: <CAJfpegu928w_58qc=1-MDfK559Xu4z_pHxz_caaYFmWbX7iO=w@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression with re-formatted lower squashfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Fabian <godi.beat@gmx.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 8, 2020 at 3:16 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Commit 9df085f3c9a2 ("ovl: relax requirement for non null uuid of lower
> fs") relaxed the requirement for non null uuid with single lower layer to
> allow enabling index and nfs_export features with single lower squashfs.
>
> Fabian reported a regression in a setup when overlay re-uses an existing
> upper layer and re-formats the lower squashfs image.  Because squashfs
> has no uuid, the origin xattr in upper layer are decoded from the new
> lower layer where they may resolve to a wrong origin file and user may
> get an ESTALE or EIO error on lookup.
>
> To avoid the reported regression while still allowing the new features
> with single lower squashfs, do not allow decoding origin with lower null
> uuid unless user opted-in to one of the new features that require
> following the lower inode of non-dir upper (index, xino, metacopy).
>
> Reported-by: Fabian <godi.beat@gmx.net>
> Link: https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/
> Fixes: 9df085f3c9a2 ("ovl: relax requirement for non null uuid...")
> Cc: stable@vger.kernel.org # v4.20+
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>


Thanks, applied.

Miklos
