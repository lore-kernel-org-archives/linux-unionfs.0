From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] ovl: support freeze/thaw super
Date: Tue, 4 Apr 2017 21:59:16 +0300
Message-ID: <CAOQ4uxjKoW88XgrMEd2hAAVyDnB8Mw3cgLEaSsQB_=Lkcd4stg@mail.gmail.com>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
 <1484828008-27507-2-git-send-email-amir73il@gmail.com> <CAOQ4uxg-i0SMXRTDdPS2GxWKUYDKAu30wT9bjXX1Gd2CzeJ2Yg@mail.gmail.com>
 <588603D7.4060500@virtuozzo.com> <CAOQ4uxjoqSXOKTsp4n+NoRjcAs9qSQYc8dJgsAk3HN0jkhTUZw@mail.gmail.com>
 <20170404174752.GA15675@mail.hallyn.com> <20170404180146.v2pdsytu6pyqk3fl@docker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36006 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755711AbdDDS7R (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Apr 2017 14:59:17 -0400
In-Reply-To: <20170404180146.v2pdsytu6pyqk3fl@docker>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Tycho Andersen <tycho@docker.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Stephane Graber <stgraber@ubuntu.com>, Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Pavel Emelyanov <xemul@virtuozzo.com>

On Tue, Apr 4, 2017 at 9:01 PM, Tycho Andersen <tycho@docker.com> wrote:
> On Tue, Apr 04, 2017 at 12:47:52PM -0500, Serge E. Hallyn wrote:
>> > Would lxc-snapshot gain anything from the ability to fsfreeze an overlay
>> > mount?
>>
>> lxc-snapshot only works on stopped containers.  'lxc snapshot' can do live
>> snapshots using criu.  Tycho, does that do anything right now to freeze the
>> fs?
>
> Not that I'm aware of (CRIU might, but we don't in liblxc).
>
>> I'm not sure that freezing all the tasks is necessarily enough to settle
>> the fs, but I assume you're doing something about that already?
>
> I suspect it's not, but we're not doing anything besides freezing the
> tasks. In fact, we freeze the tasks by using the freezer cgroup,
> which itself is buggy, since the freezer cgroup can race with various
> filesystems. So, freezing tasks is hard, and I haven't even thought
> about how to freeze the fs for real :)
>
> But in any case, an fs freezing primitive does sound useful for
> checkpoint restore, assuming that we're right and freezing the tasks
> is simply not enough.
>

So I already asked Pavel that question and he said that freezing
the tasks is enough. I am not convinced it is really enough to bring
a file system image (i.e. underlying blockdev) to a quiescent state,
but I think it may be enough for getting a stable view of the mounted
file system, so the files could be dumped somewhere.
I am guessing is what lxc snapshot does?

I still didn't understand wrt lxc snapshot, is there a use case for
taking live snapshots without using CRIU? (because freezer cgroup
mentioned races or whatnot?).

It's definitely possible with btrfs and if my overlayfs freeze patches
are not terribly wrong, then it should be easy with overlayfs as well.
Does lxc snapshot already support live snapshot of btrfs container?

If there is interest, I can try to do a POC of live lxc snapshot of an
overlayfs container.

Amir.
