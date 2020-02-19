Return-Path: <SRS0=YYYA=4H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C75C34047
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Feb 2020 15:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E8082465D
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Feb 2020 15:36:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="VQu1IvuN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgBSPgO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 10:36:14 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36098 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgBSPgO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Feb 2020 10:36:14 -0500
Received: by mail-io1-f68.google.com with SMTP id d15so1028697iog.3
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Feb 2020 07:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9vJmpdU2JfcOmQbnaugm/DI6Gc3Y+NfKTDV7RpTLIZ8=;
        b=VQu1IvuNbvshbTiMCYjN2iJ6SVgwwUYvanZzLRLh7YR0svvpiwet3YhOKc51leWOKn
         0jl/MJ7DixgIzjh5ZEClLrJngulYfqcT6ZK7Zujj3BdJyzXT/j5VuD1oOkEPdf4g4pfY
         iMt2PEf82xpCyfI3lNSG+UGlRkhTRRAPk0424=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9vJmpdU2JfcOmQbnaugm/DI6Gc3Y+NfKTDV7RpTLIZ8=;
        b=ohxSmKzh/KNDXgNKSV4HQZDEIA4ABZ3CDOgfPTj594qP0AhFWrJSENVKH7+8V0C8Qv
         qHw++co1ROxX/lvMEKlpyUBLNkKwrs9YJJcdBdu9M0dX1MI7zglKfCVvgP2hJnDQdMAj
         1UjA6UeweI2IgDd/Mgue5ggny/RBR4HX3ZHNJp8LcMHksT7KnRAkoDs8yegIUFaagDDO
         n9PC+ohTEa2jCEyG8DyCbesLDh5cbSeEORMHaIQV2c5JEDOP3NKPKqdIQBCgFQiy6HHo
         RK/G1SZhtB47V0u0pqh449hdChVrOGxa4zlPKMhKY6Atd4p97jClrdq/sNQDSL0nJcS6
         5X/w==
X-Gm-Message-State: APjAAAUK2I80DlrVnT5FdSTF4Gxfjq6d0BbMsSwCTEa5UPIRUHV5L/am
        oeYbltPt79i4XwyEdbg1NsjiX2EextYuWa9Ob1YqDQ==
X-Google-Smtp-Source: APXvYqy1s3FFYjgX0RKaCJ3TD7XcwJlcRDTgPo3hZfUq8C08/PWCX+xOZ5XWNS9eVUYpvH3oRRNcKioj8JiwHQASr/k=
X-Received: by 2002:a05:6638:1009:: with SMTP id r9mr21946027jab.58.1582126573527;
 Wed, 19 Feb 2020 07:36:13 -0800 (PST)
MIME-Version: 1.0
References: <20200101175814.14144-1-amir73il@gmail.com> <20200101175814.14144-6-amir73il@gmail.com>
 <CAJfpegvPBwBpmcY60CcypYRAGgQr44ONz8TSzdBUq2tPmOXBbA@mail.gmail.com> <CAOQ4uxgpR5O-dFKYueHKd_j8bA_k3F06pFQ+qjVfe9htTmyWOA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgpR5O-dFKYueHKd_j8bA_k3F06pFQ+qjVfe9htTmyWOA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 19 Feb 2020 16:36:02 +0100
Message-ID: <CAJfpegvSU8w19XPtMPP7PXac455JWos9O6UrmzgNOQBKcaqkCg@mail.gmail.com>
Subject: Re: [PATCH 5/7] ovl: avoid possible inode number collisions with xino=on
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Feb 19, 2020 at 4:28 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Feb 19, 2020 at 4:25 PM Miklos Szeredi <miklos@szeredi.hu> wrote:

> > While this makes sense on 64bit arch, it's going to overflow on 32bit
> > (due to i_ino being "unsigned long").
>
> It's not clear here, but on 32bit, xinobits is 0:
>
>                 ofs->xino_mode = BITS_PER_LONG - 32;
>
> To the expression doesn't change i_ino.
> Correct?
> Want me to clarify that by comment or by code?

Ah, missed that.  I think no need to clarify further.

> Yeh, it's mostly the same. Branch ovl-ino is already rebased.
> If you have no other comments, I'll prepare v2 and test it with 5.6-rc2.

Thanks.   I've already applied the patches leading up to this and just
pushed to #overlayfs-next.

Thanks,
Miklos
