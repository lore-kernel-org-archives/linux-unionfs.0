Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9273E748ED
	for <linux-unionfs@archiver.kernel.org>; Sun,  1 Oct 2023 12:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbjJAMmc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 1 Oct 2023 08:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjJAMmc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 1 Oct 2023 08:42:32 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FF799;
        Sun,  1 Oct 2023 05:42:29 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-4527d65354bso6947166137.0;
        Sun, 01 Oct 2023 05:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696164148; x=1696768948; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5jNZUk6it4QYZxL9++dfSem+3+3rWlI5HjzgyYo8pK0=;
        b=QW7qSeUBb3j7Gdn/8apKxD4EK6rf7xZUMDVgrhuGHZDaIdGai4xzW5WjoB/iQmLllp
         56bFKYJ8OL4dQt/sZF0hAZeOaiIHEVO+WuTmg36+pAxT/Wsn354tpuQzWpsc2MhgegLX
         UwdgKKuVdL/8nw4i6p1aSbxBsyjVzpiI6w8MslUpV/s/SdonvQlGXbg7hEsyV8tEeSdt
         GkDorn34kROl0EEA5c3MnUC8tzRxoKOAtOyYjq/qS5SgUgs4x6FETUGstX3rFeDKMRmm
         LCrSpLFAamGKcGePa1Fvp9E2aqDUvpftt4brniuz2PYx1BPHll/bQL9bGZ6lHy7OPZze
         nJJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696164148; x=1696768948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5jNZUk6it4QYZxL9++dfSem+3+3rWlI5HjzgyYo8pK0=;
        b=CggxPKW9CFeEWZDndwfN06VQTdC7Bq27HlfwKqaEKsZx6U72nA4kWzyv+10R/xanbI
         3kBY5OvG6UBPpTDX/dKWdNmYWxKhq2LpPM0R9wGHYLOLIklc2/jQpSK3F/rXfhmYq8cV
         ADku5gxiCEbSHjeLOFw9hkyrxzEliDi4sxNVYX8o9lARzOysfkWZMN6StQrpuyTlM8Cj
         kk/ag8ep/rGQQWC9Ny4R1EB4gGPZqhLD22C7HMe4eEjmyckjlAIJdHWFsTV73oflrvmI
         0a9mA7SWmXV+vruwv2wxCGkaSPD5k3F/HhBgFVoL4+mWnPSFwMRD3ovGtb0e+rOE73Xy
         0ETg==
X-Gm-Message-State: AOJu0YxIJPN4M1nRLtGlBKq/amMFKaO3WWrYFNpDvnFgFnw6TbreXnpw
        YFacthAzZrQ8ZZvT5Eo3jWotQY2zMhqLl1C9CRXPXlb6qEc=
X-Google-Smtp-Source: AGHT+IEJA2ncZm8jhxpgZ3oi1ko5qh9+rZ7SmY6VDQGTco+kpr6HcFITtAOrl4e5HDt9BClp+IyntgOPOXAjMUv0tzg=
X-Received: by 2002:a05:6102:52a:b0:450:fcad:ff18 with SMTP id
 m10-20020a056102052a00b00450fcadff18mr7863898vsa.34.1696164148558; Sun, 01
 Oct 2023 05:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230928202834.47640-1-uvv.mail@gmail.com> <CAOQ4uxhx59ZnMbhLTL85M1VQta6AZ2oqe9gMQJcN1qiAzOu6tQ@mail.gmail.com>
 <9e57cce1-2eca-411d-98a4-3321823d8f3d@gmail.com>
In-Reply-To: <9e57cce1-2eca-411d-98a4-3321823d8f3d@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 1 Oct 2023 15:42:17 +0300
Message-ID: <CAOQ4uxjawFZv_6NGKvmiVBfAL2eqExwXhunf=C-_yL3eAcD_gA@mail.gmail.com>
Subject: Re: [PATCH] README: Update overlayfs URL
To:     Vyacheslav Yurkov <uvv.mail@gmail.com>
Cc:     fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
        linux-unionfs@vger.kernel.org,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Jingbo Xu <jefflexu@linux.alibaba.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Oct 1, 2023 at 3:41=E2=80=AFAM Vyacheslav Yurkov <uvv.mail@gmail.co=
m> wrote:
>
> On 29.09.2023 05:16, Amir Goldstein wrote:
> > On Thu, Sep 28, 2023 at 11:30=E2=80=AFPM Vyacheslav Yurkov <uvv.mail@gm=
ail.com> wrote:
> >> Overlayfs-tools and overlayfs-progs projects have been merged together=
.
> >>
> > Nice :)
> >
> > Do you also have any plans to improve the tools?
>
> Thanks for the review!
> I'll move the instructions completely to README.overlay in V2 then. Is
> there a particular reason that the file starts from an empty line?

No reason.

> (perhaps I could remove that as well in the same patch)
>

OK.

> Right now the plan was only to maintain both projects and accept patches
> from others. Perhaps I will also update the build system to something
> up-to-date. As for further development, unfortunately I don't have a
> project behind ATM to improve the tools further. If something pops up
> (or you have something), I could try to find a capacity for that.

Gao was asking about an offline merge tool, so I pointed him
at overlayfs-tools:

https://lore.kernel.org/linux-unionfs/bc9b3731-9eac-28be-e635-44a098e87d76@=
linux.alibaba.com/

Maybe he can explain what features in specific he was looking for.

Thanks,
Amir.
