Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4710DC4708F
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Jun 2021 18:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24302613AE
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Jun 2021 18:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhFASba (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 14:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbhFASb3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Jun 2021 14:31:29 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429F4C061574
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Jun 2021 11:29:47 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id d9so10295734ioo.2
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Jun 2021 11:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fUHpADNuIdHNgqWWZF7ZSYZqfybUV07sexFif2ekV2U=;
        b=ZhtLgPOEFWjax5ylf9Lqy8wsj4Iu4o/oUnf94RTwz6vIINOtStfYbqXhVoEhoPm+9B
         ew25Ia1V9eNJeKAF8zI/ehzez8QVJ8AY/1gjrigJWkZUdssn8H1X3sWpKnw/4u0Hyfvg
         KwYVDXqKp+hCXwKQAFuzRQ0/yErDQgNOqFZEQFqXU0ufzbveV1N5YEVrGqmlfwT+iAGb
         8XTt6B06LwEvOe1OC2GzMC6xqRdTA4JfXmQIU8el23ONnst0LPnsvpluOyrdCTzh/tJQ
         30blb1LLcPtukUSgUiH+goggqo0JoTNNJ1UKfMSRhswlWKKWMpatYfrEdj27VBYsm1Dx
         HOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fUHpADNuIdHNgqWWZF7ZSYZqfybUV07sexFif2ekV2U=;
        b=bK/10vwqvEVE7Dk1A+uZ7KEw3L3md0AEDouJr3do3+fKHUkIAQF5wNIHAF4f5JLOJn
         bZ42/kzaZJdJ7kxLtCfvQq3XvQ3LRFfkbz0/TfsTlkxQ4Rn6IF2DdLXCK4DN67E0ygZW
         v5lf9C/24CBcnksYQYjGCKgSHPoYLD19KtMaa13gVVrfwFs7Qn2ceiJP8ueyJh01f4Oz
         D3uGzcvCQDFXtLeF3IunZz/hb0mNKxwynMawJmXfLniGZTqOPNRP3F9wNId2D1SdzJaC
         1HwLytid/AQjgyqzucthcfOiuDLzeAWN5/6gU5Ih4dQ+QM3vYS1XecVWoHHgGHMhIy8b
         ZfVw==
X-Gm-Message-State: AOAM531s1MorQ0wTOB7PhK9edPFUPd8ogsmjNQgkfS6mxa6K1GBQrOUP
        pVG5pKL6kDPCapK9wqzyT/lySeMUmiSdNLzrSVg=
X-Google-Smtp-Source: ABdhPJykXF+4iQlvQ+aDOVPbCBv5FvyPEhKv/6FdJbHa7vDps3KZQFQUbyVebaEmIa5ChjMUFMw1wm2EOm9Y3TH7pWY=
X-Received: by 2002:a02:908a:: with SMTP id x10mr26188849jaf.30.1622572186611;
 Tue, 01 Jun 2021 11:29:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210527174547.109269-1-uvv.mail@gmail.com> <20210527174547.109269-3-uvv.mail@gmail.com>
 <CAOQ4uxh7eSy6xAr9HdtZ=trcpUs8O5exXWJ8uqo2bacfMZXz3Q@mail.gmail.com>
 <AM8PR10MB4161DB3BDC0D415D5D3D5154863E9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
 <CAOQ4uxhN6t1fke1XxRndb9UN1M2sY9LVL9zKW_xj9xsXUrhr-Q@mail.gmail.com> <AM8PR10MB4161781D50CC2656A933D3CE863E9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AM8PR10MB4161781D50CC2656A933D3CE863E9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Jun 2021 21:29:35 +0300
Message-ID: <CAOQ4uxgGHw0WA407waFz2AShDGp9WMRLZjedKtcXNkS6hmvDhQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ovl: do not set overlay.opaque for new directories
To:     "Yurkov, Vyacheslav" <Vyacheslav.Yurkov@bruker.com>
Cc:     Vyacheslav Yurkov <uvv.mail@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 1, 2021 at 7:29 PM Yurkov, Vyacheslav
<Vyacheslav.Yurkov@bruker.com> wrote:
>
> Hi Amir,
> See below.
>
> > Maybe.
> > Failure of overlay/075 on master is known.
> > Failure of overlay/065 on master was fixed by xfstests commit
> > * 6159ae7f - overlay/065: Adapt test to relaxed rules
> > so you may want to update your xfstests copy.
>
> Using the latest master now, 065 is still failing for me.
>
> > Failure of overlay/005 is not familiar to me and the
> > attached log is missing all the output of the test -
> > it just has the summary.
>
> The reason was simple, it required xfs as underlying file system (and sup=
port in the kernel), but I had only ext4.
>
> > Worst yet, according to summary, all those test do not run in your setu=
p:
> > Not run: overlay/001 overlay/004 overlay/008 overlay/015 overlay/020
> > overlay/021 overlay/025 overlay/032 overlay/045 overlay/046
> > overlay/056 overlay/064 overlay/100 overlay/101 overlay/102
> > overlay/103 overlay/104 overlay/105 overlay/106 overlay/107
> > overlay/108 overlay/109 overlay/110 overlay/111 overlay/112
> > overlay/113 overlay/114 overlay/115 overlay/116 overlay/117
> >
> > Can you provide the full log to understand the reason or figure it out =
yourself
> > and fix this.
> > If you are running a special setup that is fine, it doesn't have to
> > run all the test
> > (as long as you know why), but in order to verify that your patches did=
 not
> > break other setups, you need to test with a common setup where all the
> > above tests run and pass, short of overlay/075 which is a known upstrea=
m
> > issue.
>
> It seems most of them require unionmount testsuite, which is not a part o=
f xfstests package, and I missed your hint that I should check README.overl=
ay =E2=98=B9.
> Some of the other not-running tests needed more spaces (> 1GB), which I d=
on't have on my device. And a few more required a dedicated user/group on t=
he system.
>

Ok we still need to verify no regressions on those skipped test.
I can run them on my setup when I get the time if you cannot find
another test setup which meets the requirements.

> I added unionmount testsuite and sending my two test results.
>
> > > v2 indeed caused a few more failures on top of that:
> > > Failures: overlay/005 overlay/065 overlay/070 overlay/071 overlay/075
> > > Failed 5 of 93 tests
> > >
> >
> > I'm a bit surprised that tests overlay/068 overlay/069 did not fail wit=
h v2
> > Maybe they did not run and you did not notice that in the report?
>
> It did not indeed.
>
> Anyways, v3 results look pretty good now, I think.
>

Yes, looking better.

Thanks,
Amir.
