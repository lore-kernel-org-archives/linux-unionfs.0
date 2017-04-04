From: Tycho Andersen <tycho@docker.com>
Subject: Re: [PATCH 1/2] ovl: support freeze/thaw super
Date: Tue, 4 Apr 2017 13:07:52 -0600
Message-ID: <20170404190752.ocpdom2nkg7bvni3@docker>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
 <1484828008-27507-2-git-send-email-amir73il@gmail.com>
 <CAOQ4uxg-i0SMXRTDdPS2GxWKUYDKAu30wT9bjXX1Gd2CzeJ2Yg@mail.gmail.com>
 <588603D7.4060500@virtuozzo.com>
 <CAOQ4uxjoqSXOKTsp4n+NoRjcAs9qSQYc8dJgsAk3HN0jkhTUZw@mail.gmail.com>
 <20170404174752.GA15675@mail.hallyn.com>
 <20170404180146.v2pdsytu6pyqk3fl@docker>
 <CAOQ4uxjKoW88XgrMEd2hAAVyDnB8Mw3cgLEaSsQB_=Lkcd4stg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:37113 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753065AbdDDTHz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Apr 2017 15:07:55 -0400
Received: by mail-it0-f46.google.com with SMTP id a140so34381683ita.0
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Apr 2017 12:07:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjKoW88XgrMEd2hAAVyDnB8Mw3cgLEaSsQB_=Lkcd4stg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Stephane Graber <stgraber@ubuntu.com>, Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Pavel Emelyanov <xemul@virtuozzo.com>

On Tue, Apr 04, 2017 at 09:59:16PM +0300, Amir Goldstein wrote:
> On Tue, Apr 4, 2017 at 9:01 PM, Tycho Andersen <tycho@docker.com> wrote:
> > On Tue, Apr 04, 2017 at 12:47:52PM -0500, Serge E. Hallyn wrote:
> >> > Would lxc-snapshot gain anything from the ability to fsfreeze an overlay
> >> > mount?
> >>
> >> lxc-snapshot only works on stopped containers.  'lxc snapshot' can do live
> >> snapshots using criu.  Tycho, does that do anything right now to freeze the
> >> fs?
> >
> > Not that I'm aware of (CRIU might, but we don't in liblxc).
> >
> >> I'm not sure that freezing all the tasks is necessarily enough to settle
> >> the fs, but I assume you're doing something about that already?
> >
> > I suspect it's not, but we're not doing anything besides freezing the
> > tasks. In fact, we freeze the tasks by using the freezer cgroup,
> > which itself is buggy, since the freezer cgroup can race with various
> > filesystems. So, freezing tasks is hard, and I haven't even thought
> > about how to freeze the fs for real :)
> >
> > But in any case, an fs freezing primitive does sound useful for
> > checkpoint restore, assuming that we're right and freezing the tasks
> > is simply not enough.
> >
> 
> So I already asked Pavel that question and he said that freezing
> the tasks is enough. I am not convinced it is really enough to bring
> a file system image (i.e. underlying blockdev) to a quiescent state,
> but I think it may be enough for getting a stable view of the mounted
> file system, so the files could be dumped somewhere.
> I am guessing is what lxc snapshot does?

Yes, lxc snapshot is basically just a frontend for CRIU.

> I still didn't understand wrt lxc snapshot, is there a use case for
> taking live snapshots without using CRIU? (because freezer cgroup
> mentioned races or whatnot?).

No, I think CRIU is the only project that will ever attempt to do
checkpoint restore this way ;-). CRIU supports two different ways of
freezing tasks: one using the freezer cgroup and one without. The one
without doesn't work against fork bombs very well, and the one with
doesn't work because of some filesystems. So it's mostly a container
engine implementation choice which to use.

> It's definitely possible with btrfs and if my overlayfs freeze patches
> are not terribly wrong, then it should be easy with overlayfs as well.
> Does lxc snapshot already support live snapshot of btrfs container?

Yes, it does. It freezes the tasks via the cgroup freezer and then
does a btrfs snapshot of the filesystem once the tasks are frozen.

Tycho
