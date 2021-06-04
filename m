Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD84C07E94
	for <linux-unionfs@archiver.kernel.org>; Fri,  4 Jun 2021 12:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 996FA61412
	for <linux-unionfs@archiver.kernel.org>; Fri,  4 Jun 2021 12:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFDMfE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 08:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhFDMfD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 4 Jun 2021 08:35:03 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7250FC06174A
        for <linux-unionfs@vger.kernel.org>; Fri,  4 Jun 2021 05:33:07 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id e17so9829396iol.7
        for <linux-unionfs@vger.kernel.org>; Fri, 04 Jun 2021 05:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bu6m1PhF1iHHp5QEmLgFQ3g1gPjwnHSCGDVGmd6GLBo=;
        b=AHD4+3+AYbNehH64ZewIcdwbjzjhRnE9+OVZQ3BMCpqAQ3/Lg4HBjR+BCZFOjgMLb8
         +ZnUKaaStWCa5BAoy1t2WohxQmT6lkNYVVCOHDKJJED9ne8Mo3XYMi5NKW9VAjCVyCms
         151UKEf4u9Duh/BZ7BfTjk/OluzA+pnE8MMm3ntlQCcoud25dC5nHzF1sM2OyO+VxIO0
         yRGZuWNTLblBB/o0QmmofEkVZ3DHROnaMZIvbvcw3Hn8kJRG4p5Q/lRc6Y2HQGxqfXeq
         pW7ISkxLl64FNypW/oCAVtNt7PU/PMdiI+S/nytIOmdl5lmGPwDT7fEQDkFj2aeORxw9
         bByQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bu6m1PhF1iHHp5QEmLgFQ3g1gPjwnHSCGDVGmd6GLBo=;
        b=r9hQSfrzIE0+A6zu+q21tx+AijZcB2ZTUF+G6WOgPGsx/ZyaUOmzUA2X3nZtpYm2p+
         nxkgamd3Rc6nNDolvfzwNF7EtxrhabM2DgRoA2RCXEuic9PSKuDwo0UEKtgdS2A+j4h+
         kz6HT6C3ku3LYLYrIzRElGq0ODqyCK5nerQvJW/in7utsRYR++Xa6a8t1gq4lwcU3rnx
         jv0yw53Mxpyk0/qz1D4i3ePmzd2FPt/JPZIV2/4gecAsWqssjiu9HaixSSv022Rrn0cR
         DFdsBvlbwlWuAk6XG4HIpfDVJra6RbdjGAHX+WotUsqdjuf2VroQnGumsT3CZ7QCqiO/
         2PUw==
X-Gm-Message-State: AOAM531hSWvcQQY5tcwxedUZvBePFiRPP1KbxRVOkgYSBE28BhRYqL0F
        mKs0Yn+wLB8CVJUXpWBVrINpNbrUw/skosfwz9yLAoej
X-Google-Smtp-Source: ABdhPJzslg1n2yevvqq5/tpmYVl6NCoCnKY/iPTbvuKTIAFYmXxi0p99JMlCVU508aMAb+nR18npUqyZQCOG4joXPQQ=
X-Received: by 2002:a02:908a:: with SMTP id x10mr3898562jaf.30.1622809986764;
 Fri, 04 Jun 2021 05:33:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210527174547.109269-1-uvv.mail@gmail.com> <20210527174547.109269-3-uvv.mail@gmail.com>
 <CAOQ4uxh7eSy6xAr9HdtZ=trcpUs8O5exXWJ8uqo2bacfMZXz3Q@mail.gmail.com>
 <AM8PR10MB4161DB3BDC0D415D5D3D5154863E9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
 <CAOQ4uxhN6t1fke1XxRndb9UN1M2sY9LVL9zKW_xj9xsXUrhr-Q@mail.gmail.com>
 <AM8PR10MB4161781D50CC2656A933D3CE863E9@AM8PR10MB4161.EURPRD10.PROD.OUTLOOK.COM>
 <CAOQ4uxgGHw0WA407waFz2AShDGp9WMRLZjedKtcXNkS6hmvDhQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxgGHw0WA407waFz2AShDGp9WMRLZjedKtcXNkS6hmvDhQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 4 Jun 2021 15:32:55 +0300
Message-ID: <CAOQ4uxiAkMYiTQEg8A61tUU4jGCs9YSCVYuttGiQobif6rhmjA@mail.gmail.com>
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

On Tue, Jun 1, 2021 at 9:29 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jun 1, 2021 at 7:29 PM Yurkov, Vyacheslav
> <Vyacheslav.Yurkov@bruker.com> wrote:
> >
> > Hi Amir,
> > See below.
> >
> > > Maybe.
> > > Failure of overlay/075 on master is known.
> > > Failure of overlay/065 on master was fixed by xfstests commit
> > > * 6159ae7f - overlay/065: Adapt test to relaxed rules
> > > so you may want to update your xfstests copy.
> >
> > Using the latest master now, 065 is still failing for me.
> >
> > > Failure of overlay/005 is not familiar to me and the
> > > attached log is missing all the output of the test -
> > > it just has the summary.
> >
> > The reason was simple, it required xfs as underlying file system (and s=
upport in the kernel), but I had only ext4.
> >
> > > Worst yet, according to summary, all those test do not run in your se=
tup:
> > > Not run: overlay/001 overlay/004 overlay/008 overlay/015 overlay/020
> > > overlay/021 overlay/025 overlay/032 overlay/045 overlay/046
> > > overlay/056 overlay/064 overlay/100 overlay/101 overlay/102
> > > overlay/103 overlay/104 overlay/105 overlay/106 overlay/107
> > > overlay/108 overlay/109 overlay/110 overlay/111 overlay/112
> > > overlay/113 overlay/114 overlay/115 overlay/116 overlay/117
> > >
> > > Can you provide the full log to understand the reason or figure it ou=
t yourself
> > > and fix this.
> > > If you are running a special setup that is fine, it doesn't have to
> > > run all the test
> > > (as long as you know why), but in order to verify that your patches d=
id not
> > > break other setups, you need to test with a common setup where all th=
e
> > > above tests run and pass, short of overlay/075 which is a known upstr=
eam
> > > issue.
> >
> > It seems most of them require unionmount testsuite, which is not a part=
 of xfstests package, and I missed your hint that I should check README.ove=
rlay =E2=98=B9.
> > Some of the other not-running tests needed more spaces (> 1GB), which I=
 don't have on my device. And a few more required a dedicated user/group on=
 the system.
> >
>
> Ok we still need to verify no regressions on those skipped test.
> I can run them on my setup when I get the time if you cannot find
> another test setup which meets the requirements.
>

Run the overlay/quick tests on your patches.
No regressions.

Thanks,
Amir.
