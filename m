Return-Path: <SRS0=YYYA=4H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B26C34047
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Feb 2020 15:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 075622465D
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Feb 2020 15:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H+zXvIiE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBSP7f (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 10:59:35 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:41549 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgBSP7f (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Feb 2020 10:59:35 -0500
Received: by mail-io1-f66.google.com with SMTP id m25so1089844ioo.8
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Feb 2020 07:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zKykTNPLufTKOyzWPuhevr7UlN8H/SDIb+8sV4wIuqU=;
        b=H+zXvIiEpdletUsMcx/ZBbEk0yluYXUgICtPZyZoMYjvSZEA72AlcuuB/IjVtTJg4p
         hBZK9ZeWX7ufx6hURYdXSRvqDW2eybewe0DCNGgCuGRhSPoCNF5swyUjlKxicMXqSNF+
         t+43lo/eNCkXF70OZI1e5ceA6gKk9bpATFcMxEW7TO7s1atTb9GEUDJMaH10A/PIXiHJ
         akW2JrbDNl4k1l2GPN2YO539rTaPItvb76Sm8pzNpXSHx6TV2jY+8kbqMO3csbjxjEI1
         zoSJQhNuRLV+9VezSLKVp7VUiovV6/vBOI60BndoDiYxq3sChkc8d7LRhplODUoQpaC4
         Q1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zKykTNPLufTKOyzWPuhevr7UlN8H/SDIb+8sV4wIuqU=;
        b=cCFV2TYZG+pOIJ/GCWYn/PrJK5LiGK0yiMbt+PCDfaMi56OIs5/Ccw7vNA6OmrcO2L
         F13/dmMwwuemB2DKYWQmyR4zJXQDzQLMyAoYTLck+SIKIBaq6FGXyDBoMHK3CMyvPa0p
         RXjVnROcaB0xHQ9n3bOuC3mHC7JA5NVVWWHXuZ+DfPR3D9KLCsb2L8lvHGPE5GU5ss6w
         L77yOR/XQXJrFzcu6JcWKG/gwZ+EufcTXu+T26vIF32/KWKAWnfShpFL+6J8gPKYd6IH
         QPQbL/jh23RBvTBKJt8m9zf9czOEzkti5hceLicwkrz8umRGcZwj9p7cW1O7X/RPbaAi
         4TZA==
X-Gm-Message-State: APjAAAW8mirmKgGKULuVLIiV/ekchuMdqRJU7sM1S5jxxwsgZwmpl64S
        LSo/q29dKls8/s+7ZwZ9vvgsIJLbZqlqBAxbepM=
X-Google-Smtp-Source: APXvYqzaW/qiKh4OnDy82hp1jaOY+SYZfAPovKELiOk4KYknykAFMCkofQT7jUQlzrTbaYwNdFfsuvXjly8FsdXQIlI=
X-Received: by 2002:a6b:d019:: with SMTP id x25mr20241119ioa.275.1582127974846;
 Wed, 19 Feb 2020 07:59:34 -0800 (PST)
MIME-Version: 1.0
References: <20200101175814.14144-1-amir73il@gmail.com> <20200101175814.14144-6-amir73il@gmail.com>
 <CAJfpegvPBwBpmcY60CcypYRAGgQr44ONz8TSzdBUq2tPmOXBbA@mail.gmail.com>
 <CAOQ4uxgpR5O-dFKYueHKd_j8bA_k3F06pFQ+qjVfe9htTmyWOA@mail.gmail.com> <CAJfpegvSU8w19XPtMPP7PXac455JWos9O6UrmzgNOQBKcaqkCg@mail.gmail.com>
In-Reply-To: <CAJfpegvSU8w19XPtMPP7PXac455JWos9O6UrmzgNOQBKcaqkCg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 19 Feb 2020 17:59:23 +0200
Message-ID: <CAOQ4uxieagY4hW9jHsHpPVsiRFo3CAThdc6=CcmPR-aOPtnjDQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] ovl: avoid possible inode number collisions with xino=on
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > Yeh, it's mostly the same. Branch ovl-ino is already rebased.
> > If you have no other comments, I'll prepare v2 and test it with 5.6-rc2.
>
> Thanks.   I've already applied the patches leading up to this and just
> pushed to #overlayfs-next.
>

OK, I'll rebase the rest on top of that.
While you are here, what do you think about:
  ovl: enable xino automatically in more cases

Do you agree with that minor change of behavior?

BTW, I see that overlayfs-next allows all remote fs as upper,
without extra restrictions.
I guess you are not too worried about implications?
Or intend to fix that up before the merge window?

Thanks,
Amir.
