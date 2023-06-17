Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F030EB64D9
	for <linux-unionfs@archiver.kernel.org>; Sat, 17 Jun 2023 19:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjFQTT0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 17 Jun 2023 15:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjFQTTZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 17 Jun 2023 15:19:25 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512B01732
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 12:19:22 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9883123260fso54548066b.0
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 12:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1687029561; x=1689621561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KFvSNBL1R1KRb0n8ukq7b3+2HLtoNOHt6ooK5vyCn3M=;
        b=Rurw46dH1jwQf+PbNHix5qzd7h7K3xHxc7jFG4yPHqcU/y5r6HjurLDq3oivkJBp5/
         Vjt2PwuB6qbEyVp9bFzcqJKJ7+I4tWHiB3FbCqUzmpNVMdzR5s9Fs7BbJA0B/SRZCccD
         j3OzR8aQVtfJhr0ry3u1qokHbx4E8wcmccxhw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687029561; x=1689621561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KFvSNBL1R1KRb0n8ukq7b3+2HLtoNOHt6ooK5vyCn3M=;
        b=RCaX1lP1wbmNiwzlZ93aeN30D7XZDGZxob3TJGmo5MWlMg+mURebSIFsfl7LkLqV7i
         SHF3y4jWaJMprzxA4UZ2VLYd2u9iuOtoLpo4SY0fc+M3t3IEUVV8EeTo3aj14wx3dWSU
         gRdAnUUMUbofF0n9aZCMF0KD6L9n7tOtMvYCH1nE6zPESh4T3rMfq08UltFsnw6iriKs
         akwhUHOujiuoLn85wv9K9t7iWig+aQwhThfSxqurAIKwAfmMyMxRmcfcUSEHGVM5IDgy
         x3ZLMAkecgmG1iW11VBFeZMuI2IRU7XzOgSeG7BmhiZs2CGPlXf43HQr8DvW3opwLfB5
         Jb/w==
X-Gm-Message-State: AC+VfDyepDrRayxSSwT4PlmxHlgQNGzn55ziT+idRZZqu2rbLiKf8Z0G
        HsDBBx17i1P11vYpp58wonbOJCRxjcmO/TgAQK6G6w==
X-Google-Smtp-Source: ACHHUZ52RVk2g7P/9tEl9ELdwmB/fAa6N/I+JJGjrJb/UUfGpnIoJX1tOuf+MvxdkfKGRhWqGMfvsh4D4ZiP8dXPpoo=
X-Received: by 2002:a17:907:1b08:b0:971:eb29:a082 with SMTP id
 mp8-20020a1709071b0800b00971eb29a082mr5172612ejc.49.1687029560705; Sat, 17
 Jun 2023 12:19:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com> <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
 <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
 <CAOQ4uxh14O9aRiewc+nq+AL-029YGu4bb4AZpp854r78Jm=_dw@mail.gmail.com>
 <CAJfpegvnBrLtNcW0Oy8Y7seju96scQ0-FHoiXxx3+A3X4N_LMQ@mail.gmail.com>
 <CAOQ4uxjPe5DBBFN5XfUPoYE1rKdbzTLsP9yOa2V9Ej4K8U4oEA@mail.gmail.com>
 <CAJfpegvnGe0e5Kp5hh6y4PES7xbr=LmgzOeXnFbBs9StcCou2g@mail.gmail.com> <CAOQ4uxjMOdSWhz0KPUanzM_UCyiQ6rMgNU4ouDsfmTN8X=+7Hg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjMOdSWhz0KPUanzM_UCyiQ6rMgNU4ouDsfmTN8X=+7Hg@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Sat, 17 Jun 2023 21:19:09 +0200
Message-ID: <CAJfpegveRyJ4rdgcR29D8kbnAG43ZQOY9DHfV4L0301egFHLfw@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 17 Jun 2023 at 19:40, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Jun 9, 2023 at 4:52=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
> >
> > On Fri, 9 Jun 2023 at 15:42, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > > Miklos,
> > >
> > > I see you pushed the branch as is.
> > >
> > > Please be warned that it contains the following unexplained
> > > merge commit:
> > >
> > > commit b892fac09d57668181ff5c433958e96ec7755453
> > > Merge: f1fcbaa18b28 7cdafe6cc4a6
> > > Author: Amir Goldstein <amir73il@gmail.com>
> > > Date:   Thu May 25 15:14:13 2023 +0300
> > >
> > >     Merge remote-tracking branch 'jack/fsnotify' into next
> > >
> > > And you know how Linus hates unexplained merge commits.
> > >
> > > In this case, it is unexplained and also does not have a
> > > good reason in the context of an ovl pull request.
> >
> > Yes, I will redo this, but for getting into -next this will do.
> >
>
> Miklos,
>
> I found a memory leak in these patches (reported by kmemleak).
> For negative dentries, oe was allocated but not stored and not
> freed.
>
> Below is diff -w of the fix.
> I squashed this fix into:
> "ovl: move ovl_entry into ovl_inode"
> and pushed the fixed overlayfs-next to my github [1]
> I've also reabsed overlayfs-next onto 6.4-rc6.
>
> Let me know if you want me to ask Steven to pull the fixed
> branch into linux-next.

I pushed this to overlayfs-next.  I'm still reviewing the rest...

Thanks,
Miklos
