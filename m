Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC29C4708F
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Jun 2021 08:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94E6461263
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Jun 2021 08:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhFAIfP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 04:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbhFAIfP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Jun 2021 04:35:15 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F3DC061574
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Jun 2021 01:33:33 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id k22so14392143ioa.9
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Jun 2021 01:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YXQc+UDCRyxqXfYtTPQ+nYk5cOdFPAwYMJviG8NaLM8=;
        b=fbmzyYWFGJPtF23ndNY+YSVH3eF6h9I8hgfnj+Y8S1cZcsf8R9v1ePxQkjj0JZEwEY
         A5WlR5eAI8nI2qXpMFRRltA8e/MEaYIzp0x9kcAgas2eOZMii4j+/ilrpowpo8NkblDH
         rLZQZcypldj15BBp5ojTZTqe0Z9kwjVW2c7X8RTG7KHMDaGBrSF7UeZavOt1PoHSeGwh
         C8SsRMlEOlctsU7qTwD9AVwnca21wALnhW2zVjsoe1OYXWG11p8zNm88RIZ3Pwrvveol
         UumFydNRWhzSIeGTBMG6SGbqkMtd8Mk4gv+HwmeDnmbVTW6BhKGH2BMO2Fiznx5uBCz6
         6tZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXQc+UDCRyxqXfYtTPQ+nYk5cOdFPAwYMJviG8NaLM8=;
        b=HmmbsNsUHfqigOgS9RGarlcndI6EEeWXttSzDcvg+Iwhosv6rbQCEJKbyFCbpHrWVN
         bWuFBEVmbtLe0H5Zo2dw3MLfQGXfEYzDSRF6H47druoJL6q+130oqPuIHelvrD9MWAby
         hxFhsQxptRR8wimhTQcBs/hGcJ6K0GUEBzDKO9TBoIKksDhQNzdxnN1HmjMeEN7kAowG
         qrSdG9J2dYJWTDsv5Vqf3iXn6893f8STqA8CYQktZx58hitLkAIQa23bNODBLUirPws7
         hBiYyTYtafaO7yYPbu4IqfOj4qnyNiNkacVXjmTPW6LP4G7LFrHoX1CFfBMrjEmo8Pn4
         vYpQ==
X-Gm-Message-State: AOAM530Wr5Jbx5Gp13PyAL+d9TbcDkxpxI1qOFAOP+HPoGGq0EjI+X5Z
        lYC/VBVMaSkdDvyAKtnPZ989patBDu9o4SZCE2g=
X-Google-Smtp-Source: ABdhPJyL2knDcvx7EngEjpuBLUwQU1NTL4VeYkeORr6gMrF25zYGUitZfnoooJSITYZKW6wHo6UgOmJC+xEvnW/kWSM=
X-Received: by 2002:a02:6d6c:: with SMTP id e44mr24219651jaf.81.1622536412372;
 Tue, 01 Jun 2021 01:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210527174547.109269-1-uvv.mail@gmail.com> <20210527174547.109269-3-uvv.mail@gmail.com>
 <CAOQ4uxh7eSy6xAr9HdtZ=trcpUs8O5exXWJ8uqo2bacfMZXz3Q@mail.gmail.com> <AM8PR10MB4161DB3BDC0D415D5D3D5154863E9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AM8PR10MB4161DB3BDC0D415D5D3D5154863E9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 1 Jun 2021 11:33:21 +0300
Message-ID: <CAOQ4uxhN6t1fke1XxRndb9UN1M2sY9LVL9zKW_xj9xsXUrhr-Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ovl: do not set overlay.opaque for new directories
To:     "Yurkov, Vyacheslav" <Vyacheslav.Yurkov@bruker.com>
Cc:     Vyacheslav Yurkov <uvv.mail@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 1, 2021 at 9:54 AM Yurkov, Vyacheslav
<Vyacheslav.Yurkov@bruker.com> wrote:
>
> Hi Amir,
> Thanks again for the review and a heads-up about the tests. I was not aware they exist.
>
> It took me some time to set them up due to really peculiar Makefile, but I now even have a yocto recipe to build them (will file it upstream later).
>
> The latest master and my v3 both report the same results:
> Failures: overlay/005 overlay/065 overlay/075
> Failed 3 of 93 tests
> (The full log is attached)
>
> I assume the failures come due to my specific configuration, but since master and v3 issue the same results I should be fine here.

Maybe.
Failure of overlay/075 on master is known.
Failure of overlay/065 on master was fixed by xfstests commit
* 6159ae7f - overlay/065: Adapt test to relaxed rules
so you may want to update your xfstests copy.

Failure of overlay/005 is not familiar to me and the
attached log is missing all the output of the test -
it just has the summary.

Worst yet, according to summary, all those test do not run in your setup:
Not run: overlay/001 overlay/004 overlay/008 overlay/015 overlay/020
overlay/021 overlay/025 overlay/032 overlay/045 overlay/046
overlay/056 overlay/064 overlay/100 overlay/101 overlay/102
overlay/103 overlay/104 overlay/105 overlay/106 overlay/107
overlay/108 overlay/109 overlay/110 overlay/111 overlay/112
overlay/113 overlay/114 overlay/115 overlay/116 overlay/117

Can you provide the full log to understand the reason or figure it out yourself
and fix this.
If you are running a special setup that is fine, it doesn't have to
run all the test
(as long as you know why), but in order to verify that your patches did not
break other setups, you need to test with a common setup where all the
above tests run and pass, short of overlay/075 which is a known upstream issue.


>
> v2 indeed caused a few more failures on top of that:
> Failures: overlay/005 overlay/065 overlay/070 overlay/071 overlay/075
> Failed 5 of 93 tests
>

I'm a bit surprised that tests overlay/068 overlay/069 did not fail with v2
Maybe they did not run and you did not notice that in the report?

> Could you please tell me just for my information what's the usual time frame to have my v3 mainlined?
>

Miklos would have to answer this question.
It shouldn't take long if he agrees with the patch.

Thanks,
Amir.
