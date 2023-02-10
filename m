Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11561C636CD
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Feb 2023 09:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjBJJiu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 10 Feb 2023 04:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjBJJit (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Feb 2023 04:38:49 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF9535268
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Feb 2023 01:38:46 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id qw12so14257831ejc.2
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Feb 2023 01:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+CSs87Bv4X9FdOPYmZI8I7ZXN+lGBiiiGHWUaDXWUyA=;
        b=TC+YKkjyiydGRtrpmt7wSjvM/iGER/SrtSoz1eGq5Dh+7INoGE3CAvWyT6gFuHJw0+
         a+sJLH1pyilAt0mtGhC3FfEB5gEjShtpNWb2dwOI6qQYjTGCc03QzygAayckUSGy9sNH
         EFRK6CyM68LY8wjf+82mfK7pKtnF3BNXmwkjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+CSs87Bv4X9FdOPYmZI8I7ZXN+lGBiiiGHWUaDXWUyA=;
        b=KSIfOKsYs66i522EnW9peMVOyzCLPzWY2zjYFEjlJ2mOfkMtcGsiuyagRO84wdDlOs
         YNdpYz6QWIr5GZttcn29dwqwm1JvbZ51F0EHlFpU7ufQ7t0e5zX9JjnzhKe9bVGgroBG
         Kicw4SQNRRJAYWCVAHeH3xG74xMSfo2VogdEIvHEQikmPzTe+aq0u2oXu/uXf0yXpXp9
         9B8RYYM80gukeJsgwICxN7J+LA8yY3M9ruyD3HUuWHabEiRq6Frbw8Lr4d/llaJX4tdB
         MxuabJdrCMyQk+QaqIn3z+wiGOmuCV8idrlRDujNWx83qdbFSjKinNro9XzxqCZ+CqKo
         zLzg==
X-Gm-Message-State: AO0yUKUEL5c/9L8zvo0ItMPBooChPSmFCStKjB8vvHSr+T42Dy0gr1O9
        CI9DEPhh12J9jJoUJFqGq17mH+bmUmLun8/Mccpwqg==
X-Google-Smtp-Source: AK7set8/uxRNe2y4k4ko7foqw0oR4bOtlspjtdSF2d3Obo3NZCeZRWVf990nwhUQ7Rv9MBGaypXSr2ym9HkQHAkPwKM=
X-Received: by 2002:a17:906:7242:b0:889:a006:7db5 with SMTP id
 n2-20020a170906724200b00889a0067db5mr3229286ejk.138.1676021925106; Fri, 10
 Feb 2023 01:38:45 -0800 (PST)
MIME-Version: 1.0
References: <20221122021536.1629178-1-drosen@google.com> <CAOQ4uxiyRxsZjkku_V2dBMvh1AGiKQx-iPjsD5tmGPv1PgJHvQ@mail.gmail.com>
 <CA+PiJmRLTXfjJmgJm9VRBQeLVkWgaqSq0RMrRY1Vj7q6pV+omw@mail.gmail.com>
 <2dc5e840-0ce8-dae9-99b9-e33d6ccbb016@fastmail.fm> <CAOQ4uxiBD5NXLMXFev7vsCLU5-_o8-_H-XcoMY1aqhOwnADo9w@mail.gmail.com>
 <283b5344-3ef5-7799-e243-13c707388cd8@fastmail.fm> <CAOQ4uxjvUukDSBk977csO5cX=-1HiMHmyQxycbYQgrpLaanddw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjvUukDSBk977csO5cX=-1HiMHmyQxycbYQgrpLaanddw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 10 Feb 2023 10:38:34 +0100
Message-ID: <CAJfpegvHKkCn0UnNRVxFXjjnkOuq0N4xLN4WzpqVX+56DqdjUw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/21] FUSE BPF: A Stacked Filesystem Extension for FUSE
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Bernd Schubert <bernd.schubert@fastmail.fm>,
        Daniel Rosenberg <drosen@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@android.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Nikolaus Rath <Nikolaus@rath.org>,
        Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 3 Feb 2023 at 12:43, Amir Goldstein <amir73il@gmail.com> wrote:

> > Thanks a lot Amir, I'm going to send out an invitation tomorrow. Maybe
> > Nikolaus as libfuse maintainer could also attend?
> >
>
> Since this summit is about kernel filesystem development, I am not sure
> on-prem attendance will be the best option for Nikolaus as we do have
> a quota for
> on-prem attendees, but we should have an option for connecting specific
> attendees remotely for specific sessions, so that could be great.

Not sure.  I think including non-kernel people might be beneficial to
the whole fs development community.  Not saying LSF is the best place,
but it's certainly a possibility.

Nikolaus, I don't even know where you're located.  Do you think it
would make sense for you to attend?

Thanks,
Miklos
