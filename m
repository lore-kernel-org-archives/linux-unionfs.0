Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A80C433B4
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Apr 2021 16:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70F2F6109E
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Apr 2021 16:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhD3QRe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 12:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhD3QRd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Apr 2021 12:17:33 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8BCC06174A
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Apr 2021 09:16:44 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l19so16071638ilk.13
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Apr 2021 09:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XHWBTc3PH6SZ0SgPff0DkBbrhaSkxqgRiINPZXz0SQs=;
        b=fX9kjGP3XqLtVL4XgExuizN56LWIYg1CiDx2zhwElwiCMCs5pLCRmko9UAHvGp/i/e
         9lpkY6f2riz66zvL5HoJKweX2xuoHlTWA2L7D9+e666OWPpjFcK3ywyb/KbXrgRXxWXy
         cGMICDUmERigGFKSW0H8Oy+G0Xj1stZ8F7KgeXDuGheofZee3HWuJtXCEJ+u+urU5uU4
         wTpVI7ix1kVP8fWnYmKoi97nEeiViMUI0CW+pddvsH4jHGtG+ZWnh7xOfc1ioq7pVzX8
         vVVakFt7AC3/Yq2/NoaYpJfD6+L+eUiVnE5MHda165/MyQqUbBBpCv1ACCs032FicfKo
         FESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XHWBTc3PH6SZ0SgPff0DkBbrhaSkxqgRiINPZXz0SQs=;
        b=ZxtMMZVuFUy4jMBnR8nGSb2hwsc0+kZgtvCVVGoY0zglj3VJ8uz98mbyempGUmyXbU
         OHc94078HLtWm0kxIv1CEKbPPfJO6SFd6oRDFiHH18VwwInG8FHynE4T0ojtpf3YAusN
         3dLq2SRdSYeVg9PCHGE8FZiqeF/TsaomKH0ltq8cyCEscLzOdr9PAUrZwcwhLcLk63QV
         WF5WY3J5zZd/VkULCDbwweskmcjmXGTtpfOuy7QYu91IP99Ni4A0yBLUTzflQmbIVIZP
         igZX2FPmZbVkisd/3+laiJBnFXEN9O1tNkULf6KDeJQbOv9ZKOx6pFBvYsC4ESGhlKIw
         CFjA==
X-Gm-Message-State: AOAM5312CAN7J1XAXBaB2Oud47L2sGiq5uwq7o76It0BhdsuWHSTZcCE
        3uch2PvRXhpseLqcEFdLVWR23yFSc1xxTjsJ/bI=
X-Google-Smtp-Source: ABdhPJys0RUTC5f/yc/amXR4LceQiCR3+4nv09Ft1ZisJoLTAq8mzj8zhM5AVy/cyE8cPPiGNy2qjka32j3XUhmDN24=
X-Received: by 2002:a92:de41:: with SMTP id e1mr4930868ilr.250.1619799403982;
 Fri, 30 Apr 2021 09:16:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210427102826.1189410-1-amir73il@gmail.com> <123ca2cd.45f7.1792236c0e9.Coremail.ouyangxuan10@163.com>
In-Reply-To: <123ca2cd.45f7.1792236c0e9.Coremail.ouyangxuan10@163.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 30 Apr 2021 19:16:28 +0300
Message-ID: <CAOQ4uxh7So5F3H_qY+nDXV_u+8A9K8B+275mTb1deedO_9Fg+Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax lookup error on mismatch origin ftype
To:     www <ouyangxuan10@163.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 30, 2021 at 12:59 PM www <ouyangxuan10@163.com> wrote:
>
> Hi Amir,
>
>
> Thank you very much for your help.  I have another question to clarify.
>
> >> 3. If we upgrade overlayfs separately, we are not very good at verifying that we have solved this problem, because the recurrence probability of this problem is very low. So I want to ask, how can we quickly reproduce this problem?
>
> >Re-creating a lower squashfs after files have been copied to upper should
> >reproduce the problem quite often.
>
> Does the re-creating lower squashfs here mean that remount squashfs?
> I've tested dozens of times in the remount way, but I haven't found this problem again?
> My test steps are:
> 1). umount lower squashfs;
> 2). modify the file in upper dir;
> 3). mount lower squanshfs;
> 4). restart service(it will re-parse the modified file)  or reboot the system and the problem didn't happen.
>

No. That's not what I mean by re-creating lower fs.
What I mean is that overlayfs is the file is question is in the squashfs
image and has been copied up.

I don't know where the squashfs image you are using comes from
but I am guessing you have replaced it with a new squashfs image.
In the new squashfs image, files have different inode numbers.

I reckon this behavior is common for OpenWRT where the system
image is being upgraded.

>
> At 2021-04-27 18:28:26, "Amir Goldstein" <amir73il@gmail.com> wrote:
> >We get occasional reports of lookup errors due to mismatched
> >origin ftype from users that re-format a lower squashfs image.
> >
> >Commit 13c6ad0f45fd ("ovl: document lower modification caveats")
> >tries to discourage the practice of re-formating lower layers and
> >describes the expected behavior as undefined.
> >
> >Commit b0e0f69731cd ("ovl: restrict lower null uuid for "xino=auto"")
> >limits the configurations in which origin file handles are followed.
> >
> >In addition to these measures, change the behavior in case of detecting
> >a mismatch origin ftype in lookup to issue a warning, not follow origin,
> >but not fail the lookup operation either.
> >
> >That should make overall more users happy without any big consequences.
> >
>
> We can't do that. When overlayfs reports an error, there may be some very important files that cannot be correctly parsed, resulting in some important services can not be started smoothly, which directly affects the use of the whole system.

Well, that is the purpose of my patch -
When overlayfs reports the warning it will NOT prevent reading the
file, so it should NOT make the whole system unusable.

Thanks,
Amir.
