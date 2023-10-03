Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0189AE7543E
	for <linux-unionfs@archiver.kernel.org>; Tue,  3 Oct 2023 09:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjJCJus (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 3 Oct 2023 05:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239818AbjJCJuq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Oct 2023 05:50:46 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68972AC
        for <linux-unionfs@vger.kernel.org>; Tue,  3 Oct 2023 02:50:39 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a1e0cc1a2514c-7a7e11a53c3so2764797241.1
        for <linux-unionfs@vger.kernel.org>; Tue, 03 Oct 2023 02:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696326639; x=1696931439; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rymc5sLvIVvwtP/HOw6yHSNdCN77YGMeeqPHahGG5B8=;
        b=TAbl7ofeYn5b3U/6w5+hnNHFtpvo6bS6AW8IdG+WDAbd44rtBrLC6+6jsiEpwq9tgX
         mRdAsj/QJJBXL0dRbcTC54Lex9/qwmV2TwusF9e8T91EcWk2PjRnW25f1e88ycpdoI/w
         Alu784fxTZzA2/Kgd3OCEyYhtildDMsepnU3JAFhZ+Fq66Fr4QgV/zjaSt9pGAaUnvun
         FwGcq+DSOXZuAgXdIQXunU50LiJ+fPkfN92DUAID5r5Q3JVRkcQ+dbqgKL4J+NLbHIEp
         120HVMsTLJQ8qyN+KHykVmkJ28xt9CHed5mIunTW93TiT2L8Ub1nuAPBelYl80Wb7ong
         fLMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696326639; x=1696931439;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rymc5sLvIVvwtP/HOw6yHSNdCN77YGMeeqPHahGG5B8=;
        b=YZM23umtaDyMJUS+OlngfrROfUFeAsKXLR22KAQqCyjXTGBKHn5MqUP+8PbDlUacuU
         1tYLG+l0hOPVwH6R30ZOKuvXeSlaPrFihTdh6smR2u6tsokLRDMcIjlxcnIja7E8Zajp
         eqCN7QuZJ0kvYYvcrcaMdXzUv9v2uER67NfmeT7U/LmV3Au25uYsJrhGv7rN39TvW00a
         X4NyyqiWX2RUU7PjHGKim65qBQS1k2APy6rafQw8dOh6tlklj/Dm1Q48yqnzj83ZMSDZ
         Yv9Ws/h6OZr/MT+jrX7+wZtBJSTokDgAkZkmeBOYL5AH5+wy+Q64ABPDx65rHC0gslmM
         GvGA==
X-Gm-Message-State: AOJu0YzVU40xryKLP5zWy9Yy1AtQZGFajkzOpdV6SIgLF1rDbcKblp1p
        tKFKQXCdZ2apNbp4/EmNzQxwF+NW7gMUrR+IoXLR4zT81hs=
X-Google-Smtp-Source: AGHT+IEUoOFURNdpyf6sKnN5k1VPv2Z/OJ+YhF7nsgy4YKUBckkzGCTtfnEWXo9uvCOKfPfUgut62GZdNTlK6p6ilUY=
X-Received: by 2002:a05:6102:558a:b0:44e:ab51:9e0d with SMTP id
 dc10-20020a056102558a00b0044eab519e0dmr1292959vsb.16.1696326638296; Tue, 03
 Oct 2023 02:50:38 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com> <80c265ab-1871-211e-2787-fefbf25a892a@alum.mit.edu>
In-Reply-To: <80c265ab-1871-211e-2787-fefbf25a892a@alum.mit.edu>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 3 Oct 2023 12:50:27 +0300
Message-ID: <CAOQ4uxheu-LXAh3nAcnufwOR=+9xPVeHdi_=dZVx6qj7ZwRGpA@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>
Cc:     Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 3, 2023 at 1:23=E2=80=AFAM Ryan Hendrickson
<ryan.hendrickson@alum.mit.edu> wrote:
>
> At 2023-09-29 07:44+0300, Amir Goldstein <amir73il@gmail.com> sent:
>
> > That's a good guess.
> > It helps to CC the author of the patch in this case ;-)
>
> Ha, oops! Sorry, I have been spoiled by web-based bug reporting interface=
s
> and actually e-mailing maintainers is weirdly a novel experience.
>
> > The question is whether we should fix it.
> > The rule of thumb is that if users complain than we need to fix it,
> > but it's a corner case and if the only users that complained are willin=
g
> > to work around the problem (hint hint) then we may not need to fix it.
>
> Gotcha. In my specific situation, unless there is an alternate escaping
> mechanism or mount API that works identically in both <6.5 and >=3D6.5, I=
'm
> going to have to do some version detection to work around the regression
> in released 6.5 kernels regardless of whether the old functionality is
> restored later. As long as there is *some* way of using overlayfs with
> arbitrary path nemes (including commas), I'm fine with whatever you
> decide. (If there isn't currently a way to mount a path with commas in it=
,
> you may consider me complaining.)
>

What you can do is use the new mount API for kernel >=3D6.5
and provide the parameters one by one, e.g.:

fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/tmp/test-lower,", 0);

See example in commit message of
b36a5780cb44 ("ovl: modify layer parameter parsing")

> But if the status quo remains, I would like an answer to:
>
> >> Is there a new way to escape commas for overlayfs options?
> >>
> >
> > Deferring the question to Christian.
>
> BTW, in case there's a difference between them, the actual code I'm
> working with uses the libc mount() function, not the mount CLI tool. I've
> also experimented with the functions in libmount but they seems to have
> the same problem with commas. Either is fine as long as I can support
> mounting arbitrary path names.
>

The mount tool and libmount in util-linux 2.39 support the new mount API [1=
].
They already auto detect and fallback to the old mount API, so you wouldn't
need to implement per kernel version logic.

I do not know if the new mount tool would split this string on the escaped =
\,

-o 'lowerdir=3D/tmp/test-lower\,,upperdir=3D/tmp/test-upper,workdir=3D/tmp/=
test-work'

But the kernel old mount(2) syscall does NOT escape the , when splitting
the options string into parameters.

ovl used to do it with the old mount API:
91c77947133f ("ovl: allow filenames with comma")

But it does not do that after the conversion to the new mount API,
where generic_parse_monolithic() is used for splitting the parameters.
I prefer not to have to override ->parse_monolithic() for this behavior
if it works as desired for you when using new libmount.

Thanks,
Amir.

[1] http://karelzak.blogspot.com/2023/06/util-linux-v239-improved-mount.htm=
l
