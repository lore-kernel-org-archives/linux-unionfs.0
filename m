Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9985C4743D
	for <linux-unionfs@archiver.kernel.org>; Fri,  4 Jun 2021 19:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8C360FF2
	for <linux-unionfs@archiver.kernel.org>; Fri,  4 Jun 2021 19:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhFDTWA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 15:22:00 -0400
Received: from mail-il1-f180.google.com ([209.85.166.180]:35726 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFDTWA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 4 Jun 2021 15:22:00 -0400
Received: by mail-il1-f180.google.com with SMTP id b9so9900538ilr.2
        for <linux-unionfs@vger.kernel.org>; Fri, 04 Jun 2021 12:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jTUWxmOPXhQELiHEO2xnZBwYe5zq/RUkvbFqy600j4k=;
        b=flDYYPJ9gdq/jV3SOc1SkBGuvImctyzgURnuZVSMUXWD8O+ij4n6uQmUuFKdbd/aD+
         BIkGlC9Wmlno2eVNszpmOBEb4gvzF8R71DDhidEz3zwTfCJHEWseIDBLMK4YHjagZlmE
         SOYWNnTW1MSYb5/bJL5hkYvhrA2yjdWT9jHGx15QZQsfhMzUTRjUvoiGl5VyES7Spn/H
         RIIgaoMEsvetctOnkR90EvJPHKl89Kv0L0dyv3KapNjWPXE7FjpQnzDdLbVhPvzblLVa
         jVGr0riLRbreyw9Q8CUj6NFqgDkZbNVxQOwI0+vShBhcVonVQjltu1FypmBmO4t9nKZm
         DcBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jTUWxmOPXhQELiHEO2xnZBwYe5zq/RUkvbFqy600j4k=;
        b=Gk1tERq27D59uo/cTAdAvWx+V26/oS1aq2xTR2EnhMQPh+eMfiJM2ykOtkcfLTXBr3
         7Vu9e047p77T2pd+m3WPCj8joCaxt/uB1hHgnBqBeyXB0XakN+QSKiv+/A7sPXImjiKP
         ZaiDyEZ9kBVYS2nz/IpxyeRUehqXgpmXRMeOSBHf/yVG+qCc7OzbGX+R2Qi2ac4VqSBP
         aXUfPvT5/9LyKnzH5cqq17gfv211hoE3Jt/HQrbfXMzZB9SN7XptzjMTxNBzIwVywl/z
         gS72AQd1jxI4Yd5wGdRvmVhepvrtXPIDUW+AITv3S/iznWOD2ZkTDK1Vc5NYohxfCBcq
         u5Fw==
X-Gm-Message-State: AOAM531nCX5GekPDCHke2e1J8oHS5H2Cu6g6L9QbGN1jkhGr/U7xuXIe
        4+dMl9rcwZe+Q8rlICcJyjD5OD2QEzMwGeD0lfx3RUlIEas=
X-Google-Smtp-Source: ABdhPJzHXnLi98j0q1m27dRopVrmdOdeaGIH7i2QY+4KcMlnA9okwRDr8UgoJjVFo2IZ0FKEVzRaPl/AWjzc7eWA9WQ=
X-Received: by 2002:a92:874b:: with SMTP id d11mr4906505ilm.137.1622834339628;
 Fri, 04 Jun 2021 12:18:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210527174547.109269-1-uvv.mail@gmail.com> <20210527174547.109269-3-uvv.mail@gmail.com>
 <CAOQ4uxh7eSy6xAr9HdtZ=trcpUs8O5exXWJ8uqo2bacfMZXz3Q@mail.gmail.com>
 <AM8PR10MB4161DB3BDC0D415D5D3D5154863E9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
 <CAOQ4uxhN6t1fke1XxRndb9UN1M2sY9LVL9zKW_xj9xsXUrhr-Q@mail.gmail.com>
 <AM8PR10MB4161781D50CC2656A933D3CE863E9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
 <CAOQ4uxgGHw0WA407waFz2AShDGp9WMRLZjedKtcXNkS6hmvDhQ@mail.gmail.com>
 <CAOQ4uxiAkMYiTQEg8A61tUU4jGCs9YSCVYuttGiQobif6rhmjA@mail.gmail.com> <AM8PR10MB416123A0AAE3135A15C72FF7863B9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AM8PR10MB416123A0AAE3135A15C72FF7863B9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 4 Jun 2021 22:18:48 +0300
Message-ID: <CAOQ4uxiPo-Wrdzfwf5q9c3WhvaZuUORXCBkJ6imH3ksTd5G5Ow@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ovl: do not set overlay.opaque for new directories
To:     "Yurkov, Vyacheslav" <Vyacheslav.Yurkov@bruker.com>
Cc:     Vyacheslav Yurkov <uvv.mail@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 4, 2021 at 5:51 PM Yurkov, Vyacheslav
<Vyacheslav.Yurkov@bruker.com> wrote:
>
> You were a bit faster than me
> I was able to extend my system to provide all needed utilities / kernel features and also got all the tests run.
>
> But to not loose my progress, I'd like to contribute my yocto recipe to the meta-openembedded project. It would be great if you could clarify a few things for me.
>
> 1) The base test harness is xfstests, URL: git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 2) Ovelayfs testsuite, URL: https://github.com/amir73il/unionmount-testsuite.git
> 3) The test suite also requires fsck.overlay, URL: https://github.com/hisilicon/overlayfs-progs
>
> Are all the URLs are correct?

Yes.

> #2 and #3 are official repositories so to say?
>

#2 is officially documented in Documentation/filesystems/overlayfs.txt
and actively maintained.

#3 I am not sure how many people use it.
I did not get much attention after the initial release.

Thanks,
Amir.
