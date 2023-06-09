Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77AAC7EE2E
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jun 2023 13:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjFINw5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 09:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbjFINw4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2023 09:52:56 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84253589
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jun 2023 06:52:43 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-97458c97333so294870066b.2
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jun 2023 06:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1686318762; x=1688910762;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OXVmnhPO4rQ3I3cJ3x5V9gLIOcW3sOVOTfa057h8znA=;
        b=YQ3kunIV4u1cB1zZ2oYnUjTE5onYpkM4XzfmWKzlyjrXcAwYZtcjEo3eWElJZLFbOb
         NH2d1lWVkhBDNQGmcwz+Nt3axHdIL3kh7Iadf+02fL+7gpU0Hgrc0LFYgnjM0j6ML9CA
         fSljLrPTjr8uhexf4ILJWR4JWn+8kPt+NwU04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686318762; x=1688910762;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OXVmnhPO4rQ3I3cJ3x5V9gLIOcW3sOVOTfa057h8znA=;
        b=HhP6mQDl18ERd779jDoVDp/Dhlvenp/2r42OTr46HJ+YYVlZ9NtUFbzHkPyiXU22vO
         vwognxeF20gIY0/qljtOjhGZPnGFraVA6lXWvR3sGjyaH/z4sgsmnElYPczCYecT+kWR
         fMpoGu/GNy244JRdk+Q3LJU5WTBAhCBEJQDUu/rnEZ05GIlnDFGdoBZFwjJo19TqwHXo
         4rJIX7qWHHcTPl/lQpOvW+H7sLTiqvCeefgx1/EE1mtmHmjTvFVo8con3bbqbS2AU3hj
         GlMsKORYLyybV2e4wUWy/trSOw9colAu7G1icfzwHCjhuArW5oj+3hWrh02Z2B2Oho3S
         ho1Q==
X-Gm-Message-State: AC+VfDxq59IwYMhD9xGbt1SCYO/AemMMgSmarPOJPMRZSNAVMs/EeEQF
        paKuNYQ0Hjo8hjo+xbUM+aHAKsh/1lPoxSclWWPNgw==
X-Google-Smtp-Source: ACHHUZ4vJbjHtnNwtLJnydHriaD0/jSgKpE62EXD1tizEOLw/m00ToSV20go+0j9DwiRD4S5avE3gAbcstNLFJNqpSc=
X-Received: by 2002:a17:906:ee86:b0:974:e767:e1e7 with SMTP id
 wt6-20020a170906ee8600b00974e767e1e7mr1972542ejb.28.1686318762237; Fri, 09
 Jun 2023 06:52:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com> <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
 <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
 <CAOQ4uxh14O9aRiewc+nq+AL-029YGu4bb4AZpp854r78Jm=_dw@mail.gmail.com>
 <CAJfpegvnBrLtNcW0Oy8Y7seju96scQ0-FHoiXxx3+A3X4N_LMQ@mail.gmail.com> <CAOQ4uxjPe5DBBFN5XfUPoYE1rKdbzTLsP9yOa2V9Ej4K8U4oEA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjPe5DBBFN5XfUPoYE1rKdbzTLsP9yOa2V9Ej4K8U4oEA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 9 Jun 2023 15:52:30 +0200
Message-ID: <CAJfpegvnGe0e5Kp5hh6y4PES7xbr=LmgzOeXnFbBs9StcCou2g@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 9 Jun 2023 at 15:42, Amir Goldstein <amir73il@gmail.com> wrote:

> Miklos,
>
> I see you pushed the branch as is.
>
> Please be warned that it contains the following unexplained
> merge commit:
>
> commit b892fac09d57668181ff5c433958e96ec7755453
> Merge: f1fcbaa18b28 7cdafe6cc4a6
> Author: Amir Goldstein <amir73il@gmail.com>
> Date:   Thu May 25 15:14:13 2023 +0300
>
>     Merge remote-tracking branch 'jack/fsnotify' into next
>
> And you know how Linus hates unexplained merge commits.
>
> In this case, it is unexplained and also does not have a
> good reason in the context of an ovl pull request.

Yes, I will redo this, but for getting into -next this will do.

Thanks,
Miklos
