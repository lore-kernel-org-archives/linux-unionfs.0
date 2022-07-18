Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C96C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Jul 2022 19:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiGRTR6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 15:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiGRTR6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jul 2022 15:17:58 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5710E2F675
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 12:17:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g1so16647636edb.12
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 12:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TdpNh/OtxrXAgRkyZLTx7sdU3f7L5qyIViCiqKyQJ5I=;
        b=OFD0dfOkX/Ub3w/l4upU/yo1HLwEnU8/D4qFP8bCzSuiF0FPoYp9aqVZAXPaNWYmg5
         j6RR4FW3j0s/IQEJ24FN9jyOjGCh5Wrep+tS1pwAh/psbXQ75dFjKYKDtw5SUqUfKpAk
         pF8xp6rX5tMH86kWWgvw2+CO5ipjAHrRrG0vY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TdpNh/OtxrXAgRkyZLTx7sdU3f7L5qyIViCiqKyQJ5I=;
        b=CHXyabxzAExnZQW0OOELIu3ixjrTEIcbWU4DG0sh18emkJ8+QZW7DKpR1DC3rAyRZ+
         KuWpHXybtopokLK9bdWwPC0wWutbt67sQncyE9ofhhYhJacCbEUPxx8H4IsjIHpgWRdk
         GQTmLkpquPYGAkBMycoIrQtUZisvqIJodFqTZWBgaG0EG9PHj6HRqj7jrtViXkAwuai4
         hIC+hbsNuiHBqdpDXBhi0roynY+8SsHrqcPOF4TabPe1bQ9mDvdqNrRmUv8TWR8YY2Uq
         6WFVIe9yP+Yovkg+AdU6DbuUy9rD9qCUbduIGk2WCqop+G54CcZDv1jq7l63P/0/QDgc
         w1MA==
X-Gm-Message-State: AJIora+N57krEcOjlcpLL7ATeYSQV54MrsJ+M5JU/P5gQDzvd0LMTRAa
        V+trcW+UkXZZIN7AyPoqPrI/Fjxu5QLqiGFfcVg=
X-Google-Smtp-Source: AGRyM1uytr6pUR4V+RpYx2a6kKpaJ72+YBZWy3VjZoPQbXgdWyovNwVbNNhjS9pim5IVjPudRov0Hw==
X-Received: by 2002:a50:fd08:0:b0:43a:7890:9c54 with SMTP id i8-20020a50fd08000000b0043a78909c54mr39081992eds.52.1658171875595;
        Mon, 18 Jul 2022 12:17:55 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id u15-20020a056402064f00b0043a6c538047sm9137983edx.70.2022.07.18.12.17.54
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 12:17:54 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id bu1so18456420wrb.9
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 12:17:54 -0700 (PDT)
X-Received: by 2002:a05:6000:1f8c:b0:21d:7e98:51ba with SMTP id
 bw12-20020a0560001f8c00b0021d7e9851bamr22879411wrb.442.1658171873851; Mon, 18
 Jul 2022 12:17:53 -0700 (PDT)
MIME-Version: 1.0
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
 <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com> <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
 <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com> <CAJfpeguDAJpLMABsomBFQ=w6Li0=sBW0bFyALv4EJrAmR2BkpQ@mail.gmail.com>
 <A31096BA-C128-4D0B-B27D-C34560844ED0@kohlschutter.com> <CAJfpegvBSCQwkCv=5LJDx1LRCN_ztTh9VMvrTbCyt0zf7W2trw@mail.gmail.com>
 <CAHk-=wjg+xyBwMpQwLx_QWPY7Qf8gUOVek8rXdQccukDyVmE+w@mail.gmail.com> <EE5E5841-3561-4530-8813-95C16A36D94A@kohlschutter.com>
In-Reply-To: <EE5E5841-3561-4530-8813-95C16A36D94A@kohlschutter.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 18 Jul 2022 12:17:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh5V8tQScw9Bgc8OiD0r5XmfVSCPp2OHPEf0p5T3obuZg@mail.gmail.com>
Message-ID: <CAHk-=wh5V8tQScw9Bgc8OiD0r5XmfVSCPp2OHPEf0p5T3obuZg@mail.gmail.com>
Subject: Re: [PATCH] [REGRESSION] ovl: Handle ENOSYS when fileattr support is
 missing in lower/upper fs
To:     =?UTF-8?Q?Christian_Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 18, 2022 at 12:04 PM Christian Kohlsch=C3=BCtter
<christian@kohlschutter.com> wrote:
>
> The regression in question caused overlayfs to erroneously return ENOSYS =
when one lower filesystem (e.g., davfs2) returned this upon checking extend=
ed attributes (there were two relevant submissions triggering this somewher=
e around 5.15, 5.16)

Well, if that's the case, isn't the proper fix to just fix davfs2?

If ENOSYS isn't a valid error, and has broken apps that want to just
ignore "no fattr support", then it's a davfs2 bug, and fixing it there
will presumably magically just fix the ovl case too?

Yes, yes, you point to that commit to util-linux to also accept
ENOSYS, but that's from 2021.

So it's presumably triggered by the same issue - a rare (or new) and
broken filesystem returned the wrong error code.

Let's just fix that.

I do not object to *also* doing the ovlfs "accept ENOSYS too", since
it seems harmless and understandable, but at the same time this all
does make me go "the actual *fundamental* cause of this was davfs2
being confused, it should be fixed there too.

And yes, yes, I realize that davfs2 is out-of-tree fuse filesystem,
and is not in the kernel. But have people made the bug-report to the
maintainers there?

I don't think we should *only* have a kernel-side fix for a broken
FUSE filesystem. Particularly not one to some random bystander like
ovlfs.

In fact if we do a kernel patch for this dodgy filesystem, it would
seem to me to make more sense to have FUSE notice that "ok, ENOSYS is
broken for this situation, let's translate it to the right ENOTTY",
and that would have fixed both the ovlfs case and the util-linux one.

Hmm?

              Linus
