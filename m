From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: LXC+overlayfs in unprivileged mode
Date: Wed, 04 Jan 2017 12:47:57 +1300
Message-ID: <87vatvu2mq.fsf@xmission.com>
References: <CAHrUA37sR6ea6UNJZjbAHPWwkoTbtEg7Uq8Z1war9ODA23qcSw@mail.gmail.com>
        <CAOQ4uxi51_0C_-YVz_UYUbOWW3rSjmKv4NUkyxq0oCaWexZ6hw@mail.gmail.com>
        <CAHrUA3575TN8g9xZYrxShapjXy9M1ZWn8BEeZkK65zUJuPOffw@mail.gmail.com>
        <20170103134806.GA29807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:48497 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965063AbdACXvu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Jan 2017 18:51:50 -0500
In-Reply-To: <20170103134806.GA29807@redhat.com> (Vivek Goyal's message of
        "Tue, 3 Jan 2017 08:48:06 -0500")
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linas Vepstas <linasvepstas@gmail.com>, Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Seth Forshee <seth.forshee@canonical.com>

Vivek Goyal <vgoyal@redhat.com> writes:

> On Sun, Jan 01, 2017 at 02:32:20PM -0600, Linas Vepstas wrote:
>
> [..]
>> It's somehow ironic that the push for user-space mounts and containers
>> comes from this general fuzzy sensation that they are somehow "safer",
>> yet the changes to enable this provide a new attack surface for
>> privilege escalation. Funny world we live in. :-)  Happy New Year!
>
> Only if unprivileged users want to be able to mount overlayfs. Otherwise, a
> privileged user can just mount overlayfs on host and bind mount that
> inside container (this is what docker does). And then you don't have
> to worry about allowing unprivileged users to be able to allow
> mounting.

Which is a blame shifting game and we should not be playing.

A kernel feature useful for ordinary users for ordinary workloads
should not require special permissions to use.

Kernel features are built to be used.  User space programs will use
them.  If those features can not be used safely and we blame that on
userspace we are just not accepting the responsibility of making them
work ourselves.  A really jerk move.

In a change in what permissions are needed to use a kernel feature we
need to make the kernel change in small responsible steps.  Many kernel
features are not coded defensively so before we enable them for ordinary
users we need to do our best to ensure they are safe to use and ensure
their maintainers are on board with what is going on.

I can't see any policy that only allows root to mount things as healthy
or maintainable in the long term.  We have long exceeded the point where
root is the only user that wants to mount things.  So the best long term
strategy is to build a sufficient policy in the kernel that does not
require mediation by userspace.


Furthermore docker that does not need root privileges is currently being
debugged.  So we are long past any point where it even makes sense
to consider a policy of only allowing root to mount things.  That ship
has sailed.

Eric
