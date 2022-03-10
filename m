Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6BFC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 10 Mar 2022 22:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344290AbiCJWMX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 17:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245170AbiCJWMW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Mar 2022 17:12:22 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5EF1959FA
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Mar 2022 14:11:18 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id d10so15131643eje.10
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Mar 2022 14:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9km0i8SFuccdCOVZYquGLNsFmsoS5afCtujPM89debo=;
        b=DkO/8stlw+jpHvI8npwNphLXTcJGdwo5HGKNzsLEQgRJKoqLNqUtQ14rO8YztWtv6H
         bAxp1qhPNeH3fynL0mw7GJsoth6uZUwOJRQT3vdvrEI2RpF54ufTb0yXO3++rTXBespQ
         x5lpjmtoM0L6NN0u9NAmn1YkWynYbmAVkFmqK9RxmA3NcICSIgE9yAEScpXJQ4VdYV+H
         qGhCj6APjWltlRC5qBmw4vuoMHC3nKYsIbGWFHWJaXvc4I/QXkVgLDu0Y46f5aCQWnEh
         nBP1d+G1PMaC87QCOjKfloK3Lw9CLGuuIdMcOaJnRc9h+7uDqcwjICH2qyHuewLribm8
         lAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9km0i8SFuccdCOVZYquGLNsFmsoS5afCtujPM89debo=;
        b=4Os6KkeB+nFxNCUEv+1c/QlxyQH/lyEhFbPpM3+ajqDUfO5FrkwDlDSGcWUYIOhPqT
         5EWUjayGy+jQ247gWF8HwXXAsFHrisbdMEwCrN5dEXDwFqIM7h3z6X95TJn9I7Vhzcyd
         7rpUnOTu1Vm2EtcU90Z3sx8CxX4/ZIFUNzTtX/IC54Y+ievgbuNTvQRegFwv5DNnYkDQ
         NJ30kXgYVIPeMAo/lR82sZ89siPV+z4ku59Hifzd6nwlG+KG5hi0lFatMQ4Q+oIw+hqv
         jgB4ZueQ5wcJm8tl2UTi6f0tgvS/q6Y5ZxqE3SO7MMxTqB9S0nHN9FEGWcSai5EFDoGo
         O5PA==
X-Gm-Message-State: AOAM530sr9VcckhwZgcT1gXUoKanuU2Hi9L5URkDMazVa0A9pLbZ7m7q
        CC+vxRCRhz4WuAPqVHlqWG4b6xJFjRTUEPSL3kO8
X-Google-Smtp-Source: ABdhPJzuqe7pKCSsXOm2hSO3J0hQynYE7R+uH9xz7Xj/FjdVN2m1z54F4ZugUJ/pEbmhBHGUILXKrslgjHDns1/T+QA=
X-Received: by 2002:a17:907:216f:b0:6ce:d85f:35cf with SMTP id
 rl15-20020a170907216f00b006ced85f35cfmr6109610ejb.517.1646950277373; Thu, 10
 Mar 2022 14:11:17 -0800 (PST)
MIME-Version: 1.0
References: <20211117015806.2192263-1-dvander@google.com> <CAOQ4uxjjapFeOAFGLmsXObdgFVYLfNer-rnnee1RR+joxK3xYg@mail.gmail.com>
 <Yao51m9EXszPsxNN@redhat.com> <CAOQ4uxjk4piLyx67Ena-FfypDVWzRqVN0xmFUXXPYa+SC4Q-vQ@mail.gmail.com>
 <YapjNRrjpDu2a5qQ@redhat.com> <CAHC9VhQTUgBRBEz_wFX8daSA70nGJCJLXj8Yvcqr5+DHcfDmwA@mail.gmail.com>
 <CA+FmFJA-r+JgMqObNCvE_X+L6jxWtDrczM9Jh0L38Fq-6mnbbA@mail.gmail.com> <CAHC9VhRer7UWdZyizWO4VuxrgQDnLCOyj8LO7P6T5BGjd=s9zQ@mail.gmail.com>
In-Reply-To: <CAHC9VhRer7UWdZyizWO4VuxrgQDnLCOyj8LO7P6T5BGjd=s9zQ@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 10 Mar 2022 17:11:05 -0500
Message-ID: <CAHC9VhQkLSBGQ-F5Oi9p3G6L7Bf_jQMWAxug_G4bSOJ0_cYXxQ@mail.gmail.com>
Subject: Re: [PATCH v19 0/4] overlayfs override_creds=off & nested get xattr fix
To:     Vivek Goyal <vgoyal@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        David Anderson <dvander@google.com>
Cc:     Mark Salyzyn <salyzyn@android.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        John Stultz <john.stultz@linaro.org>,
        linux-doc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        kernel-team <kernel-team@android.com>, selinux@vger.kernel.org,
        paulmoore@microsoft.com, luca.boccassi@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Mar 9, 2022 at 4:13 PM Paul Moore <paul@paul-moore.com> wrote:
> On Tue, Mar 1, 2022 at 12:05 AM David Anderson <dvander@google.com> wrote=
:
> > On Mon, Feb 28, 2022 at 5:09 PM Paul Moore <paul@paul-moore.com> wrote:

...

> >> This patchset may not have been The Answer, but surely there is
> >> something we can do to support this use-case.
> >
> > Yup exactly, and we still need patches 3 & 4 to deal with this. My curr=
ent plan is to try and rework our sepolicy (we have some ideas on how it co=
uld be made compatible with how overlayfs works). If that doesn't pan out w=
e'll revisit these patches and think harder about how to deal with the cohe=
rency issues.
>
> Can you elaborate a bit more on the coherency issues?  Is this the dir
> cache issue that is alluded to in the patchset?  Anything else that
> has come up on review?
>
> Before I start looking at the dir cache in any detail, did you have
> any thoughts on how to resolve the problems that have arisen?

David, Vivek, Amir, Miklos, or anyone for that matter, can you please
go into more detail on the cache issues?  I *think* I may have found a
potential solution for an issue that could arise when the credential
override is not in place, but I'm not certain it's the only issue :)

There is motivation on our part to try and get the
"override_creds=3Doff" portion of the patchset working and suitable for
upstreaming, but I need some help in making sure I understand all the
objections/problems.

--=20
paul-moore.com
