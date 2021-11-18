Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF38C4332F
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Nov 2021 20:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F3061ABD
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Nov 2021 20:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhKRUSk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 18 Nov 2021 15:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbhKRUSh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Nov 2021 15:18:37 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1170C06174A
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Nov 2021 12:15:36 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id o1so16476708uap.4
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Nov 2021 12:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZrRZvyyDsGvVYFqi5baF2Q5QtEo8Nna9wXy1CrK0gM=;
        b=q9fWoaO1PaE0IQTJUe+W1l3llJpWJf45hhSm/lM5UHhwXa5xfhQXtJuQ8v7d2kVfLG
         Q0MW8t2BFIkLbdiXZRAb6vbkO3rDNbb6ddHoa0OdjMah9DrmRciYfwq2LIdeD0rmcT95
         by+jgZQKnd0hAkXWdlf77SvXBBuXuNdVl9sZrQGAq4neQYAkqCWl2RasbLXFc4lYCewz
         HEJepBKcg/vaXWYVA4D9oZDsrj+owLxVMLGizS+9gdaiVU/4j3uU9nXExsFarpeb3bTH
         13noovfOMq0s7w6nzM/al1CT0KojvwHCCN7+zKFJdkFSMpFq4mBWu4trR279/ZINTRJH
         0cJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZrRZvyyDsGvVYFqi5baF2Q5QtEo8Nna9wXy1CrK0gM=;
        b=KqlnNW0qNTnUkrMA0B0uqlpE+/tbuAi7QvnXhqV9iCOgaTIVeEslTqCqPDddqwQeeC
         kWPXM++xZeoqKCSCVozApcZI68TKbcOg4++u7/F17SBjZKG6vVTwgC7lTF9V7NN9qCvC
         9cI1LhiQOSil/Way1KKodQbGhwby6YTu4O7oMJgjir/wYsPeBPGZXeM1nAbuq6ldtfnx
         2Q8lvuHE5ZGp9cqBLKCl5NtEKx4w6Ltx7UYlU2tlk+KrwqGcitKJy/XsOPc5FoefBk5H
         bKm1xcVq8TOX1ZkWXi1nldrAgUoPEEgd99gbMWoNQDoKVmTNlr4hH7cWVyhWrsQOkq2N
         wX2g==
X-Gm-Message-State: AOAM533DnjxwMDucyEu+HvoGG5koY+2+rlCIsGgu+Bvt4Vxh4zmOhOkv
        XDK5JOBOKgt/rzf5WkTeND3NsYE9rW0YpbRc/ch8sQ==
X-Google-Smtp-Source: ABdhPJxHFUCc+WUUd399fBE5Ghx3J7BnK1uGonGfyC+5xkMxEpmNTnbbWClx48VnjHf+mjM8fBizpDMoQ5Gwi/jMSlQ=
X-Received: by 2002:a05:6102:5109:: with SMTP id bm9mr83505136vsb.10.1637266535455;
 Thu, 18 Nov 2021 12:15:35 -0800 (PST)
MIME-Version: 1.0
References: <20211117015806.2192263-1-dvander@google.com> <CAOQ4uxjjapFeOAFGLmsXObdgFVYLfNer-rnnee1RR+joxK3xYg@mail.gmail.com>
 <CA+FmFJBDwt52Z-dVGfuUcnRMiMtGPhK4cCQJ=J_fg0r3x-b6ng@mail.gmail.com> <CAOQ4uxjTRfwGrXuWjACZyEQTozxUHTabJsN7yH5wCJcAapm-6g@mail.gmail.com>
