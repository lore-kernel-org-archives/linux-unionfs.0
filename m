Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BACC433FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 10 Dec 2020 15:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B3223117
	for <linux-unionfs@archiver.kernel.org>; Thu, 10 Dec 2020 15:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391250AbgLJPUS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 10:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391138AbgLJPUR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Dec 2020 10:20:17 -0500
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2BAC061793
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Dec 2020 07:19:31 -0800 (PST)
Received: by mail-vk1-xa41.google.com with SMTP id j142so1286319vkj.9
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Dec 2020 07:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9MkRqt104RVsv5N+YB6WxXi+teVxnu9MbnHIdbKaCUs=;
        b=d2WuHo1tCik0k3Fg5z/lUis7T2/Ee7ntUJkrfJIDMKNZFR0sI4ru2CJ8lp2K0L7thL
         jZxi5N4bJ1s++KgIpr23I6EHVZ5gSxWGuSZq3q+LaV+kgYt49JkqZpHxxuTzgW6fP6X+
         43DjTtxU7TEbsPKG5fNlTQ3WBI2Ih02t2E7Fw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9MkRqt104RVsv5N+YB6WxXi+teVxnu9MbnHIdbKaCUs=;
        b=VSf7irOjT9TEF8xFMK+utEUSLhm/7XmWv0xOA4lMCMRAo0XNcQkiLikOtFotAeOLnl
         us2W1DX8TMZP8GpY+GP/u0KSGy/ijILL9FadPnOSbgE1xUTr98k6PNmxambXG3eTBH2f
         X3Y/2E6bzrIfuWC+0psuA9n9IWJSs9U5Mg8o5E/1QCiU9qvBdAR4Rz6yC7EAawgySN3Q
         V8jwTTWgL8akJL2cKDgiIwK0e9BtdVoh0xPaDRWySHPK7In8u0x2zwqAr7eLs5HqOh0M
         TYax41IrC3qW7FoI5OGlVzofviBuaP4EMR8VPecsRJRmuQnWp5APd9H289txdkPtDT6g
         7O9Q==
X-Gm-Message-State: AOAM532IidFmBJjEYo0po9dKw8UTCeYxYEWPSH6xQ1Ah+fBO6emWux3f
        ljeM36asGoSBlGPX17CjczOMXr5/1gC/ol0pqm1qXA==
X-Google-Smtp-Source: ABdhPJwvjRSAI1kxVXNit/fyHFyd319loOtIx2YFfsD0fjD4NxOYqVS5hiDeAbWdDM8beKfUnfhU76Wfa2EXqxGrHHY=
X-Received: by 2002:a1f:b245:: with SMTP id b66mr9258645vkf.3.1607613570896;
 Thu, 10 Dec 2020 07:19:30 -0800 (PST)
MIME-Version: 1.0
References: <20201207163255.564116-1-mszeredi@redhat.com> <20201207163255.564116-5-mszeredi@redhat.com>
 <e5876ecc-1cce-76d0-528-40b9bc54d0c2@namei.org>
In-Reply-To: <e5876ecc-1cce-76d0-528-40b9bc54d0c2@namei.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 10 Dec 2020 16:19:19 +0100
Message-ID: <CAJfpeguHYNK7G23u+3v34pzrP0N3xw5cpFT3n2ktgjvntvfABQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] ovl: make ioctl() safe
To:     James Morris <jmorris@namei.org>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Dec 9, 2020 at 3:01 AM James Morris <jmorris@namei.org> wrote:
>
> On Mon, 7 Dec 2020, Miklos Szeredi wrote:
>
> > ovl_ioctl_set_flags() does a capability check using flags, but then the
> > real ioctl double-fetches flags and uses potentially different value.
> >
> > The "Check the capability before cred override" comment misleading: user
> > can skip this check by presenting benign flags first and then overwriting
> > them to non-benign flags.
>
> Is this a security bug which should be fixed in stable?

Yes, good point.  Added Cc: stable@...

Thanks,
Miklos
