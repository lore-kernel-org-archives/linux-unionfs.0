Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72194C43334
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Jul 2022 12:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiGRMVd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 08:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235038AbiGRMVb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jul 2022 08:21:31 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532DC25287
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 05:21:29 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id j22so20889103ejs.2
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 05:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ie8y8xom7gdgORK3/wgC6v2nBY/N6LA9J5NWgTDl2HM=;
        b=dZ9jScMt4MO13dtuzooZqTSxO2bjJkLycwSI6B0TBmg9pnUReCQ76CmaV4WQ6A5J1F
         BXd0HR3D0YzUSUo21ICIN4NsTAl3SmzYXTrgawKRuq35PsRaR1GgaemH76YDIv0NQeDv
         D1EK/PliBPHo5GdlCRd296v+4mVWyx5UzS/OI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ie8y8xom7gdgORK3/wgC6v2nBY/N6LA9J5NWgTDl2HM=;
        b=Id8tWZogbwf/Kw2me/CNZ3j9OlS1+rEyiBAfvic6qemTqsURurBgS0CTz2TD9F2fNd
         zidYvPQu7OUEopxy1ugsKoLvVgOgEPGWj3q8VcnuC4rCcTUcSHy9zuiavkB4Pghrjj+G
         DayLMDuv0czCK2nePdNYB4mY2MCzJsb6dJOk+9Igv+bOlybqIjxEXr6BFuMDz7C4rGxm
         QpjAgqo8czBGVVJJFe62aEHS29wt0/Vq2kKUKzrT/6y2kT3evdwl6Xl6jrS1M5EdVoTB
         fwuqGC38T3lYdMlSPo/oU28WXo6ixwfnK1KwksW3p4M7sp2AijJ0vIRgyF/1MdGabe8q
         Vq+g==
X-Gm-Message-State: AJIora8rearovkBqRAwZWzY/JgSlD8HsspQyEAaxFh1oN/OvCfZH25Aw
        BRawRr/vTrd3s5DQB8M95nqzKIH/61Sp/F+PtgktwA==
X-Google-Smtp-Source: AGRyM1vI/im93ImHCgZ05iECidEYFcWtEzzcaF2dJOWQB1/Yq5IMa3L6gYgLFbipMZiZCi+5b2lvg6oArb2FqBJ9MTI=
X-Received: by 2002:a17:906:93ef:b0:72b:44e2:bdd8 with SMTP id
 yl15-20020a17090693ef00b0072b44e2bdd8mr25545654ejb.192.1658146887863; Mon, 18
 Jul 2022 05:21:27 -0700 (PDT)
MIME-Version: 1.0
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
 <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com> <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
 <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com>
In-Reply-To: <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 18 Jul 2022 14:21:16 +0200
Message-ID: <CAJfpeguDAJpLMABsomBFQ=w6Li0=sBW0bFyALv4EJrAmR2BkpQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: Handle ENOSYS when fileattr support is missing in
 lower/upper fs
To:     =?UTF-8?Q?Christian_Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 18 Jul 2022 at 12:56, Christian Kohlsch=C3=BCtter
<christian@kohlschutter.com> wrote:

> However, users of fuse that have no business with overlayfs suddenly see =
their ioctl return ENOTTY instead of ENOSYS.

And returning ENOTTY is the correct behavior.  See this comment in
<asm-generic/errrno.h>:

/*
 * This error code is special: arch syscall entry code will return
 * -ENOSYS if users try to call a syscall that doesn't exist.  To keep
 * failures of syscalls that really do exist distinguishable from
 * failures due to attempts to use a nonexistent syscall, syscall
 * implementations should refrain from returning -ENOSYS.
 */
#define ENOSYS 38 /* Invalid system call number */

Thanks,
Miklos