In-Reply-To: <CAOQ4uxjTRfwGrXuWjACZyEQTozxUHTabJsN7yH5wCJcAapm-6g@mail.gmail.com>
From:   David Anderson <dvander@google.com>
Date:   Thu, 18 Nov 2021 12:15:24 -0800
Message-ID: <CA+FmFJB1MwPVeuTJ=MJxH7AV+T-3EiHZvXTzhrQBX0=EJKqC-Q@mail.gmail.com>
Subject: Re: [PATCH v19 0/4] overlayfs override_creds=off & nested get xattr fix
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Mark Salyzyn <salyzyn@android.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Jonathan Corbet <corbet@lwn.net>,
        Vivek Goyal <vgoyal@redhat.com>,
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
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Nov 18, 2021 at 2:20 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Nov 18, 2021 at 11:53 AM David Anderson <dvander@google.com> wrote:
> >
> > On Tue, Nov 16, 2021 at 11:36 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > > Hi David,
> > >
> > > I see that the patch set has changed hands (presumably to Android upstreaming
> > > team), but you just rebased v18 without addressing the maintainers concerns [1].
> >
> > Indeed I'm carrying this forward as Mark is no longer working on it.
> > My apologies for
> > missing those comments!
> >
> > > Specifically, the patch 2/4 is very wrong for unprivileged mount and
> > > I think that the very noisy patch 1/4 could be completely avoided:
> > > Can't you use -o userxattr mount option for Android use case and limit
> > > the manipulation of user.ovrelay.* xattr based on sepolicy for actors
> > > that are allowed
> > > to make changes in overlayfs mount? or not limit at all?
> > > The access to those xattr is forbidden via "incoming" xattr ops on
> > > overlay inodes.
> >
> > Can you clarify a bit more? The patch is definitely super noisy and I'd love
> > to have a better solution. The problem it's trying to solve is:
> >  1. Kernel-privileged init mounts /mnt/blah-lower and /mnt/blah-upper.
> >  2. Kernel-privileged init mounts /blah with overlayfs using the above dirs.
> >  2. Kernel-privileged init loads sepolicy off /blah/policy. Enforcing begins.
> >  3. Kernel-privileged init tries to execute /blah/init to initiate a
> > domain transition.
> >  4. exec() fails because the overlayfs mounter creds (kernel domain) does
> >      not have getxattr permission to /blah/init.
> >
> > Eg, we're hitting this problem without even making changes to the mount, and
> > without anything being written to /mnt/blah-upper.
> >
>
> So what is your solution?
> Remove the security check from overlayfs setting xattr?
> How does that work for the person who composed the security policy?
> You will need to grant some basic privileges to the mounter.
> If you do not want to grant the mounter privileges to set trusted.overlay xattr
> you may use mount option -o userxattr and grant it permissions to set
> user.overlay xattrs.

Thanks for the tips. I think it might be possible for us to work
around this one in
userspace, either by granting the mounter this one permission across
all contexts,
or with a much narrower kernel fix that doesn't require us keeping the big noisy
patch in our tree.

> > > Can an unprivileged user create an overlay over a directory that they have
> > > access to and redirect an innocent looking file name to an underlying file that
> > > said the mounting user has no access to and by doing that, tricking a privileged
> > > user to modify the innocent looking file on the  mounter's behalf?
> > > Of course this could be avoided by forbidding unprivileged mount with
> > > override_creds=off, but there could be other scenarios, so a clear model
> > > would help to understand the risks.
> > >
> > > For example:
> > > If user 1 was able to read in lower dir A, now the content of overlay dir A
> > > is cached and user 2, that has permissions to read upper dir A and does
> > > not have read permissions on lower dir A will see the content of lower dir A.
> >
> > I'll need to think about this more and test to verify. It's not a scenario that
> > would come up in our use case (both dirs effectively have the same permissions).
> >
>
> Your argument is taking the wrong POV.
> The reason that previous posts of this patch set have been rejected
> is not because it doesn't work for your use case.
> It is because other players can exploit the feature to bypass security
> policies, so the feature cannot be merged as is.

Ack, understood.

> > If the answer is "yes, that can happen" - do you see this as a problem of
> > clarifying the model, or a problem of fixing that loophole?
> >
>
> It is something that is not at all easy to fix.
> In the example above, instead of checking permissions against the
> overlay inode (on "incoming" readdir) will need to check permissions of every
> accessing user against all layers, before allowing access to the merged
> directory content (which is cached).
> A lot more work - and this is just for this one example.

I see your point. If we could implement that, behind a mount flag, would that be
an acceptable solution?

> > >> I think that the core problem with the approach is using Non-uniform
> > > credentials to access underlying layers. I don't see a simple way around
> > > a big audit that checks all those cases, but maybe I'm missing some quick
> > > shortcut or maybe your use case can add some restrictions about the
> > > users that could access this overlay that would simplify the generic problem.
> >
> > In a security model like ours, I think there's no way around it, that
> > we really need
> > accesses to be from the caller's credentials and not the mounter's. It's even
> > worse than earlier iterations of this patch perhaps let on: we mount
> > before sepolicy
> > is loaded (so we can overlay the policy itself), and thus the
> > mounter's creds are
> > effectively "the kernel". This domain is highly restricted in our
> > sepolicy for obvious
> > reasons. There's no way our security team will let us unrestrict it.
> >
>
> Not sure what that means or what I can do with this information.
> If I had a simple suggestion on how to solve your problem I would have
> suggested it, but I cannot think of any right now.
> The best I can do is to try to make you understand the problems that your
> patch causes to others, so you can figure out a way that meets your goals
> without breaking other use cases.

To help clarify, we do not have any processes which have access to everything.
Almost every file in the system has a specific selabel and processes are only
granted access to the labels they need.

To give the mounter (init in kernel domain) access to every single label doesn't
make sense. It only makes sense to have the access be "passthrough", making
overlayfs as transparent as possible.

Best,

-David

>
> Thanks,
> Amir.
