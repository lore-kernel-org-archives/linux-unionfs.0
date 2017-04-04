From: Tycho Andersen <tycho@docker.com>
Subject: Re: [PATCH 1/2] ovl: support freeze/thaw super
Date: Tue, 4 Apr 2017 12:01:46 -0600
Message-ID: <20170404180146.v2pdsytu6pyqk3fl@docker>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
 <1484828008-27507-2-git-send-email-amir73il@gmail.com>
 <CAOQ4uxg-i0SMXRTDdPS2GxWKUYDKAu30wT9bjXX1Gd2CzeJ2Yg@mail.gmail.com>
 <588603D7.4060500@virtuozzo.com>
 <CAOQ4uxjoqSXOKTsp4n+NoRjcAs9qSQYc8dJgsAk3HN0jkhTUZw@mail.gmail.com>
 <20170404174752.GA15675@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36683 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754090AbdDDSBs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Apr 2017 14:01:48 -0400
Received: by mail-it0-f43.google.com with SMTP id e75so69291957itd.1
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Apr 2017 11:01:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170404174752.GA15675@mail.hallyn.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Stephane Graber <stgraber@ubuntu.com>, Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Pavel Emelyanov <xemul@virtuozzo.com>

On Tue, Apr 04, 2017 at 12:47:52PM -0500, Serge E. Hallyn wrote:
> > Would lxc-snapshot gain anything from the ability to fsfreeze an overlay
> > mount?
> 
> lxc-snapshot only works on stopped containers.  'lxc snapshot' can do live
> snapshots using criu.  Tycho, does that do anything right now to freeze the
> fs?

Not that I'm aware of (CRIU might, but we don't in liblxc).

> I'm not sure that freezing all the tasks is necessarily enough to settle
> the fs, but I assume you're doing something about that already?

I suspect it's not, but we're not doing anything besides freezing the
tasks. In fact, we freeze the tasks by using the freezer cgroup,
which itself is buggy, since the freezer cgroup can race with various
filesystems. So, freezing tasks is hard, and I haven't even thought
about how to freeze the fs for real :)

But in any case, an fs freezing primitive does sound useful for
checkpoint restore, assuming that we're right and freezing the tasks
is simply not enough.

Tycho
